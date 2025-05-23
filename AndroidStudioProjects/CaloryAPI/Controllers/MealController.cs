using CaloryAPI.Dtos;
using CaloryAPI.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace CaloryAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize(Policy = "RoleUser")]
    public class MealController : ControllerBase
    {
        private readonly IMealService _svc;
        public MealController(IMealService svc) => _svc = svc;
        [HttpPost("calculate")]
        public async Task<IActionResult> Calculate([FromBody] MealRequestDto dto)
        {
            var res = await _svc.CalculateAsync(dto);
            return Ok(res);
        }
    }
}