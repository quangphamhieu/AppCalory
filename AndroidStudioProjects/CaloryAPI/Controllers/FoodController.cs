using CaloryAPI.Dtos;
using CaloryAPI.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace CaloryAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize(Policy = "RoleAdmin")]
    public class FoodController : ControllerBase
    {
        private readonly IFoodService _svc;
        public FoodController(IFoodService svc) => _svc = svc;

        [HttpGet("getall")]
        [AllowAnonymous]
        public async Task<IActionResult> GetAll() => Ok(await _svc.GetAllAsync());

        [HttpGet("get-by/{id}")]
        [AllowAnonymous]
        public async Task<IActionResult> Get(int id)
            => (await _svc.GetByIdAsync(id)) is var f && f != null ? Ok(f) : NotFound();

        [HttpPost("create-food")]
        public async Task<IActionResult> Create([FromBody] CreateFoodDto dto)
        {
            var f = await _svc.CreateAsync(dto);
            return CreatedAtAction(nameof(Get), new { id = f.Id }, f);
        }

        [HttpPut("update-by/{id}")]
        public async Task<IActionResult> Update(int id, [FromBody] UpdateFoodDto dto)
            => await _svc.UpdateAsync(id, dto) ? NoContent() : NotFound();

        [HttpDelete("delete-by/{id}")]
        public async Task<IActionResult> Delete(int id)
            => await _svc.DeleteAsync(id) ? NoContent() : NotFound();
    }
}