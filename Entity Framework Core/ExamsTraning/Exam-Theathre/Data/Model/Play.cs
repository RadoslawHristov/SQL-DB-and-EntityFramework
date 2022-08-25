using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text;
using Theatre.Data.Models.Enums;

namespace Theatre.Data.Models
{
    public class Play
    {
        public Play()
        {
            this.Casts = new List<Cast>();
            this.Tickets = new List<Ticket>();
        }

        [Key]
        public int Id { get; set; }

        [Required]
        [StringLength(50,MinimumLength = 4)]
        public string Title { get; set; }

        [Required]
        [Column(TypeName = "time")]
        public TimeSpan Duration { get; set; }

        [Required]
        [Range(typeof(float),"0.0","10.0")]
        public float Rating { get; set; }

        [Required]
        public Genre Genre { get; set; }

        [Required]
        [MaxLength(700)]
        public string Description { get; set; }

        [Required]
        [StringLength(30,MinimumLength = 4)]
        public string Screenwriter { get; set; }

        public List<Cast> Casts { get; set; }

        public List<Ticket> Tickets { get; set; }
    }
}
