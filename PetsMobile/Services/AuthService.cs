using Microsoft.AspNetCore.Authentication.BearerToken;
using Microsoft.EntityFrameworkCore;
using PetsMobile.Entities;
using PetsMobile.Repository;
using PetsMobile.Repository.Interface;
using PetsMobile.Services.DTO;
using PetsMobile.Services.Interface;
using PetsMobile.Services.Mapper;

namespace PetsMobile.Services
{
    public class AuthService : IAuthService
    {
        private readonly IRefreshTokenRepository _refreshTokenRepository;
        private readonly IUserRepository _userRepository;
        private readonly ITokenGenerator _tokenGenerator;
        private readonly IPasswordHasher _passwordHasher;
        private readonly IUnitOfWork _unitOfWork;

        public AuthService(IRefreshTokenRepository refreshTokenRepository, IUserRepository userRepository, ITokenGenerator tokenGenerator, IPasswordHasher passwordHasher, IUnitOfWork unitOfWork)
        {
            _refreshTokenRepository = refreshTokenRepository;
            _userRepository = userRepository;
            _tokenGenerator = tokenGenerator;
            _passwordHasher = passwordHasher;
            _unitOfWork = unitOfWork;
        }

        public async Task<AuthResult?> LoginAsync(string email, string password)
        {
            if (!await _userRepository.ExistsByEmailAsync(email))
            {
                return null;
            }

            User? user = await _userRepository.GetByEmailAsync(email);

            if (!_passwordHasher.Verify(password, user?.Password))
            {
                return null;
            }

            RefreshToken refreshToken = _tokenGenerator.GenerateRefreshToken(user);
            await _refreshTokenRepository.AddAsync(refreshToken);

            if(await _unitOfWork.CompleteAsync() <= 0)
            {
               return null;
            }

            string accessToken = _tokenGenerator.GenerateAccessToken(user);

            return new AuthResult(UserMapper.UserToUserDTO(user), accessToken, refreshToken);
        }

        public async Task<AuthResult?> RefreshAsync(string refreshToken)
        {
            RefreshToken? token = await _refreshTokenRepository.GetByTokenAsync(refreshToken);

            if(token == null || !token.IsActive)
            {
                return null;
            }

            RefreshToken newToken  = _tokenGenerator.GenerateRefreshToken(token.User);
            await _refreshTokenRepository.AddAsync(newToken);

            string accessToken = _tokenGenerator.GenerateAccessToken(token.User);

            token.Revoked = DateTime.UtcNow;

            if (await _unitOfWork.CompleteAsync() <= 0)
            {
                return null;
            }

            return new AuthResult(UserMapper.UserToUserDTO(token.User), accessToken, newToken);
        }

        public async Task<bool> LogoutAsync(string refreshToken)
        {
            RefreshToken? token = await _refreshTokenRepository.GetByTokenAsync(refreshToken);

            if(token == null || !token.IsActive)
            {
                return false;
            }

            token.Revoked = DateTime.UtcNow;
            return await _unitOfWork.CompleteAsync() != 0;
        }

        public async Task<long> RemoveAllInactiveTokens()
        {
            List<RefreshToken> refreshTokens = await _refreshTokenRepository.GetAllInactiveAsync();

            foreach (RefreshToken refreshToken in refreshTokens)
            {
                _refreshTokenRepository.Remove(refreshToken);
            }

            return await _unitOfWork.CompleteAsync();
        }
    }

}    
