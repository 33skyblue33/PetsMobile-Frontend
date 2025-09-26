namespace PetsMobile.Repository.Interface
{
    using PetsMobile.Entities;

    public interface IUserRepository
    {
        Task<User?> GetByIdAsync(long id);
        Task<User?> GetByEmailAsync(string email);
        Task<bool> ExistsByEmailAsync(string email);
        Task AddAsync(User user);
        void Remove(User user);


    }
}
