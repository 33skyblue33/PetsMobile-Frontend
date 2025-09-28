using PetsMobile.Entities;
using PetsMobile.Repository;
using PetsMobile.Repository.Interface;
using PetsMobile.Services.DTO;
using PetsMobile.Services.Interface;
using PetsMobile.Services.Mapper;

namespace PetsMobile.Services
{
    public class BreedService : IBreedService
    {
        private readonly IBreedRepository _breedRepository;
        private readonly IUnitOfWork _unitOfWork;

        public BreedService(IBreedRepository breedRepository, IUnitOfWork unitOfWork)
        {
            _breedRepository = breedRepository;
            _unitOfWork = unitOfWork;
        }

        public async Task<BreedDTO> CreateAsync(BreedRequest data)
        {
            Breed breed = BreedMapper.BreedRequestToBreed(data);
            await _breedRepository.AddAsync(breed);
            await _unitOfWork.CompleteAsync();

            return BreedMapper.BreedToBreedDTO(breed);
        }

        public async Task<bool> DeleteAsync(long id)
        {
            Breed? breed = await _breedRepository.GetByIdAsync(id);

            if (breed == null)
            {
                return false;
            }

            _breedRepository.Remove(breed);
            return await _unitOfWork.CompleteAsync() != 0;
        }


        public async Task<BreedDTO?> GetByIdAsync(long id)
        {
            Breed? breed = await _breedRepository.GetByIdAsync(id);

            if (breed == null)
            {
                return null;
            }

            return BreedMapper.BreedToBreedDTO(breed);
        }

        public async Task<bool> UpdateAsync(long id, BreedRequest data)
        {
            Breed? breed = await _breedRepository.GetByIdAsync(id);

            if (breed == null)
            {
                return false;
            }

            BreedMapper.MapBreed(breed, data);

            return await _unitOfWork.CompleteAsync() != 0;
        }

    }
}
    

