using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;
using System.Xml.Serialization;

namespace Artillery.DataProcessor.ImportDto
{
    [XmlType("Country")]
    public class ImportCountryDto
    {
        [Required]
        [StringLength(60, MinimumLength = 4)]
        public string CountryName { get; set; }

        [Required]
        [Range(50000, 10000000)]
        public long ArmySize { get; set; }
    }
}
