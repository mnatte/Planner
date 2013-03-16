using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mnd.Planner.Domain.Roles
{
    public interface RPeriodSchedule
    {
        // Domain properties
        int Id { get; }
        DateTime StartDate { get; set; }
        DateTime EndDate { get; set; }
    }
}
