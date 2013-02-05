using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mnd.Planner.Domain
{
    public class ResourceAssignment
    {
        public int Id { get; set; }
        public Resource Resource { get; set; }
        public Phase Phase { get; set; }

        public Project Project { get; set; }
        public Milestone Milestone { get; set; }
        public Deliverable Deliverable { get; set; }
        public Activity Activity { get; set; }

        public double FocusFactor { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }

        public Period Period
        {
            get { return new Period { EndDate = this.EndDate, StartDate = this.StartDate }; }
        }
    }
}
