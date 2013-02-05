using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mnd.Planner.Domain
{
    public class Periods
    {
        private List<Release> _phases;
        public IList<Release> Releases
        {
            get
            {
                if (_phases == null)
                    _phases = new List<Release>();
                return _phases;
            }
        }

        private List<Absence> _absences;
        public IList<Absence> Absences
        {
            get
            {
                if (_absences == null)
                    _absences = new List<Absence>();
                return _absences;
            }
        }
    }
}
