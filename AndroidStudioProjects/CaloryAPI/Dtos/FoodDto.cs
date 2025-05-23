namespace CaloryAPI.Dtos
{
    public class FoodDto
    {
        public int Id { get; set; }
        public string Name { get; set; } = null!;
        public int CaloriesPer100g { get; set; }
    
    }
}
