using CaloryAPI.Data;
using CaloryAPI.Dtos;
using CaloryAPI.Services.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace CaloryAPI.Services.Implementations
{
    public class MealService : IMealService
    {
        private readonly AppDbContext _ctx;
        public MealService(AppDbContext ctx) => _ctx = ctx;

        public async Task<MealResultDto> CalculateAsync(MealRequestDto dto)
        {
            double total = 0;
            // load foods by ids in dto
            var foods = await _ctx.Foods
                .Where(f => dto.Items.Select(i => i.FoodId).Contains(f.Id))
                .ToListAsync();

            foreach (var item in dto.Items)
            {
                var food = foods.FirstOrDefault(f => f.Id == item.FoodId);
                if (food != null)
                {
                    total += food.CaloriesPer100g * item.WeightInGrams / 100.0;
                }
            }

            return new MealResultDto { TotalCalories = total };
        }
    }
}