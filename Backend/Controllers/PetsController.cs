using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using PetsMobile.Services.DTO;
using PetsMobile.Services.Interface;

namespace PetsMobile.Controllers
{
    [Route("api/v3/[Controller]")]
    [ApiController]
    public class PetsController : ControllerBase
    {
        private readonly IPetService _petService;

        public PetsController(IPetService petService)
        {
            _petService = petService;
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<PetDTO>> GetById(long id)
        {
            PetDTO? pet = await _petService.GetByIdAsync(id);

            return pet != null ? Ok(pet) : NotFound();
        }

        [HttpGet]
        public async Task<ActionResult<List<PetDTO>>> GetAll()
        {
            return Ok(await _petService.GetAllAsync());
        }

        [HttpPost]
        public async Task<ActionResult> Create([FromBody] PetRequest data)
        {
            PetDTO pet = await _petService.CreateAsync(data);

            return CreatedAtAction(nameof(GetById), new { id = pet.Id }, pet);
        }

        [HttpPut("{id}")]
        [Authorize(Roles = "Employee")]
        public async Task<ActionResult> Update(long id, [FromBody] PetRequest data)
        {
            return await _petService.UpdateAsync(id, data) ? Ok() : NotFound();
        }

        [HttpDelete("{id}")]
        [Authorize(Roles = "Employee")]
        public async Task<ActionResult> Delete(long id)
        {
            return await _petService.DeleteAsync(id) ? NoContent() : NotFound();
        }
    }
}
