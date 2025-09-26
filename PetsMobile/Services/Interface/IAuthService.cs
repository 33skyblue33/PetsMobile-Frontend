using PetsMobile.Entities;
using PetsMobile.Services.DTO;

namespace PetsMobile.Services.Interface
{
    public record AuthResult(
        UserDTO User,
        string AccessToken,
        RefreshToken RefreshToken
    );

    public interface IAuthService
    {
        Task<AuthResult?> LoginAsync(string email, string password);
        Task<AuthResult?> RefreshAsync(string refreshToken);
        Task<bool> LogoutAsync (string refreshToken);
        Task<long> RemoveAllInactiveTokens();
    }
}
