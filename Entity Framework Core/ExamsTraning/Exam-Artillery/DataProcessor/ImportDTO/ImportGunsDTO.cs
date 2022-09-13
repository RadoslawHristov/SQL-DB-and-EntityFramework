﻿using Artillery.Data.Models.Enums;
using Artillery.Data.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Text;
using Newtonsoft.Json;

namespace Artillery.DataProcessor.ImportDto
{
    [JsonObject]
    public class ImportGunsDto
    {
        [JsonProperty("ManufacturerId")]
        public int ManufacturerId { get; set; }

        [Required]
        [Range(100, 1350000)]
        [JsonProperty("GunWeight")]
        public int GunWeight { get; set; }

        [Required]
        [Range(2.00, 35.00)]
        [JsonProperty("BarrelLength")]
        public double BarrelLength { get; set; }

        [JsonProperty("NumberBuild")]
        public int? NumberBuild { get; set; }

        [Required]
        [Range(1, 100000)]
        [JsonProperty("Range")]
        public int Range { get; set; }

        [Required]
        [JsonProperty("GunType")]
        public string GunType { get; set; }

        [Required]
        [JsonProperty("ShellId")]
        public int ShellId { get; set; }


        [JsonProperty("Countries")]
        public ImportGumCountryDto[] Countries { get; set; }
    }
}
