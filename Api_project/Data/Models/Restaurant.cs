using System;
using System.Collections.Generic;

namespace Infrastructure;

public partial class Restaurant
{
    public int RestaurantId { get; set; }

    public int UserId { get; set; }

    public string Name { get; set; } = null!;

    public string? Description { get; set; }

    public string? Address { get; set; }

    public int CityId { get; set; }

    public int StateId { get; set; }

    public string Status { get; set; } = null!;

    public DateTime? CreatedAt { get; set; }

    public virtual City City { get; set; } = null!;

    public virtual ICollection<MenuCategory> MenuCategories { get; set; } = new List<MenuCategory>();

    public virtual ICollection<Order> Orders { get; set; } = new List<Order>();

    public virtual ICollection<Review> Reviews { get; set; } = new List<Review>();

    public virtual State State { get; set; } = null!;

    public virtual User User { get; set; } = null!;
}
