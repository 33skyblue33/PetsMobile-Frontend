using PetsMobile.Entities;

namespace PetsMobile.Services.Interface
{
    public interface ITokenGenerator
    {
        string GenerateAccessToken(User user);
        RefreshToken GenerateRefreshToken(User user);
    }
}
