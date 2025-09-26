using PetsMobile.Entities;

namespace PetsMobile.Repository.Interface
{
    public interface IRefreshTokenRepository
    {
        Task<List<RefreshToken>> GetAllInactiveAsync();
        Task<RefreshToken?> GetByTokenAsync(string token);
        Task AddAsync(RefreshToken refreshToken);
        void Remove(RefreshToken refreshToken);
    }
}
