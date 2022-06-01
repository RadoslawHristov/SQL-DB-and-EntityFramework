using System;
using System.Collections.Generic;
using System.ComponentModel;

namespace DB_CRUD_Basic.Models
{
    public partial class Registration
    {
        public int Id { get; set; }
        [DisplayName("First Name")]
        public string FirstName { get; set; } = null!;
        [DisplayName("Last Name")]
        public string LastName { get; set; } = null!;
        [DisplayName("Date Of Birth")]
        public DateTime? Data { get; set; }
    }
}
