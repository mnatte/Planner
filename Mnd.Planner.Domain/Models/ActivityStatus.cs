using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mnd.Planner.Domain
{
    public class ActivityStatus
    {
        public Deliverable Deliverable { get; set; }
        public int HoursRemaining { get; set; }
        public Project Project { get; set; }
        public Activity Activity { get; set; }
        private List<ResourceAssignment> _resources;
        public IList<ResourceAssignment> AssignedResources
        {
            get
            {
                if (_resources == null)
                    _resources = new List<ResourceAssignment>();
                return _resources;
            }
        }
    }
}
