using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.Planner.Domain.Models;

namespace Mnd.Planner.Domain.Roles
{
    public interface RAssignedResource
    {
        int Id { get; }
        List<EnvironmentAssignment> Planning { get; }
    }
}
