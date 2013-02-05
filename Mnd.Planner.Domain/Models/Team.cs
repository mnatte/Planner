using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mnd.Planner.Domain
{
    public class Team
    {
        private List<TeamMember> _teamMembers;
        public IList<TeamMember> TeamMembers
        {
            get
            {
                if (_teamMembers == null)
                    _teamMembers = new List<TeamMember>();
                return _teamMembers;
            }
        }
    }
}
