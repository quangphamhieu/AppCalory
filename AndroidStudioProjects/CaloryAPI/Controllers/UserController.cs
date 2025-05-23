// Folder: Controllers
using CaloryAPI.Dtos;
using CaloryAPI.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace CaloryAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize(Roles = "User")]
    public class UserController : ControllerBase
    {
        private readonly IUserService _userService;
        public UserController(IUserService userService)
        {
            _userService = userService;
        }

        // Lấy thông tin người dùng, bao gồm cả cân nặng, chiều cao và BMI
        [HttpPost("user-info")]
        public async Task<IActionResult> GetUserInfo([FromBody] string email)
        {
            var user = await _userService.GetUserInfoAsync(email);
            if (user == null)
            {
                return NotFound(new { message = "User not found." });
            }
            return Ok(new
            {
                user.Id,
                user.Email,
                user.PhoneNumber,
                Weight = user.Weight,
                Height = user.Height,
                BMI = user.BMI
            });
        }


        // Cập nhật thông tin người dùng và tính lại BMI
        [HttpPut("user-info")]
        public async Task<IActionResult> UpdateUserInfo([FromBody] UpdateUserInfoDto model)
        {
            var success = await _userService.UpdateUserInfoAsync(model);
            if (success)
                return Ok(new { message = "User info updated successfully." });
            return BadRequest(new { message = "Update failed." });
        }

        // Xóa tài khoản người dùng
        [HttpDelete("delete-user")]
        public async Task<IActionResult> DeleteUserAccount([FromQuery] string email)
        {
            var success = await _userService.DeleteUserAccountAsync(email);
            if (success)
                return Ok(new { message = "User deleted successfully." });
            return BadRequest(new { message = "Deletion failed." });
        }
    }
}
