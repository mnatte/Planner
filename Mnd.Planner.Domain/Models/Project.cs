using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mnd.Planner.Domain
{
    public class Project
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string ShortName { get; set; }
        public string Description { get; set; }
        private List<ResourceAssignment> _assignedResources;
        public IList<ResourceAssignment> AssignedResources
        {
            get
            {
                if (_assignedResources == null)
                    _assignedResources = new List<ResourceAssignment>();
                return _assignedResources;
            }
        }

        /// <summary>
        /// Use Backlog to access Features to Projects to Teams (to Resources)
        /// </summary>
        private List<Feature> _backlog;
        public IList<Feature> Backlog
        {
            get
            {
                if (_backlog == null)
                    _backlog = new List<Feature>();
                return _backlog;
            }
        }

        /// <summary>
        /// Use Backlog to access Features to Projects to Teams (to Resources)
        /// </summary>
        private List<ActivityStatus> _workload;
        public IList<ActivityStatus> Workload
        {
            get
            {
                if (_workload == null)
                    _workload = new List<ActivityStatus>();
                return _workload;
            }
        }
    }
}
