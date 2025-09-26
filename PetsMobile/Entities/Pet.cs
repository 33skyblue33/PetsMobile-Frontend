
namespace PetsMobile.Entities
{ 
    public class Pet
    {
        public long Id { get; set; } 
        public string Name { get; set; } 
        public string Color { get; set; } 
        public int Age { get; set; } 
        public string ImageUrl { get; set; } 
        public string Description { get; set; } 
        public Breed Breed { get; set; }
    }
}