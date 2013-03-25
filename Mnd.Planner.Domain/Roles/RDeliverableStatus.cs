using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mnd.Planner.Domain.Roles
{
    public interface RDeliverableStatus
    {
        // Domain properties
        int Id { get; }
        IList<Project> Scope { get; }
    }
}
