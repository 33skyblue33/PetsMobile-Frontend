using PetsMobile.Services.DTO;

namespace PetsMobile.Services.Interface
{
    public interface IBreedService
    {
        Task<BreedDTO?> GetByIdAsync(long id);
        Task<BreedDTO> CreateAsync(BreedRequest data);
        Task<bool> UpdateAsync(long id,
          BreedRequest data);
        Task<bool> DeleteAsync(long id);
    }
}
