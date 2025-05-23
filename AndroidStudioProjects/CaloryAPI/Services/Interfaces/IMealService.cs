using CaloryAPI.Dtos;

namespace CaloryAPI.Services.Interfaces
{
    public interface IMealService
    {
        Task<MealResultDto> CalculateAsync(MealRequestDto dto);
    }
}
