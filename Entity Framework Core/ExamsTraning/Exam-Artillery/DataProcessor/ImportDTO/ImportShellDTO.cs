using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;
using System.Xml.Serialization;

namespace Artillery.DataProcessor.ImportDto
{
    [XmlType("Shell")]
    public class ImportShellDto
    {
        [Required]
        [Range(maximum:1680,minimum: 2)]
        public double ShellWeight { get; set; }

        [Required]
        [StringLength(30, MinimumLength = 4)]
        public string Caliber { get; set; }
    }
}
