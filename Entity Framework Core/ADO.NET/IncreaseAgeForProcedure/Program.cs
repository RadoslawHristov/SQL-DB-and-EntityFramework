using Microsoft.Data.SqlClient;

namespace Increase_Age_Stored_Procedure
{
    internal class Program
    {
        static void Main(string[] args)
        {
            int birthdayMinionId = int.Parse(Console.ReadLine());

            var connection = new SqlConnection(Config.KeyStr);
            connection.Open();

            using (connection)
            {
                string cmdText = "EXEC usp_GetOlder @id";
                var command = new SqlCommand(cmdText, connection);
                command.Parameters.AddWithValue("@id", birthdayMinionId);
                command.ExecuteNonQuery();

                string printQuery = "SELECT Name, Age FROM Minions WHERE Id = @id";
                var printCommand = new SqlCommand(printQuery, connection);
                printCommand.Parameters.AddWithValue("id", birthdayMinionId);
                var printer = printCommand.ExecuteReader();

                printer.Read();
                string minionName = (string)printer["Name"];
                int age = (int)printer["Age"];
                printer.Close();

                Console.WriteLine($"{minionName} - {age} years old");
            }
        }
    }
}