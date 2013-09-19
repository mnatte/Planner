using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.Planner.Domain.Models;

namespace Mnd.Planner.Domain.Roles
{
    public interface RReleasePlanning
    {
        int Id { get; }
        List<Milestone> Milestones { get; }
        List<Phase> Phases { get; }
        List<Project> Projects { get; }
    }
}
