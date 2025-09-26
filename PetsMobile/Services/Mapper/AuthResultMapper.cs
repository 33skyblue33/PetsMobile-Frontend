using PetsMobile.Services.DTO;
using PetsMobile.Services.Interface;

namespace PetsMobile.Services.Mapper
{
    public class AuthResultMapper
    {
        public static AuthResultDTO AuthResultToAuthResultDTO(AuthResult authResult)
        {
            return new AuthResultDTO(authResult.AccessToken, authResult.User);
        }
    }
}
