using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mnd.Planner.Domain.Roles
{
    public interface RPhaseFlyWeight
    {
        // Domain properties
        int Id { get; }
        string Title { get; set; }
    }
}
