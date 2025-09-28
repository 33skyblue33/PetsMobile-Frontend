namespace PetsMobile.Services;

using DTO;
using Entities;
using Interface;
using Mapper;
using Repository.Interface;

public class PetService : IPetService {
  private readonly IPetRepository _petRepository;
  private readonly IBreedRepository _breedRepository;
  private readonly IUnitOfWork _unitOfWork;
  
  public PetService(IPetRepository petRepository,
    IBreedRepository breedRepository,
    IUnitOfWork unitOfWork) {
    _petRepository = petRepository;
    _breedRepository = breedRepository;
    _unitOfWork = unitOfWork;
  }

  public async Task<PetDTO?> GetByIdAsync(long id) {
    Pet? pet = await _petRepository.GetByIdAsync(id);
    
    if (pet == null) {
      return null;
    }
    
    return PetMapper.PetToPetDTO(pet);
  }
  public async Task<List<PetDTO>> GetAllAsync() {
    return PetMapper.PetListToPetDTOList(await _petRepository.GetAllAsync());
  }
  public async Task<PetDTO> CreateAsync(PetRequest data) {
    Breed? breed = await _breedRepository.GetByIdAsync(data.BreedId);
    Pet pet = PetMapper.PetRequestToPet(data, breed);
    
    await _petRepository.AddAsync(pet);
    await _unitOfWork.CompleteAsync();
    
    return PetMapper.PetToPetDTO(pet);
  }
  public async Task<bool> UpdateAsync(long id,
    PetRequest data) {
    Pet? pet = await _petRepository.GetByIdAsync(id);
    Breed? breed = await _breedRepository.GetByIdAsync(data.BreedId);

    if(pet == null || breed == null)
    {
        return false; 
    }
    
    PetMapper.MapPet(pet, breed, data);
    
    return await _unitOfWork.CompleteAsync() != 0;
  }
  public async Task<bool> DeleteAsync(long id) {
    Pet? pet = await _petRepository.GetByIdAsync(id);

    if(pet == null)
    {
       return false;
    }
    
    _petRepository.Remove(pet);
    return await _unitOfWork.CompleteAsync() != 0;
  }
}
