namespace CaloryAPI.Dtos
{
    public class UpdateFoodDto
    {
        public string Name { get; set; } = null!;
        public int CaloriesPer100g { get; set; }
    }
}
