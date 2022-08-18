using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace Trucks.Data.Models
{
    public class Despatcher
    {
        public Despatcher()
        {
            this.Trucks = new List<Truck>();
        }

        [Key]
        [Required]
        public int Id { get; set; }

        [Required]
        [StringLength(40,MinimumLength = 2)]
        public string Name { get; set; }

       
        public string Position { get; set; }    

        public virtual List<Truck> Trucks { get; set; }
    }
}
