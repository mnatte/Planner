using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mnd.Planner.Domain.Models
{
    public class Branch
    {
        public string Name { get; set; }
        public string Policy { get; set; }
        public string Goal { get; set; }
        public SoftwareVersion CurrentVersion { get; set; }
        public Branch Parent { get; set; }
        public List<Branch> Children { get; set; }
        public List<Merge> Merges { get; set; }
        public DateTime CreationDate { get; set; }
    }
}
