using System.IO;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using Trucks.DataProcessor.ExportDto;

namespace Trucks.DataProcessor
{
    using System;
    using Data;

    using Formatting = Newtonsoft.Json.Formatting;

    public class Serializer
    {
        public static string ExportDespatchersWithTheirTrucks(TrucksContext context)
        {
            StringBuilder sb = new StringBuilder();
            ExportDespecherDto[] exportDespecherDtos;

            var results = context.Despatchers
                .ToArray()
                .Where(x => x.Trucks.Count > 0)
                .Select(a => new ExportDespecherDto()
                {
                    TrucksCount = a.Trucks.Count,
                    Name = a.Name,
                    Trucks = a.Trucks.Select(x => new ExportDespTruckDto()
                    {
                        RegistrationNumber = x.RegistrationNumber,
                        Make = x.MakeType.ToString()
                    })
                        .OrderBy(x => x.RegistrationNumber)
                        .ToArray()
                })
                .OrderByDescending(z => z.TrucksCount)
                .ThenBy(x => x.Name)
                .ToArray();
            XmlRootAttribute root = new XmlRootAttribute("Despatchers");
            XmlSerializer serializer = new XmlSerializer(typeof(ExportDespecherDto[]), root);
            var namsp = new XmlSerializerNamespaces();
            namsp.Add("", "");
            using (StringWriter writer = new StringWriter(sb))
            {
                serializer.Serialize(writer, results, namsp);
            }

            return sb.ToString().TrimEnd();
        }

        public static string ExportClientsWithMostTrucks(TrucksContext context, int capacity)
        {

            var results = context.Clients
                .ToList()
                .Where(c => c.ClientsTrucks.Count > 0)
                .Select(a => new
                {
                    Name = a.Name,
                    Trucks = a.ClientsTrucks
                        .Select(t => new
                        {
                            TruckRegistrationNumber = t.Truck.RegistrationNumber,
                            VinNumber = t.Truck.VinNumber,
                            TankCapacity = t.Truck.TankCapacity,
                            CargoCapacity = t.Truck.CargoCapacity,
                            CategoryType = t.Truck.CategoryType.ToString(),
                            MakeType = t.Truck.MakeType.ToString()
                        })
                        .Where(x => x.TankCapacity >= capacity)
                        .OrderBy(z => z.MakeType)
                        .ThenByDescending(s => s.CargoCapacity)
                        .ToList()
                })
                .OrderByDescending(d => d.Trucks.Count)
                .ThenBy(n => n.Name)
                .Take(10)
                .ToList();



            var json = JsonConvert.SerializeObject(results, Formatting.Indented);


            return json;
        }
    }
}
