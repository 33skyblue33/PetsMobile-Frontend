using System.Security.Cryptography;
using System.Text;
using PetsMobile.Services.Interface;

namespace PetsMobile.Services
{
    public class PasswordHasher : IPasswordHasher
    {
        public string Hash(string password)
        {
            StringBuilder builder = new();

            using (var hasher = SHA256.Create())
            {
                byte[] bytes = hasher.ComputeHash(Encoding.UTF8.GetBytes(password));

                for(int i = 0; i < bytes.Length; i++)
                {
                    builder.Append(bytes[i].ToString("x2"));
                }
            }

            return builder.ToString();
        }

        public bool Verify(string password, string hash)
        {
            return hash.Equals(Hash(password));
        }
    }
}
