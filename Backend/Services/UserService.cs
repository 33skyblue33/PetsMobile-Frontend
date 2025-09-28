using PetsMobile.Entities;
using PetsMobile.Repository.Interface;
using PetsMobile.Services.DTO;
using PetsMobile.Services.Interface;
using PetsMobile.Services.Mapper;

namespace PetsMobile.Services
{
    public class UserService : IUserService
    {
        private readonly IUserRepository _userRepository;
        private readonly IUnitOfWork _unitOfWork;
        private readonly IPasswordHasher _passwordHasher;

        public UserService(IUserRepository userRepository, IUnitOfWork unitOfWork, IPasswordHasher passwordHasher)
        {
            _userRepository = userRepository;
            _unitOfWork = unitOfWork;
            _passwordHasher = passwordHasher;
        }

        public async Task<bool> DeleteAsync(long id)
        {
            User? user = await _userRepository.GetByIdAsync(id);

            if(user == null)
            {
                return false;
            }

            _userRepository.Remove(user);

            return await _unitOfWork.CompleteAsync() != 0;
            
        }

        public async Task<UserDTO?> GetByIdAsync(long id)
        {
            User? user = await _userRepository.GetByIdAsync(id);

            if (user == null)
            {
                return null;
            }

            return UserMapper.UserToUserDTO(user);
        }

        public async Task<UserDTO?> RegisterAsync(UserRequest data)
        {
            if(await _userRepository.ExistsByEmailAsync(data.Email))
            {
                return null;
            }

            User user = UserMapper.UserRequestToUser(data);
            user.Password = _passwordHasher.Hash(user.Password);

            await _userRepository.AddAsync(user);

            return await _unitOfWork.CompleteAsync() != 0 ? UserMapper.UserToUserDTO(user) : null;
        }

        public async Task<bool> UpdateAsync(long id, UserRequest data)
        {
            User? user = await _userRepository.GetByIdAsync(id);
            if( user == null)
            {
                return false;
            }

            UserMapper.MapUser(user, data);
            user.Password = _passwordHasher.Hash(user.Password);

            return await _unitOfWork.CompleteAsync() != 0;
        }
    }
}
