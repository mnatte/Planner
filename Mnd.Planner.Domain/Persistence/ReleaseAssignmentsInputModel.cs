using System;
using System.Collections.Generic;
using System.Linq;

namespace Mnd.Planner.Domain.Persistence
{
    public class ReleaseAssignmentsInputModel
    {
        public int Id { get; set; }
        public int PhaseId { get; set; }
        public int ProjectId { get; set; }
        public List<ResourceAssignmentInputModel> Assignments { get; set; }
    }
}