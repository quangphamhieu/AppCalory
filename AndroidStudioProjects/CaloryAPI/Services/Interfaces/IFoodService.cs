using CaloryAPI.Dtos;

namespace CaloryAPI.Services.Interfaces
{
    public interface IFoodService
    {
        Task<List<FoodDto>> GetAllAsync();
        Task<FoodDto?> GetByIdAsync(int id);
        Task<FoodDto> CreateAsync(CreateFoodDto dto);
        Task<bool> UpdateAsync(int id, UpdateFoodDto dto);
        Task<bool> DeleteAsync(int id);
    }
}
