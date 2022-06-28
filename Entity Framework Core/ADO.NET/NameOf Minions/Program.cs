using Microsoft.Data.SqlClient;

namespace Minion_Names
{
    internal class Program
    {
        static void Main(string[] args)
        {
            SqlConnection connection = new SqlConnection(Config.ConfigPath);

            // Find the Villians id in database 
            connection.Open();
            int id = int.Parse(Console.ReadLine());

            string queryNamOfVal = @"SELECT Name FROM Villains WHERE Id = @Id";

            SqlCommand command = new SqlCommand(queryNamOfVal,connection);
            command.Parameters.AddWithValue("@id", id);

            object nameComandVal = command.ExecuteScalar();

            if (nameComandVal == null)
            {
                Console.WriteLine($"No villain with ID {id} exists in the database.");
            }
            

            // Find all minions of the villians 
            string queryOfMinions = @"SELECT ROW_NUMBER() OVER (ORDER BY m.Name) as RowNum,
                                         m.Name, 
                                         m.Age
                                    FROM MinionsVillains AS mv
                                    JOIN Minions As m ON mv.MinionId = m.Id
                                   WHERE mv.VillainId = @Id
                                ORDER BY m.Name";

            SqlCommand findMinnions = new SqlCommand(queryOfMinions,connection);
            findMinnions.Parameters.AddWithValue("@id", id);

            SqlDataReader readerMinions=findMinnions.ExecuteReader();

            if (!readerMinions.HasRows)
            {
                Console.WriteLine("(no minions)"); 
            }

            Console.WriteLine("");
            while (readerMinions.Read())
            {
                int row = (int)readerMinions.GetInt64(0);
                string name = (string)readerMinions["Name"];
                int age = (int)readerMinions["Age"];

                Console.WriteLine($"{row}. {name} {age}");
            }
            readerMinions.Close();
        }
    }
}