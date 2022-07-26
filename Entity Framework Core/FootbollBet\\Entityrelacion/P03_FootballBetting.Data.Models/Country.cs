using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace P03_FootballBetting.Data.Models
{
    public class Country
    {
        public int CountryId { get; set; }

        [MaxLength(1000)]
        public string Name { get; set; }

        public virtual ICollection<Town> Towns { get; set; }
    }
}
