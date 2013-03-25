using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mnd.Planner.Domain.Roles
{
    public interface RMilestoneStatus
    {
        // Domain properties
        int Id { get; }
        RPhaseFlyWeight Release { get; }
        // Deliverable has Projects in its Scope property, containing on its turn ActivityStatuses
        IList<Deliverable> Deliverables { get; }
    }
}
