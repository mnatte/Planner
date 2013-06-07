using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mnd.Planner.Domain.Models
{
    public class EnvironmentAssignment
    {
        public Phase Phase { get; set; }
        public Environment Environment { get; set; }
        public SoftwareVersion Version { get; set; }
    }
}
