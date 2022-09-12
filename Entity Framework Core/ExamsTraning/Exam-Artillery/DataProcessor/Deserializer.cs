using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using Artillery.Data.Models;
using Artillery.Data.Models.Enums;
using Artillery.DataProcessor.ImportDto;
using Newtonsoft.Json;

namespace Artillery.DataProcessor
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using Artillery.Data;

    public class Deserializer
    {
        private const string ErrorMessage =
                "Invalid data.";
        private const string SuccessfulImportCountry =
            "Successfully import {0} with {1} army personnel.";
        private const string SuccessfulImportManufacturer =
            "Successfully import manufacturer {0} founded in {1}.";
        private const string SuccessfulImportShell =
            "Successfully import shell caliber #{0} weight {1} kg.";
        private const string SuccessfulImportGun =
            "Successfully import gun {0} with a total weight of {1} kg. and barrel length of {2} m.";

        public static string ImportCountries(ArtilleryContext context, string xmlString)
        {
            StringBuilder sb = new StringBuilder();
            XmlRootAttribute root = new XmlRootAttribute("Countries");
            XmlSerializer serializer = new XmlSerializer(typeof(ImportCountryDto[]), root);


            ICollection<Country> countries = new List<Country>();

            StringReader writer = new StringReader(xmlString);

            ImportCountryDto[] countryDtos = (ImportCountryDto[])serializer.Deserialize(writer);

            foreach (var dto in countryDtos)
            {
                if (!IsValid(dto))
                {
                    sb.AppendLine("Invalid data.");
                    continue;
                }

                Country country = new Country()
                {
                    CountryName = dto.CountryName,
                    ArmySize = dto.ArmySize
                };
                countries.Add(country);
                sb.AppendLine($"Successfully import {country.CountryName} with {country.ArmySize} army personnel.");
            }


            writer.Close();

            context.AddRange(countries);
            context.SaveChanges();

            return sb.ToString().TrimEnd();
        }

        public static string ImportManufacturers(ArtilleryContext context, string xmlString)
        {
            StringBuilder sb = new StringBuilder();
            XmlRootAttribute root = new XmlRootAttribute("Manufacturers");
            XmlSerializer serialize = new XmlSerializer(typeof(ImportManufactureDto[]), root);

            StringReader reader = new StringReader(xmlString);


            ImportManufactureDto[] dtos = (ImportManufactureDto[])serialize.Deserialize(reader);
            ICollection<Manufacturer> manufacturers = new List<Manufacturer>();
            List<string> allcountry = new List<string>();

            foreach (var dto in dtos)
            {
                if (!IsValid(dto))
                {
                    sb.AppendLine("Invalid data.");
                    continue;
                }

                if (allcountry.Contains(dto.ManufacturerName))
                {
                    sb.AppendLine("Invalid data.");
                    continue;
                }
                string[] country = dto.Founded.Split(", ");

                string counname = country[country.Length - 1];
                string city = country[country.Length - 2];
                
                string manName = dto.ManufacturerName;
                allcountry.Add(manName);
               

                Manufacturer manufacturer = new Manufacturer()
                {
                    ManufacturerName = dto.ManufacturerName,
                    Founded = dto.Founded
                };

                manufacturers.Add(manufacturer);
                sb.AppendLine($"Successfully import manufacturer {manufacturer.ManufacturerName} founded in {city}, {counname}.");
            }

            context.AddRange(manufacturers);
            context.SaveChanges();

            return sb.ToString().TrimEnd();
        }

        public static string ImportShells(ArtilleryContext context, string xmlString)
        {
            StringBuilder sb = new StringBuilder();
            XmlRootAttribute root = new XmlRootAttribute("Shells");
            XmlSerializer serializer = new XmlSerializer(typeof(ImportShellDto[]),root);

            ICollection<Shell> shells = new List<Shell>();

            StringReader reader = new StringReader(xmlString);


            ImportShellDto[] shellDtos = (ImportShellDto[])serializer.Deserialize(reader);


            foreach (var dto in shellDtos)
            {
                if (!IsValid(dto))
                {
                    sb.AppendLine("Invalid data.");
                    continue;
                }

                Shell shell = new Shell()
                {
                    ShellWeight = dto.ShellWeight,
                    Caliber = dto.Caliber
                };

                shells.Add(shell);
                sb.AppendLine($"Successfully import shell caliber #{shell.Caliber} weight {shell.ShellWeight} kg.");
            }

            context.AddRange(shells);
            context.SaveChanges();

            return sb.ToString().TrimEnd();
        }

        public static string ImportGuns(ArtilleryContext context, string jsonString)
        {
            StringBuilder sb = new StringBuilder();


            ImportGunsDto[] gunsDtos = JsonConvert.DeserializeObject<ImportGunsDto[]>(jsonString);

            ICollection<CountryGun> countryGuns = new List<CountryGun>();

            int count = 0;
            foreach (var dto in gunsDtos)
            {
                if (!IsValid(dto))
                {
                    sb.AppendLine("Invalid data.");
                    continue;
                }

                var manficIdValid = context.Manufacturers.FirstOrDefault(x => x.Id == dto.ManufacturerId);
                if (manficIdValid==null)
                {
                    sb.AppendLine("Invalid data.");
                    continue;
                }

                var ValidShellId = context.Shells.FirstOrDefault(x => x.Id == dto.ShellId);
                if (ValidShellId==null)
                {
                    sb.AppendLine("Invalid data.");
                    continue;
                }

                bool isValidEnum = Enum.TryParse(typeof(GunType),dto.GunType,out object gunTypesResult);
                if (!isValidEnum)
                {
                    sb.AppendLine("Invalid data.");
                    continue;
                }

                Gun gun = new Gun()
                {
                    ManufacturerId = dto.ManufacturerId,
                    GunWeight = dto.GunWeight,
                    BarrelLength = dto.BarrelLength,
                    NumberBuild = dto.NumberBuild,
                    Range = dto.Range,
                    GunType =(GunType)gunTypesResult,
                    ShellId = dto.ShellId
                };
                count++;
                foreach (var dtoCountry in dto.Countries)
                {
                    if (!IsValid(dtoCountry))
                    {
                        sb.AppendLine("Invalid data.");
                        continue;
                    }
                    CountryGun countryGun = new CountryGun()
                    {
                        CountryId = dtoCountry.Id,
                        Gun = gun
                    };
                    countryGuns.Add(countryGun);
                    gun.CountriesGuns.Add(countryGun);
                }
                sb.AppendLine($"Successfully import gun {gun.GunType} with a total weight of {gun.GunWeight} kg. and barrel length of {gun.BarrelLength} m.");
                sb.AppendLine(count.ToString());
            }

            context.AddRange(countryGuns);
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
