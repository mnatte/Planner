using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.Planner.Domain.Roles;

namespace Mnd.Planner.Domain
{
    public class Milestone : RMilestoneSchedule, RMilestoneStatus, RMilestoneFlyWeight
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime Date { get; set; }
        public string Time { get; set; }
        private List<Deliverable> _deliverables;
        public IList<Deliverable> Deliverables
        {
            get
            {
                if (_deliverables == null)
                    _deliverables = new List<Deliverable>();
                return _deliverables;
            }
        }

        public RPhaseFlyWeight Release { get; set; }
    }
}
