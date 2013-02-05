using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mnd.Planner.Domain
{
    public class Feature
    {
        public string Title { get; set; }
        public string ContactPerson { get; set; }
        public string BusinessId { get; set; }
        public int Priority { get; set; }
        public int EstimatedHours { get; set; }
        public int RemainingHours { get; set; }
        public int HoursWorked { get; set; }
        public Project Project { get; set; }
        public string Status { get; set; }
    }
}
