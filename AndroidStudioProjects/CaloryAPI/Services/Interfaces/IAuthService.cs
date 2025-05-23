// Folder: Services/Interfaces
using CaloryAPI.Dtos;

namespace CaloryAPI.Services.Interfaces
{
    public interface IAuthService
    {
        Task<bool> RegisterAsync(RegisterDto dto);
        Task<string?> LoginAsync(LoginDto dto);
        Task<bool> ChangePasswordAsync(ChangePasswordDto dto);
        Task<string?> GenerateResetTokenAsync(string email);
        Task<bool> ResetPasswordAsync(ResetPasswordDto dto);
    }
}
