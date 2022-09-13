using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;
using System.Xml.Serialization;

namespace Artillery.DataProcessor.ExportDto
{
    [XmlType("Country")]
    public class ExportManfucWithGunsDto
    {
        [XmlAttribute("Country")] 
        public string CountryName { get; set; }

        [XmlAttribute("ArmySize")]
        public long ArmySize { get; set; }
    }
}
