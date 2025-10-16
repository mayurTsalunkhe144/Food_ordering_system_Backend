using System;
using System.Collections.Generic;

namespace Infrastructure;

public partial class Address
{
    public int AddressId { get; set; }

    public int UserId { get; set; }

    public string? AddressLine { get; set; }

    public int CityId { get; set; }

    public int StateId { get; set; }

    public bool? IsDefault { get; set; }

    public virtual City City { get; set; } = null!;

    public virtual ICollection<Order> Orders { get; set; } = new List<Order>();

    public virtual State State { get; set; } = null!;

    public virtual User User { get; set; } = null!;
}
