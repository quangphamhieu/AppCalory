using CaloryAPI.Data;
using CaloryAPI.Dtos;
using CaloryAPI.Entities;
using CaloryAPI.Services.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace CaloryAPI.Services.Implementations
{
    public class FoodService : IFoodService
    {
        private readonly AppDbContext _ctx;
        public FoodService(AppDbContext ctx) => _ctx = ctx;

        public async Task<List<FoodDto>> GetAllAsync() => await _ctx.Foods
            .Select(f => new FoodDto
            {
                Id = f.Id,
                Name = f.Name,
                CaloriesPer100g = f.CaloriesPer100g
            })
            .ToListAsync();

        public async Task<FoodDto?> GetByIdAsync(int id) => await _ctx.Foods
            .Where(f => f.Id == id)
            .Select(f => new FoodDto
            {
                Id = f.Id,
                Name = f.Name,
                CaloriesPer100g = f.CaloriesPer100g
            })
            .FirstOrDefaultAsync();

        public async Task<FoodDto> CreateAsync(CreateFoodDto dto)
        {
            var entity = new Food
            {
                Name = dto.Name,
                CaloriesPer100g = dto.CaloriesPer100g
            };
            _ctx.Foods.Add(entity);
            await _ctx.SaveChangesAsync();
            return new FoodDto
            {
                Id = entity.Id,
                Name = entity.Name,
                CaloriesPer100g = entity.CaloriesPer100g
            };
        }

        public async Task<bool> UpdateAsync(int id, UpdateFoodDto dto)
        {
            var f = await _ctx.Foods.FindAsync(id);
            if (f == null) return false;
            f.Name = dto.Name;
            f.CaloriesPer100g = dto.CaloriesPer100g;
            await _ctx.SaveChangesAsync();
            return true;
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var f = await _ctx.Foods.FindAsync(id);
            if (f == null) return false;
            _ctx.Foods.Remove(f);
            await _ctx.SaveChangesAsync();
            return true;
        }
    }
}