using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mnd.Planner.Domain
{
    public class Release : Phase
    {
        private List<Phase> _phases;
        public IList<Phase> Phases
        {
            get
            {
                if (_phases == null)
                    _phases = new List<Phase>();
                return _phases;
            }
        }

        /// <summary>
        /// Enable coupling of Projects to Releases to resources 
        /// </summary>
        private List<Project> _projects;
        public IList<Project> Projects
        {
            get
            {
                if (_projects == null)
                    _projects = new List<Project>();
                return _projects;
            }
        }

        private List<Milestone> _milestones;
        public IList<Milestone> Milestones
        {
            get
            {
                if (_milestones == null)
                    _milestones = new List<Milestone>();
                return _milestones;
            }
        }
    }
}
