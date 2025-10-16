using System;
using System.Collections.Generic;

namespace Infrastructure;

public partial class Order
{
    public int OrderId { get; set; }

    public int UserId { get; set; }

    public int RestaurantId { get; set; }

    public int AddressId { get; set; }

    public decimal TotalAmount { get; set; }

    public string Status { get; set; } = null!;

    public DateTime? CreatedAt { get; set; }

    public virtual Address Address { get; set; } = null!;

    public virtual ICollection<OrderItem> OrderItems { get; set; } = new List<OrderItem>();

    public virtual Restaurant Restaurant { get; set; } = null!;

    public virtual User User { get; set; } = null!;
}
