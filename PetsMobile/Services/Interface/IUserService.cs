namespace PetsMobile.Services.Interface
{
    using DTO;
    using PetsMobile.Entities;

    public interface IUserService
    {
        Task<UserDTO?> GetByIdAsync(long id);
        Task<UserDTO?> RegisterAsync(UserRequest data);
        Task<bool> UpdateAsync(long id, UserRequest data);
        Task<bool> DeleteAsync(long id);
    }
}
