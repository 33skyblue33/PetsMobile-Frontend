using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using PetsMobile.Entities;
using PetsMobile.Services.DTO;
using PetsMobile.Services.Interface;
using PetsMobile.Services.Mapper;

[Route("api/v3/[controller]")]
[ApiController]
public class AuthController : ControllerBase
{
    private readonly IAuthService _authService;
    private readonly ILogger<AuthController> _logger;

    public AuthController(IAuthService authService, ILogger<AuthController> logger)
    {
        _authService = authService;
        _logger = logger;
    }

    [HttpPost("login")]
    public async Task<ActionResult<AuthResultDTO>> Login([FromBody] LoginRequest data)
    {
        AuthResult? result = await _authService.LoginAsync(data.Email, data.Password);
       
        if (result == null)
        {
            return Unauthorized();
        }

        AddCookie(result.RefreshToken, Response);
        return Ok(AuthResultMapper.AuthResultToAuthResultDTO(result));
    }

    [HttpPut("refresh")]
    public async Task<ActionResult<AuthResultDTO>> Refresh()
    {
        if (!Request.Cookies.TryGetValue("refreshToken", out string? token))
        {
            _logger.LogInformation("test1");
            return Unauthorized();
        }

        AuthResult? result = await _authService.RefreshAsync(token);

        if (result == null)
        {
            _logger.LogInformation("test2");
            return Unauthorized();
        }

        AddCookie(result.RefreshToken, Response);
        return Ok(AuthResultMapper.AuthResultToAuthResultDTO(result));
    }

    [HttpPost("logout")]
    public async Task<ActionResult> Logout()
    {
        if (!Request.Cookies.TryGetValue("refreshToken", out string? token))
        {
            return NoContent();
        }

        CookieOptions cookieOptions = new()
        {
            HttpOnly = true,
            SameSite = SameSiteMode.Lax,
            Secure = false
        };

        Response.Cookies.Delete("refreshToken", cookieOptions);

        return await _authService.LogoutAsync(token) ? Ok() : Unauthorized();
    }

    private void AddCookie(RefreshToken token, HttpResponse response)
    {
        CookieOptions cookieOptions = new()
        {
            HttpOnly = true,
            Expires = token.Expires,
            SameSite = SameSiteMode.Lax,
            Secure = false
        };

        Response.Cookies.Append("refreshToken", token.Token, cookieOptions);
    }

}