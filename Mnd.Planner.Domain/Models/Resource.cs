using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.Planner.Domain.Roles;

namespace Mnd.Planner.Domain
{
    public class Resource : ResourceSnapshot, RHumanResource
    {
        public int AvailableHoursPerWeek { get; set; }
        public Role Function { get; set; }

        private List<Phase> _periodsAway;
        public List<Phase> PeriodsAway
        {
            get
            {
                if (_periodsAway == null)
                    _periodsAway = new List<Phase>();
                return _periodsAway;
            }
        }

        //TODO: Create as TeamMember mixin / DCI role
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
