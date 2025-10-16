using System;
using System.Collections.Generic;

namespace Infrastructure;

public partial class Customer
{
    public int CustomerId { get; set; }

    public int UserId { get; set; }

    public virtual ICollection<Review> Reviews { get; set; } = new List<Review>();

    public virtual User User { get; set; } = null!;
}
