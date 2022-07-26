using System.Collections;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace P03_FootballBetting.Data.Models
{
    public class Town
    {
        public int TownId { get; set; }

        [MaxLength(800)]
        public string Name { get; set; }


        [ForeignKey(nameof(Country))]
        public int CountryId { get; set; }
        public virtual Country Country { get; set; }


        public virtual ICollection<Team> Teams { get; set; }
    }
}
