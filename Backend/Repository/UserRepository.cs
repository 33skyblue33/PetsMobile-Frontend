using Microsoft.EntityFrameworkCore;
using PetsMobile.Data;
using PetsMobile.Entities;
using PetsMobile.Repository.Interface;

namespace PetsMobile.Repository
{
    public class UserRepository : IUserRepository
    {
        private readonly DatabaseContext _databaseContext;

        public UserRepository(DatabaseContext databaseContext)
        {
            _databaseContext = databaseContext;
        }

        public async Task AddAsync(User user)
        {
            await _databaseContext.Users.AddAsync(user);
        }

        public async Task<User?> GetByEmailAsync(string email)
        {
            return await _databaseContext.Users.FirstOrDefaultAsync(x => x.Email == email);
        }

        public async Task<bool> ExistsByEmailAsync(string email)
        {
            return await _databaseContext.Users.AnyAsync(x => x.Email == email);
        }

        public async Task<User?> GetByIdAsync(long id)
        {
            return await _databaseContext.Users.FirstOrDefaultAsync(x => x.Id == id);
        }

        public void Remove(User user)
        {
            _databaseContext.Users.Remove(user);
        }
    }
}
