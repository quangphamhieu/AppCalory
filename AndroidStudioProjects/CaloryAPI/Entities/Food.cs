namespace CaloryAPI.Entities
{
    public class Food
    {
        public int Id { get; set; }
        public string Name { get; set; } = null!;
        public int CaloriesPer100g { get; set; }
    }
}