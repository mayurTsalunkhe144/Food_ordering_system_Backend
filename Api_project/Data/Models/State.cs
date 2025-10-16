using System;
using System.Collections.Generic;

namespace Infrastructure;

public partial class State
{
    public int StateId { get; set; }

    public string StateName { get; set; } = null!;

    public bool? IsActive { get; set; }

    public virtual ICollection<Address> Addresses { get; set; } = new List<Address>();

    public virtual ICollection<City> Cities { get; set; } = new List<City>();

    public virtual ICollection<Restaurant> Restaurants { get; set; } = new List<Restaurant>();
}
