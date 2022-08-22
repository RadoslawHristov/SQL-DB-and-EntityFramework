using System.IO;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using Newtonsoft.Json;
using Trucks.Data.Models;
using Trucks.Data.Models.Enums;
using Trucks.DataProcessor.ImportDto;

namespace Trucks.DataProcessor
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    using Data;

    public class Deserializer
    {
        private const string ErrorMessage = "Invalid data!";

        private const string SuccessfullyImportedDespatcher
            = "Successfully imported despatcher - {0} with {1} trucks.";

        private const string SuccessfullyImportedClient
            = "Successfully imported client - {0} with {1} trucks.";

        public static string ImportDespatcher(TrucksContext context, string xmlString)
        {
            StringBuilder sb = new StringBuilder();
            XmlRootAttribute root = new XmlRootAttribute("Despatchers");
            XmlSerializer serializer = new XmlSerializer(typeof(ImportDespacheDto[]),root);
            ImportDespacheDto[] despacheDtos;

            ICollection<Despatcher> despatchers = new List<Despatcher>();

            using ( StringReader reader = new StringReader(xmlString))
            {
                despacheDtos = (ImportDespacheDto[])serializer.Deserialize(reader);
            }

            foreach (var dto in despacheDtos)
            {
                if (!IsValid(dto))
                {
                    sb.AppendLine(ErrorMessage);
                    continue;
                }

                if (string.IsNullOrEmpty(dto.Position))
                {
                    sb.AppendLine(ErrorMessage);
                    continue;
                }

                Despatcher despatcher = new Despatcher()
                {
                    Name = dto.Name,
                    Position = dto.Position
                };

                foreach (var tru in dto.Trucks)
                {
                    if (!IsValid(tru))
                    {
                        sb.AppendLine(ErrorMessage);
                        continue;
                    }

                    bool isValidcategory = Enum.TryParse(typeof(CategoryType),tru.CategoryType,out object caResult );
                    if (!isValidcategory)
                    {
                        sb.AppendLine(ErrorMessage);
                        continue;
                    }
                    bool isValidType = Enum.TryParse(typeof(MakeType), tru.MakeType, out object tResult);
                    if (tru.CargoCapacity==null || tru.TankCapacity == null) 
                    {

                        sb.AppendLine(ErrorMessage);
                        continue;
                    }
                    Truck truck = new Truck()
                    {
                        RegistrationNumber = tru.RegistrationNumber,
                        VinNumber = tru.VinNumber,
                        TankCapacity = tru.TankCapacity,
                        CargoCapacity = tru.CargoCapacity,
                        CategoryType = (CategoryType)caResult,
                        MakeType = (MakeType)tResult
                    };

                    despatcher.Trucks.Add(truck);
                   
                }
                despatchers.Add(despatcher);
                sb.AppendLine(String.Format(SuccessfullyImportedDespatcher,despatcher.Name,despatcher.Trucks.Count));
            }

           context.AddRange(despatchers);
           context.SaveChanges();


            return sb.ToString().TrimEnd();
        }
        public static string ImportClient(TrucksContext context, string jsonString)
        {
            ImportClietDto[] importClietDtos = JsonConvert.DeserializeObject<ImportClietDto[]>(jsonString);
            StringBuilder sb = new StringBuilder();

            ICollection<ClientTruck> clientTrucks = new List<ClientTruck>();
            ICollection<Client> clients = new List<Client>();
            foreach (var dto in importClietDtos)
            {
                if (!IsValid(dto) || dto.Type== "usual")
                {
                    sb.AppendLine(ErrorMessage);
                    continue;
                }

                Client client = new Client()
                {
                    Name = dto.Name,
                    Nationality = dto.Nationality,
                    Type = dto.Type
                };

                clients.Add(client);
                foreach (var truck in dto.Trucks.Distinct())
                {
                    var trucks = context.Trucks.FirstOrDefault(x => x.Id == truck);

                    if (trucks==null)
                    {
                        sb.AppendLine(ErrorMessage);
                        continue;
                    }


                    ClientTruck clientTruck = new ClientTruck()
                    {
                        Client = client,
                        TruckId = truck
                    };
                    client.ClientsTrucks.Add(clientTruck);
                    clientTrucks.Add(clientTruck);
                }

                sb.AppendLine(String.Format(SuccessfullyImportedClient,client.Name,client.ClientsTrucks.Count));

            }

            context.AddRange(clientTrucks);
            context.SaveChanges();

            return sb.ToString().TrimEnd();
        }

        private static bool IsValid(object dto)
        {
            var validationContext = new ValidationContext(dto);
            var validationResult = new List<ValidationResult>();

            return Validator.TryValidateObject(dto, validationContext, validationResult, true);
        }
    }
}
