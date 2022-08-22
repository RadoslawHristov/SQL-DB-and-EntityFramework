using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;
using System.Xml.Serialization;
using Trucks.Data.Models.Enums;

namespace Trucks.DataProcessor.ImportDto
{
    [XmlType("Truck")]
    public class ImportDespacheTruckDto
    {
        [MinLength(8)]
        [MaxLength(8)]
        [XmlElement("RegistrationNumber")]
        [RegularExpression(@"^([A-Z]{2}\d{4}[A-Z]{2})$")]
        public string RegistrationNumber { get; set; }

        [Required]
        [MinLength(17)]
        [MaxLength(17)]
        [XmlElement("VinNumber")]
        public string VinNumber { get; set; }

        [Range(950, 1420)]
        [XmlElement("TankCapacity")]
        public int? TankCapacity { get; set; }

        [Range(5000, 29000)]
        [XmlElement("CargoCapacity")]
        public int? CargoCapacity { get; set; }

        [Required]
        [XmlElement("CategoryType")]
        public string CategoryType { get; set; }

        [Required]
        [XmlElement("MakeType")]
        public string MakeType { get; set; }
    }
}
