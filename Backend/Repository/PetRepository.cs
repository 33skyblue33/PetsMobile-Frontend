using Microsoft.EntityFrameworkCore;
using PetsMobile.Data;
using PetsMobile.Entities;
using PetsMobile.Repository.Interface;

namespace PetsMobile.Repository
{
    public class PetRepository : IPetRepository
    {
        private readonly DatabaseContext _databaseContext;
        
        public PetRepository(DatabaseContext databaseContext)
        {
            _databaseContext = databaseContext;
        }
        public async Task AddAsync(Pet pet)
        {
            await _databaseContext.Pets.AddAsync(pet);
        }

        public async Task<List<Pet>> GetAllAsync()
        {
            return await _databaseContext.Pets.Include(p=>p.Breed).ToListAsync();
        }

        public async Task<Pet?> GetByIdAsync(long id)
        {
            return await _databaseContext.Pets.Include(p=>p.Breed).FirstOrDefaultAsync(p=>p.Id==id);
        }

        public void Remove(Pet pet)
        {
           _databaseContext.Pets.Remove(pet);
        }
    }
}
