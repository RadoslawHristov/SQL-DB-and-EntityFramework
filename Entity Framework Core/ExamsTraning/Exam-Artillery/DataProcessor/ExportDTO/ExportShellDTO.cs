using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;
using Newtonsoft.Json;

namespace Artillery.DataProcessor.ExportDto
{
    [JsonObject]
    public class ExportShellDto
    {
        [Required]
        [Range(1680, 2)]
        [JsonProperty("ShellWeight")]
        public double ShellWeight { get; set; }

        [Required]
        [JsonProperty("Caliber")]
        [StringLength(30, MinimumLength = 4)]
        public string Caliber { get; set; }

        [JsonProperty("Guns")]
        public ICollection<ExportShellWithGunDto> Guns { get; set; }
    }
}
