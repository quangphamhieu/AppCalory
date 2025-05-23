// Folder: Entities
using Microsoft.AspNetCore.Identity;

namespace CaloryAPI.Entities
{
    public class ApplicationUser : IdentityUser
    {
        // Trường cân nặng (kg)
        public double? Weight { get; set; }

        // Trường chiều cao (m)
        public double? Height { get; set; }

        // Chỉ số BMI được tính theo công thức: BMI = Weight / (Height * Height)
        public double? BMI { get; set; }
    }
}
