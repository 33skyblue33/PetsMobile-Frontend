using Microsoft.EntityFrameworkCore;
using PetsMobile.Data;
using PetsMobile.Entities;
using PetsMobile.Repository.Interface;

namespace PetsMobile.Repository
{
    public class RefreshTokenRepository : IRefreshTokenRepository
    {
        private readonly DatabaseContext _databaseContext;
        public RefreshTokenRepository(DatabaseContext databaseContext)
        {
            _databaseContext = databaseContext;
        }
        public async Task AddAsync(RefreshToken refreshToken)
        {
            await _databaseContext.RefreshTokens.AddAsync(refreshToken);
        }

        public async Task<List<RefreshToken>> GetAllInactiveAsync()
        {
            return await _databaseContext.RefreshTokens.Include(r => r.User).Where(r => DateTime.UtcNow >= r.Expires || r.Revoked != null).ToListAsync();
        }

        public async Task<RefreshToken?> GetByTokenAsync(string token)
        {
            return await _databaseContext.RefreshTokens.Include(r => r.User).FirstOrDefaultAsync(r => r.Token == token);
        }

        public void Remove(RefreshToken refreshToken)
        {
            _databaseContext.RefreshTokens.Remove(refreshToken);
        }
    }
}
