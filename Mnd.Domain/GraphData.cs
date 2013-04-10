using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mnd.Domain
{
    public class XYPoint
    {
        public int X;
        public double Y;
    }

    public class GraphData
    {
        public List<XYPoint> Values { get; set; }
        public string Name { get; set; }
    }
}
