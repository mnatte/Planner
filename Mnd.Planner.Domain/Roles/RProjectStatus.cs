using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mnd.Planner.Domain.Roles
{
    public interface RProjectStatus
    {
        // Domain properties
        int Id { get; }
        IList<ActivityStatus> Workload { get; }
    }
}
