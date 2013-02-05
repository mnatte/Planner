using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mnd.Planner.Domain
{
    // TODO: DCI Role. Persist use case with assignments, role, etc.
    public class TeamMember : Resource
    {
        public double FocusFactor { get; set; }
        // Role in team is something else than official Function of resource
        public Role Role { get; set; }
        private List<ResourceAssignment> _assignments;
        public IList<ResourceAssignment> Assignments
        {
            get
            {
                if (_assignments == null)
                    _assignments = new List<ResourceAssignment>();
                return _assignments;
            }
        }
    }
}
