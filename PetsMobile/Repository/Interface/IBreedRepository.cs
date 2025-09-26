namespace PetsMobile.Repository.Interface;

using Entities;

public interface IBreedRepository {
  Task<Breed?> GetByIdAsync(long id);
  Task<List<Breed>> GetAllAsync();
  Task AddAsync(Breed breed);
  void Remove(Breed breed);
}
