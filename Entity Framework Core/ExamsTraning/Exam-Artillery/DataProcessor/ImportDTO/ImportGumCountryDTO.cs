using System;
using System.Collections.Generic;
using System.Text;
using Newtonsoft.Json;

namespace Artillery.DataProcessor.ImportDto
{
    public class ImportGumCountryDto
    {
        [JsonProperty("Id")]
        public int Id { get; set; }
    }
}
