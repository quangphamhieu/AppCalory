using CaloryAPI.Dtos;
using CaloryAPI.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace CaloryAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AccountController : ControllerBase
    {
        private readonly IAuthService _auth;
        public AccountController(IAuthService auth) => _auth = auth;

        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] RegisterDto dto)
        {
            if (await _auth.RegisterAsync(dto))
                return Ok(new { message = "Registered" });
            return BadRequest(new { message = "Registration failed" });
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginDto dto)
        {
            var token = await _auth.LoginAsync(dto);
            if (token == null) return Unauthorized();
            return Ok(new { token });
        }

        [HttpPut("change-password")]
        public async Task<IActionResult> ChangePassword([FromBody] ChangePasswordDto dto)
        {
            if (await _auth.ChangePasswordAsync(dto))
                return Ok(new { message = "Password changed" });
            return BadRequest(new { message = "Change failed" });
        }

        [HttpPost("forgot-password")]
        public async Task<IActionResult> Forgot([FromBody] ForgotPasswordDto dto)
        {
            var token = await _auth.GenerateResetTokenAsync(dto.Email);
            if (token == null) return NotFound(new { message = "Email not found" });
            return Ok(new { token });
        }

        [HttpPost("reset-password")]
        public async Task<IActionResult> Reset([FromBody] ResetPasswordDto dto)
        {
            if (await _auth.ResetPasswordAsync(dto))
                return Ok(new { message = "Password reset" });
            return BadRequest(new { message = "Reset failed" });
        }
    }
}