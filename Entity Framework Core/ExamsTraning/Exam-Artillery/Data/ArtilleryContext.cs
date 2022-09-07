using System.IO.Compression;
using System.Xml.Serialization;
using Artillery.Data.Models;

namespace Artillery.Data
{
    using Microsoft.EntityFrameworkCore;

    public class ArtilleryContext : DbContext
    {
        public ArtilleryContext() { }

        public ArtilleryContext(DbContextOptions options)
            : base(options) { }


        public virtual DbSet<Country> Countries { get; set; }

        public virtual DbSet<Manufacturer>  Manufacturers { get; set; }

        public virtual DbSet<Shell> Shells { get; set; }    

        public virtual DbSet<Gun>  Guns { get; set; }

        public virtual DbSet<CountryGun> CountriesGuns { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                optionsBuilder
                    .UseSqlServer(Configuration.ConnectionString);
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<CountryGun>().HasKey(x => new {x.CountryId,x.GunId });

            modelBuilder.Entity<Manufacturer>().HasIndex(u => u.ManufacturerName).IsUnique();
        }
    }
}
