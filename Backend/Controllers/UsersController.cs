using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using PetsMobile.Services;
using PetsMobile.Services.DTO;
using PetsMobile.Services.Interface;

namespace PetsMobile.Controllers
{
    [Route("api/v3/[controller]")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private readonly IUserService _userService;
        public UsersController(IUserService userService)
        {
            _userService = userService;
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<UserDTO>> GetById(long id)
        {
            UserDTO? user = await _userService.GetByIdAsync(id);

            return user != null ? Ok(user) : NotFound();
        }

        [HttpPost]
        public async Task<ActionResult> Register([FromBody] UserRequest data)
        {
            UserDTO? user = await _userService.RegisterAsync(data);

            return user != null ? CreatedAtAction(nameof(GetById), new { id = user.Id }, user) : Conflict();
        }

        [HttpPut("{id}")]
        [Authorize(Roles = "User,Employee")]
        public async Task<ActionResult> Update(long id, [FromBody] UserRequest data)
        {
            return await _userService.UpdateAsync(id, data) ? Ok() : NotFound();
        }

        [HttpDelete("{id}")]
        [Authorize(Roles = "User,Employee")]
        public async Task<ActionResult> Delete(long id)
        {
            return await _userService.DeleteAsync(id) ? NoContent() : NotFound();
        }
    }
}
