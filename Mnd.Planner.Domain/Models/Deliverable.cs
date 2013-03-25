using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.Planner.Domain.Roles;

namespace Mnd.Planner.Domain
{
    public class Deliverable : RDeliverableStatus
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string Location { get; set; }
        public string State { get; set; }
        public string Owner { get; set; }
        public string Format { get; set; }
        public int InitialHoursEstimate { get; set; }
        public int HoursRemaining { get; set; }
        private List<Activity> _configuredActivities;
        public IList<Activity> ConfiguredActivities
        {
            get
            {
                if (_configuredActivities == null)
                    _configuredActivities = new List<Activity>();
                return _configuredActivities;
            }
        }

        private List<Project> _scope;
        public IList<Project> Scope
        {
            get
            {
                if (_scope == null)
                    _scope = new List<Project>();
                return _scope;
            }
        }
    }
}
