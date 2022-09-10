using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Numerics;
using System.Text;

namespace Artillery.Data.Models
{
    public class Country
    {
        public Country()
        {
            this.CountriesGuns = new List<CountryGun>();
        }

        [Key]
        public int Id { get; set; }

        [Required]
        [StringLength(60,MinimumLength = 4)]
        public string CountryName { get; set; }

        [Required]
        [Range(50000,10000000)]
        public long ArmySize { get; set; }

        public virtual ICollection<CountryGun> CountriesGuns { get; set; }
    }
}
