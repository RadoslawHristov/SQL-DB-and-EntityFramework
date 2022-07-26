using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text;

namespace P03_FootballBetting.Data.Models
{
    public class Game
    {
        [Key]
        public int GameId { get; set; }

        [NotMapped]
        [ForeignKey(nameof(HomeTeam))]
        public int HomeTeamId { get; set; }
        [NotMapped]
        public Team HomeTeam { get; set; }

        [NotMapped]
        [ForeignKey(nameof(AwayTeam))]
        public int AwayTeamId { get; set; }
        [NotMapped]
        public virtual Team AwayTeam { get; set; }

        public int HomeTeamGoals { get; set; }

        public  int AwayTeamGoals { get; set; }

        public DateTime DateTime { get; set; }

        public double HomeTeamBetRate { get; set; }

        public double AwayTeamBetRate { get; set; }

        public double DrawBetRate { get; set; }

        public double Result { get; set; }

        public virtual ICollection<PlayerStatistic> PlayerStatistics { get; set; }
        public virtual ICollection<Bet> Bets { get; set; }
    }
}
