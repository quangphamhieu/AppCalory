// Folder: Services/Implementations
using CaloryAPI.Dtos;
using CaloryAPI.Entities;
using CaloryAPI.Services.Interfaces;
using Microsoft.AspNetCore.Identity;

namespace CaloryAPI.Services.Implementations
{
    public class UserService : IUserService
    {
        private readonly UserManager<ApplicationUser> _userManager;

        public UserService(UserManager<ApplicationUser> userManager)
        {
            _userManager = userManager;
        }

        public async Task<ApplicationUser?> GetUserInfoAsync(string email)
        {
            return await _userManager.FindByEmailAsync(email);
        }

        public async Task<bool> UpdateUserInfoAsync(UpdateUserInfoDto updateUserInfoDto)
        {
            var user = await _userManager.FindByEmailAsync(updateUserInfoDto.Email);
            if (user == null)
                return false;

            user.UserName = updateUserInfoDto.Email;
            user.Email = updateUserInfoDto.Email;
            user.PhoneNumber = updateUserInfoDto.PhoneNumber;
            user.Weight = updateUserInfoDto.Weight;
            user.Height = updateUserInfoDto.Height;
            user.BMI = CalculateBmi(updateUserInfoDto.Weight, updateUserInfoDto.Height);

            var result = await _userManager.UpdateAsync(user);
            return result.Succeeded;
        }

        public async Task<bool> DeleteUserAccountAsync(string email)
        {
            var user = await _userManager.FindByEmailAsync(email);
            if (user == null)
                return false;

            var result = await _userManager.DeleteAsync(user);
            return result.Succeeded;
        }

         private double CalculateBmi(double weight, double height)
        {
            
            double bmi = weight / (height * height);

            // Round to 2 decimal places
            return Math.Round(bmi, 2);
        }
    }
}
