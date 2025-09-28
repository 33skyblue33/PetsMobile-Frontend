using PetsMobile.Entities;
using PetsMobile.Services.DTO;

namespace PetsMobile.Services.Mapper
{
    public static class UserMapper
    {
        public static UserDTO UserToUserDTO(User user)
        {
            return new UserDTO(user.Id, user.Name, user.Surname, user.Age, user.Email);
        }

        public static User UserRequestToUser(UserRequest data)
        {
            return new User()
            {
                Name = data.Name,
                Surname = data.Surname,
                Age = data.Age,
                Email = data.Email,
                Password = data.Password,
                Role = Role.User
            };
        }

        public static void MapUser(User user, UserRequest data)
        {
            user.Name = data.Name;
            user.Surname = data.Surname;
            user.Age = data.Age;
            user.Email = data.Email;
            user.Password = data.Password;
        }
    }
}
