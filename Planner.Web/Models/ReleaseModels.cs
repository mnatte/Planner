using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MvcApplication1.Models
{
    public class ReleaseModels
    {
        public class Phase
        {
            public string Title { get; set; }
            public DateTime StartDate { get; set; }
            public DateTime EndDate { get; set; }
            public int WorkingDays { get; set; }
        }

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
        }
    }
}