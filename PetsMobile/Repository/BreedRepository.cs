namespace PetsMobile.Repository;

using Data;
using Entities;
using Interface;
using Microsoft.EntityFrameworkCore;

public class BreedRepository : IBreedRepository {
  private readonly DatabaseContext _databaseContext;
  public BreedRepository(DatabaseContext databaseContext)
  {
    _databaseContext = databaseContext;
  }

  public async Task<Breed?> GetByIdAsync(long id) 
  {
    return await _databaseContext.Breeds.FindAsync(id);
  }
  public async Task<List<Breed>> GetAllAsync() {
    return await _databaseContext.Breeds.ToListAsync();
  }
  public async Task AddAsync(Breed breed)
  {
    await _databaseContext.Breeds.AddAsync(breed);
  }
  public void Remove(Breed breed) {
    _databaseContext.Breeds.Remove(breed);
  }
}
