using Microsoft.Data.SqlClient;

namespace Print_All_Minion_Names
{
    internal class Program
    {
        static void Main(string[] args)
        {
            var minions = new List<string>();

            var connection = new SqlConnection(Config.KeyStr);
            connection.Open();

            using (connection)
            {
                string cmdText = "SELECT Name FROM Minions";
                var command = new SqlCommand(cmdText, connection);
                var reader = command.ExecuteReader();

                while (reader.Read())
                {
                    string name = (string)reader["Name"];
                    minions.Add(name);
                }

                reader.Close();

                int count = minions.Count;
                int loopEnd = count / 2;

                for (int i = 0; i < loopEnd; i++)
                {
                    Console.WriteLine(minions[i]);
                    Console.WriteLine(minions[count - 1 - i]);
                }

                if (count % 2 == 1)
                {
                    Console.WriteLine(minions[count / 2]);
                }
            }
        }
    }
}