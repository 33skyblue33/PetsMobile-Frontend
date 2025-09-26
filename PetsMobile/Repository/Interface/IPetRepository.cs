using Microsoft.AspNetCore.Mvc;
using PetsMobile.Entities;

namespace PetsMobile.Repository.Interface
{
    public interface IPetRepository
    {
        Task<Pet?> GetByIdAsync(long id);
        
        Task AddAsync(Pet pet);
        Task<List<Pet>> GetAllAsync();
        void Remove(Pet pet);
        
    }
}
