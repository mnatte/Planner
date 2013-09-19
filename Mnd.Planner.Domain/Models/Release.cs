using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.Planner.Domain.Roles;

namespace Mnd.Planner.Domain
{
    public class Release : Phase, RReleasePlanning
    {
        public Release()
        { }

        public Release(List<Milestone> milestones)
        {
            _milestones = milestones;
        }



        private List<Phase> _phases;
        public List<Phase> Phases
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
        public List<Project> Projects
        {
            get
            {
                if (_projects == null)
                    _projects = new List<Project>();
                return _projects;
            }
        }

        private List<Milestone> _milestones;
        public List<Milestone> Milestones
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
