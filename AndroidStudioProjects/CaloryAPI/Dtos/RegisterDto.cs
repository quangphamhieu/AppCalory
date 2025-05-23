// Folder: Dtos
namespace CaloryAPI.Dtos
{
    public class RegisterDto
    {
        public string Email { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty;
        public string PhoneNumber { get; set; } = string.Empty;

        // Cân nặng của người dùng khi đăng ký
        public double Weight { get; set; }

        // Chiều cao (m) của người dùng khi đăng ký
        public double Height { get; set; }
    }
}
