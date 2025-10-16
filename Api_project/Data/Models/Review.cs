using System;
using System.Collections.Generic;

namespace Infrastructure;

public partial class Review
{
    public int ReviewId { get; set; }

    public int CustomerId { get; set; }

    public int RestaurantId { get; set; }

    public int Rating { get; set; }

    public string? Comment { get; set; }

    public DateTime? CreatedAt { get; set; }

    public virtual Customer Customer { get; set; } = null!;

    public virtual Restaurant Restaurant { get; set; } = null!;
}
