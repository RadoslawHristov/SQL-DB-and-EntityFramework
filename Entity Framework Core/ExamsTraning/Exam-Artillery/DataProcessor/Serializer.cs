
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Xml.Serialization;
using Artillery.Data.Models.Enums;
using AutoMapper.QueryableExtensions;
using Microsoft.EntityFrameworkCore;
using Microsoft.VisualBasic;
using Newtonsoft.Json;

namespace Artillery.DataProcessor
{
    using Artillery.Data;
    using Artillery.DataProcessor.ExportDto;
    using AutoMapper;
    using System;

    public class Serializer
    {
        private static IMapper mapper;
        public static string ExportShells(ArtilleryContext context, double shellWeight)
        {

            var result = context.Shells
                .Where(s => s.ShellWeight > shellWeight)
                .ToList()
                .Select(x => new ExportShellDto()
                {
                    ShellWeight = x.ShellWeight,
                    Caliber = x.Caliber,
                    Guns = x.Guns
                        .Select(s => new ExportShellWithGunDto()
                        {
                            GunType = s.GunType.ToString(),
                            GunWeight = s.GunWeight,
                            BarrelLength = s.BarrelLength,
                            Range = int.Parse(s.Range.ToString()) > 3000 ? "Long-range" : "Regular range"
                        })
                        .Where(g => g.GunType == GunType.AntiAircraftGun.ToString())
                        .OrderByDescending(z => z.GunWeight)
                        .ToList()
                })
                .OrderBy(x => x.ShellWeight)
                .ToList();

            var json = JsonConvert.SerializeObject(result, Formatting.Indented);

            return json;
        }

        public static string ExportGuns(ArtilleryContext context, string manufacturer)
        {
            var guns = context.Guns
                .Where(g => g.Manufacturer.ManufacturerName == manufacturer)
                .Select(x=>new ExportGunsDto()
                {
                    Manufacturer =x.Manufacturer.ManufacturerName,
                    GunType = x.GunType.ToString(),
                    GunWeight = x.GunWeight,
                    BarrelLength = x.BarrelLength,
                    Range = x.Range,
                    Countries = x.CountriesGuns.Select(s=> new ExportManfucWithGunsDto()
                    {
                        CountryName = s.Country.CountryName,
                        ArmySize = s.Country.ArmySize
                    })
                        .Where(a=>a.ArmySize > 4500000)
                        .ToList()
                })
                .ToList()
                .OrderBy(g => g.BarrelLength)
                .ToList();

           

            return XmlSerializer<List<ExportGunsDto>>(guns, "Guns");
        }
        private static string XmlSerializer<T>(T dto, string rootTag)
        {
            var sb = new StringBuilder();

            var root = new XmlRootAttribute(rootTag);
            var namespaces = new XmlSerializerNamespaces();
            namespaces.Add(String.Empty, String.Empty);

            var serializer = new XmlSerializer(typeof(T), root);

            using (StringWriter writer = new StringWriter(sb))
            {
                serializer.Serialize(writer, dto, namespaces);
            }

            return sb.ToString().TrimEnd();
        }

        private static void GenerateMapper()
        {
            MapperConfiguration config = new MapperConfiguration(cnfg =>
            {
                cnfg.AddProfile<ArtilleryProfile>();
            });

            mapper = config.CreateMapper();
        }
    }
}
