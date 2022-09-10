﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace Artillery.Data.Models
{
    public class Shell
    {
        public Shell()
        {
            this.Guns = new HashSet<Gun>();
        }

        [Key]
        public int Id { get; set; }

        [Required]
        [Range(1680,2)]
        public double ShellWeight { get; set; }

        [Required]
        [StringLength(30,MinimumLength = 4)]
        public string Caliber { get; set; }


        public virtual ICollection<Gun> Guns { get; set; }
    }
}
