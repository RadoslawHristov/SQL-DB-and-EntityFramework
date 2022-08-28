using System.IO;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using Newtonsoft.Json;
using Theatre.DataProcessor.ExportDto;
using Theatre.DataProcessor.ImportDto;

namespace Theatre.DataProcessor
{
    using AutoMapper;
    using System;
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.Xml.Linq;
    using Theatre.Data;
    using Theatre.Data.Models;

    public class Serializer
    {
        private static IMapper mapper;
        public static string ExportTheatres(TheatreContext context, int numbersOfHalls)
        {

            var results =context.Theatres
                .ToArray()
                .Where(x=>x.NumberOfHalls >= numbersOfHalls && x.Tickets.Count >= 20)
                .Select(a=> new 
                {
                    Name = a.Name,
                    Halls =a.NumberOfHalls,
                    TotalIncome = a.Tickets.Where(z=>z.RowNumber >= 1 && z.RowNumber <= 5).Sum(z=>z.Price),
                    Tickets =a.Tickets.Select(t=> new
                    {
                        Price=t.Price,
                        RowNumber = t.RowNumber,
                    })
                        .Where(d=>d.RowNumber >= 1 && d.RowNumber <= 5)
                        .OrderByDescending(p=>p.Price)
                        .ToArray()
                })
                .OrderByDescending(s=>s.Halls)
                .ThenBy(s=>s.Name)
                .ToArray();


            var rest = JsonConvert.SerializeObject(results,Formatting.Indented);



            return rest;
        }

        public static string ExportPlays(TheatreContext context, double rating)
        {
            GenerateMapper();

            var plays = context.Plays
                .ToList()
                .Where(p => p.Rating <= rating)
            .ToList();

            var playDtos = mapper.Map<List<ExportPlayerDto>>(plays)
                .OrderBy(p => p.Title)
                .ThenByDescending(p => p.Genre)
                .ToList();

            foreach (var play in playDtos)
            {
                play.Actors = play.Actors.OrderByDescending(a => a.FullName).ToList();

                foreach (var actor in play.Actors)
                {
                    actor.IsMainCharacter = $"Plays main character in '{play.Title}'.";
                }
            }

            return XmlSerializer<List<ExportPlayerDto>>(playDtos, "Plays");
        }
        private static void GenerateMapper()
        {
            MapperConfiguration config = new MapperConfiguration(cnfg =>
            {
                cnfg.AddProfile<TheatreProfile>();
            });

            mapper = config.CreateMapper();
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
    }
}
