using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mnd.Planner.Domain
{
    public class Role
    {
        public string Name { get; set; }

        private List<string> _activities;
        public IList<string> Activities
        {
            get
            {
                if (_activities == null)
                    _activities = new List<string>();
                return _activities;
            }
        }
    }
}
