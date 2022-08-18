using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text;
using AutoMapper;
using Trucks.Data.Models.Enums;

namespace Trucks.Data.Models
{
    public class Truck
    {
        public Truck()
        {
            this.ClientsTrucks = new List<ClientTruck>();
        }

        [Key]
        [Required]
        public int Id { get; set; }

        [MinLength(8)]
        [MaxLength(8)]
        public string RegistrationNumber { get; set; }

        [Required]
        [MinLength(17)]
        [MaxLength(17)]
        public string VinNumber { get; set; }

        [Range(950,1420)]
        public int? TankCapacity { get; set; }

        [Range(5000,29000)]
        public int? CargoCapacity { get; set; }

        [Required]
        public CategoryType CategoryType { get; set; }

        [Required]
        public MakeType MakeType { get; set; }

        [Required]
        [ForeignKey(nameof(Despatcher))]
        public int DespatcherId { get; set; }
        public virtual Despatcher Despatcher { get; set; }


        public virtual List<ClientTruck> ClientsTrucks { get; set; }
    }
}
