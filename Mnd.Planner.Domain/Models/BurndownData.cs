using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.Domain;

namespace Mnd.Planner.Domain.Models
{
    public class BurndownData
    {
        public List<GraphData> Graphs { get; set; }
        public double Velocity { get; set; }
    }
}
