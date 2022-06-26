using Microsoft.Data.SqlClient;

namespace Remove_Villain
{
    internal class Program
    {
        static void Main(string[] args)
        {
            SqlConnection conectionn = new SqlConnection(Config.Connectstr);

            conectionn.Open();

            int id = int.Parse(Console.ReadLine());


            string findDelleteId = @"SELECT Name FROM Villains WHERE Id = @villainId";

            SqlCommand delVilliains = new SqlCommand(findDelleteId, conectionn);
            delVilliains.Parameters.AddWithValue("@villainId", id);
            
            object ResultIDDell= delVilliains.ExecuteScalar();
            
            if (ResultIDDell == null)
            {
                Console.WriteLine("No such villain was found.");
            }
            
            SqlTransaction trasTransaction = conectionn.BeginTransaction();

            string delMinVil = @" DELETE FROM MinionsVillains
                                    WHERE VillainId = @villainId";
                
            string delVill = @"DELETE FROM Villains
                                WHERE Id = @villainId";

            SqlCommand comandDel = new SqlCommand(delMinVil, conectionn);
            comandDel.Parameters.AddWithValue("@villainId", id);

            SqlCommand delVillians = new SqlCommand(delVill, conectionn);
            delVillians.Parameters.AddWithValue("@villainId", id);

            trasTransaction.Commit();
            object countMinions = comandDel.ExecuteNonQuery();
            conectionn.Close();

            Console.WriteLine($"{ResultIDDell} was deleted.");
            Console.WriteLine($"{countMinions} minions were released.");



        }
    }
}