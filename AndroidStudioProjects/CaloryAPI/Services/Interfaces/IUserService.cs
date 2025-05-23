// Folder: Services/Interfaces
using CaloryAPI.Dtos;
using CaloryAPI.Entities;

namespace CaloryAPI.Services.Interfaces
{
    public interface IUserService
    {
        Task<ApplicationUser?> GetUserInfoAsync(string email);
        Task<bool> UpdateUserInfoAsync(UpdateUserInfoDto updateUserInfoDto);
        Task<bool> DeleteUserAccountAsync(string email);
    }
}
