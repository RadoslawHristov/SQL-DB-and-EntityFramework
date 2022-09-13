using Artillery.Data.Models.Enums;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;
using Newtonsoft.Json;

namespace Artillery.DataProcessor.ExportDto
{
    public class ExportShellWithGunDto
    {
        [Required]
        [JsonProperty("GunType")]
        public string GunType { get; set; }

        [Required]
        [JsonProperty("GunWeight")]
        [Range(100, 1350000)]
        public int GunWeight { get; set; }

        [Required]
        [JsonProperty("BarrelLength")]  
        [Range(2.00, 35.00)]
        public double BarrelLength { get; set; }

        [Required]
        [JsonProperty("Range")]
        [Range(1, 100000)]
        public string Range { get; set; }

    }
}
