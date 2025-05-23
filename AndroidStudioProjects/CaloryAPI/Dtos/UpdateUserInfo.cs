// Folder: Dtos
namespace CaloryAPI.Dtos
{
    public class UpdateUserInfoDto
    {
        public string Email { get; set; }
        public string PhoneNumber { get; set; }

        // Cho phép cập nhật cân nặng và chiều cao
        public double Weight { get; set; }
        public double Height { get; set; }
    }
}
