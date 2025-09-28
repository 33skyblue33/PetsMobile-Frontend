using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PetsMobile.Entities;
using PetsMobile.Services.DTO;
using PetsMobile.Services.Interface;

namespace PetsMobile.Controllers
{
    [Route("api/v3/[Controller]")]
    [ApiController]
    public class BreedsController : ControllerBase
    {
        private readonly IBreedService _breedService;

        public BreedsController(IBreedService breedService)
        {
            _breedService = breedService;
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<BreedDTO>> GetById(long id)
        {
            BreedDTO? breed = await _breedService.GetByIdAsync(id);

            return breed != null ? Ok(breed) : NotFound();
        }

        [HttpPost]
        [Authorize(Roles ="Employee")]
        public async Task<ActionResult<BreedDTO>> Create([FromBody] BreedRequest data)
        {
            BreedDTO breed = await _breedService.CreateAsync(data);
            return CreatedAtAction(nameof(GetById), new { id = breed.Id }, breed);
        }

        [HttpPut("{id}")]
        [Authorize(Roles = "Employee")]
        public async Task<ActionResult<BreedDTO>> Update(long id , [FromBody] BreedRequest data)
        {
            return await _breedService.UpdateAsync(id, data) ? Ok(data) : NotFound();
        }

        [HttpDelete("{id}")]
        [Authorize(Roles = "Employee")]
        public async Task<ActionResult<BreedDTO>> Delete(long id)
        {
            return await _breedService.DeleteAsync(id) ? NoContent() : NotFound();
        }
    }
}
