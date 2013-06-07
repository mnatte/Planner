using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.Planner.Domain.Roles;

namespace Mnd.Planner.Domain.Models
{
    public class Environment : RAssignedResource
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string Location { get; set; }
        public string ShortName { get; set; }

        private List<EnvironmentAssignment> _planning;
        public List<EnvironmentAssignment> Planning
        {
            get
            {
                if (_planning == null)
                    _planning = new List<EnvironmentAssignment>();
                return _planning;
            }
        }
    }
}
