using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using Microsoft.IdentityModel.Tokens;
using PetsMobile.Entities;
using PetsMobile.Services.Interface;

namespace PetsMobile.Services
{
    public class TokenGenerator : ITokenGenerator
    {
        private readonly IConfiguration _configuration;
        private readonly SymmetricSecurityKey _securityKey;

        public TokenGenerator(IConfiguration configuration)
        {
            _configuration = configuration;
            _securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration.GetValue<string>("Jwt:Key") ?? ""));
        }

        public string GenerateAccessToken(User user)
        {
            List<Claim> claims = new()
            {
                new Claim(JwtRegisteredClaimNames.Sub, user.Id.ToString()),
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                new Claim(JwtRegisteredClaimNames.Email, user.Email),
                new Claim(ClaimTypes.Name, user.Name + " " + user.Surname),
                new Claim(ClaimTypes.Role, user.Role.ToString())
            };

            SigningCredentials credentials = new(_securityKey, SecurityAlgorithms.HmacSha256);

            double expirationMinutes = _configuration.GetValue<double>("Jwt:AccessTokenExpirationMinutes", 15);

            SecurityTokenDescriptor tokenDescriptor = new()
            {
                Subject = new ClaimsIdentity(claims),
                Issuer = _configuration["Jwt:Issuer"],
                Audience = _configuration["Jwt:Audience"],
                Expires = DateTime.UtcNow.AddMinutes(expirationMinutes),
                SigningCredentials = credentials
            };

            JwtSecurityTokenHandler tokenHandler = new();
            SecurityToken token = tokenHandler.CreateToken(tokenDescriptor);

            return tokenHandler.WriteToken(token);
        }

        public RefreshToken GenerateRefreshToken(User user)
        {
            byte[] randomNumber = new byte[64];

            using (var rng = RandomNumberGenerator.Create())
            {
                rng.GetBytes(randomNumber);
                string tokenString = Convert.ToBase64String(randomNumber);

                int expirationDays = _configuration.GetValue<int>("Jwt:RefreshTokenExpirationDays", 7);

                RefreshToken refreshToken = new()
                {
                    User = user,
                    Token = tokenString,
                    Created = DateTime.UtcNow,
                    Expires = DateTime.UtcNow.AddDays(expirationDays),
                    Revoked = null
                };

                return refreshToken;
            }
        }

        
    }
}
