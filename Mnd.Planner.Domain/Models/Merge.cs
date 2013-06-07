using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mnd.Planner.Domain.Models
{
    public class Merge
    {
        public string Description { get; set; }
        public SoftwareVersion NewVersion { get; set; }
        public Branch SourceBranch { get; set; }
        public Branch TargetBranch { get; set; }
        public DateTime Date { get; set; }
    }
}
