using System.Data.SqlClient;

namespace Villain_Names
{
    internal class Program
    {
        static void Main(string[] args)
        {
            SqlConnection connect = new SqlConnection(Config.ConnectionStr);


            connect.Open();

            string Countquery = @" SELECT v.Name, COUNT(mv.VillainId) AS MinionsCount
                                    FROM Villains AS v
                                    JOIN MinionsVillains AS mv ON v.Id = mv.VillainId
                                    GROUP BY v.Id, v.Name
                                        HAVING COUNT(mv.VillainId) > 3
                                    ORDER BY COUNT(mv.VillainId)";


            SqlCommand countOfMinions = new SqlCommand(Countquery,connect);

            SqlDataReader reader = countOfMinions.ExecuteReader();

            while (reader.Read())
            {
                    
                    string name = (string)reader["Name"];
                    int idEvil = (int)reader["MinionsCount"];

                    Console.WriteLine($" {name} - {idEvil}");
            }
            connect.Close();
        }
    }
}