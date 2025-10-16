using System;
using System.Collections.Generic;

namespace Infrastructure;

public partial class MenuCategory
{
    public int CategoryId { get; set; }

    public int RestaurantId { get; set; }

    public string Name { get; set; } = null!;

    public virtual ICollection<MenuItem> MenuItems { get; set; } = new List<MenuItem>();

    public virtual Restaurant Restaurant { get; set; } = null!;
}
