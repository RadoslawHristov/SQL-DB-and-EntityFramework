using System.Text;
using Microsoft.Data.SqlClient;

namespace _5.Change_Town_Names_Casing
{
    internal class Program
    {
        static void Main(string[] args)
        {
            SqlConnection connect = new SqlConnection(Config.GethPath);

            string country = Console.ReadLine();
            StringBuilder sv = new StringBuilder();

            try
            {
                connect.Open();

                string queryOfCountry = @"SELECT DISTINCT t.Name 
                                         FROM Towns as t
                                         JOIN Countries AS c ON c.Id = t.CountryCode
                                         WHERE c.Name = @countryName";

                SqlCommand ComandCountry = new SqlCommand(queryOfCountry, connect);
                ComandCountry.Parameters.AddWithValue("@countryName", country);

                SqlDataReader countryReader = ComandCountry.ExecuteReader();

                if (!countryReader.HasRows)
                {
                    Console.WriteLine("No town names were affected.");

                }
                else
                {
                    int count = 0;

                    while (countryReader.Read())
                    {
                        count++;
                        string town = (string)countryReader["Name"];
                        sv.Append($"{town} ");
                    }
                    Console.WriteLine($" {count} town names were affected.");
                    foreach (var str in sv.ToString().TrimEnd())
                    {
                        Console.Write(string.Join(", ", str).ToString());
                    }
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }
        }
    }
}