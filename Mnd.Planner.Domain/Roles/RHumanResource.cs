using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mnd.Planner.Domain.Roles
{
    public interface RHumanResource
    {
        IList<ResourceAssignment> Assignments { get; }
        int Id { get; }

    }
}
