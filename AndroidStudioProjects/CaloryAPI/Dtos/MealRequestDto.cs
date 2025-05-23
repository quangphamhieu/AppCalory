namespace CaloryAPI.Dtos
{
    public class MealRequestDto
    {
        public List<MealItemDto> Items { get; set; } = new List<MealItemDto>();
    }
}
