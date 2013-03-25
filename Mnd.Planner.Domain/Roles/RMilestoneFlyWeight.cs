using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mnd.Planner.Domain.Roles
{
    public interface RMilestoneFlyWeight
    {
        // Domain properties
        int Id { get; }
        string Title { get; set; }
        RPhaseFlyWeight Release { get; set; }
    }
}
