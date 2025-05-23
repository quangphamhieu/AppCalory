namespace CaloryAPI.Dtos
{
    public class CreateFoodDto
    {
        public string Name { get; set; } = null!;
        public int CaloriesPer100g { get; set; }
    }
}
