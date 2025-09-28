namespace PetsMobile.Services.Interface
{
  using DTO;

  public interface IPetService {
    Task<PetDTO?> GetByIdAsync(long id);
    Task<List<PetDTO>> GetAllAsync();
    Task<PetDTO> CreateAsync(PetRequest data);
    Task<bool> UpdateAsync(long id,
      PetRequest data);
    Task<bool> DeleteAsync(long id);
  }
}
