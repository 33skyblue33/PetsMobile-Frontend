namespace PetsMobile.Services.Mapper;

using DTO;
using Entities;

public static class BreedMapper
{
    public static BreedDTO BreedToBreedDTO(Breed breed)
    {
        return new BreedDTO(
          breed.Id,
          breed.Name,
          breed.Description
        );
    }
    public static Breed BreedRequestToBreed(BreedRequest breedRequest)
    {
        return new Breed()
        {
            Name = breedRequest.Name,
            Description = breedRequest.Description,
        };
    }
    public static void MapBreed(Breed breed,
      BreedRequest data)
    {
        breed.Name = data.Name;
        breed.Description = data.Description;
        
    }
}
