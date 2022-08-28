using System.Globalization;
using System.IO;
using System.Text;
using System.Threading;
using System.Xml.Serialization;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using Theatre.Data;
using Theatre.Data.Models;
using Theatre.Data.Models.Enums;
using Theatre.DataProcessor.ImportDto;

namespace Theatre.DataProcessor
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public class Deserializer
    {
        public CultureInfo inf = new CultureInfo("en-US");
        
        private const string ErrorMessage = "Invalid data!";

        private const string SuccessfulImportPlay
            = "Successfully imported {0} with genre {1} and a rating of {2}!";

        private const string SuccessfulImportActor
            = "Successfully imported actor {0} as a {1} character!";

        private const string SuccessfulImportTheatre
            = "Successfully imported theatre {0} with #{1} tickets!";

        public static string ImportPlays(TheatreContext context, string xmlString)
        {
            StringBuilder sb = new StringBuilder();
            XmlRootAttribute root = new XmlRootAttribute("Plays");
            XmlSerializer serializer = new XmlSerializer(typeof(ImportPlaysDto[]),root);
            ImportPlaysDto[] playsDtos;


            ICollection<Play> plays = new List<Play>();
            using (StringReader reader =new StringReader(xmlString))
            {
                playsDtos = (ImportPlaysDto[]) serializer.Deserialize(reader);
            }

            foreach (var dto in playsDtos)
            {
                if (!IsValid(dto))
                {
                    sb.AppendLine(ErrorMessage);
                    continue;
                }


                TimeSpan duration =TimeSpan.ParseExact(dto.Duration,"c",CultureInfo.InstalledUICulture);
                if (duration.Hours < 1)
                {
                    sb.AppendLine(ErrorMessage);
                    continue;
                }

                bool isValidEnum = Enum.TryParse(typeof(Genre),dto.Genre,out object enums);
                if (!isValidEnum)
                {
                    sb.AppendLine(ErrorMessage);
                    continue;
                }

                Play play = new Play()
                {
                    Title = dto.Title,
                    Duration = duration,
                    Rating = dto.Rating,
                    Genre = (Genre) enums,
                    Description = dto.Description,
                    Screenwriter = dto.Screenwriter
                };

                plays.Add(play);
                sb.AppendLine(String.Format(SuccessfulImportPlay,play.Title,play.Genre,play.Rating.ToString(CultureInfo.InvariantCulture)));
            }

            context.AddRange(plays);
            context.SaveChanges();

            return sb.ToString().TrimEnd(); 
        }

        public static string ImportCasts(TheatreContext context, string xmlString)
        {
            StringBuilder sb = new StringBuilder();
            XmlRootAttribute root = new XmlRootAttribute("Casts");
            XmlSerializer serializer = new XmlSerializer(typeof(ImportCastDto[]),root);
            ImportCastDto[] castDtos;

            ICollection<Cast> casts = new List<Cast>();
            using (StringReader reader =new StringReader(xmlString))
            {
                castDtos = (ImportCastDto[]) serializer.Deserialize(reader);
            }

            foreach (var dto in castDtos)
            {
                if (!IsValid(dto))
                {
                    sb.AppendLine(ErrorMessage);
                    continue;
                }

                Cast cast = new Cast()
                {
                    FullName = dto.FullName,
                    IsMainCharacter = dto.IsMainCharacter,
                    PhoneNumber = dto.PhoneNumber,
                    PlayId = dto.PlayId
                };

                casts.Add(cast);
                sb.AppendLine(String.Format(SuccessfulImportActor,dto.FullName,dto.IsMainCharacter==true? "main": "lesser"));
            }

            context.AddRange(casts);
            context.SaveChanges();

           return sb.ToString().TrimEnd();
        }

        public static string ImportTtheatersTickets(TheatreContext context, string jsonString)
        {
            StringBuilder sb = new StringBuilder();
            ImportTheaterDto[] teDtos = JsonConvert.DeserializeObject<ImportTheaterDto[]>(jsonString);


            ICollection<Data.Models.Theatre> teTheatres = new List<Data.Models.Theatre>();
            ICollection<Ticket> tickets = new List<Ticket>();
            foreach (var dto in teDtos)
            {
                if (!IsValid(dto))
                {
                    sb.AppendLine(ErrorMessage);
                    continue;
                }

                Data.Models.Theatre teTheatre = new Data.Models.Theatre()
                {
                    Name = dto.Name,
                    NumberOfHalls = dto.NumberOfHalls,
                    Director = dto.Director,
                };

                int count = 0;
                foreach (var tik in dto.Tickets)
                {
                    if (!IsValid(tik))
                    {
                        sb.AppendLine(ErrorMessage);
                        continue;
                    }  

                    Ticket ticket = new Ticket()
                    {
                        Price = tik.Price,
                        RowNumber = tik.RowNumber,
                        PlayId = tik.PlayId,
                        Theatre = teTheatre
                    };
                    count++;
                    tickets.Add(ticket);
                }
                teTheatres.Add(teTheatre);
                sb.AppendLine(String.Format(SuccessfulImportTheatre,teTheatre.Name,count));
            }

            context.AddRange(teTheatres);
            context.AddRange(tickets);
            context.SaveChanges();

            return sb.ToString().TrimEnd();
        }


        private static bool IsValid(object obj)
        {
            var validator = new ValidationContext(obj);
            var validationRes = new List<ValidationResult>();

            var result = Validator.TryValidateObject(obj, validator, validationRes, true);
            return result;
        }
    }
}
