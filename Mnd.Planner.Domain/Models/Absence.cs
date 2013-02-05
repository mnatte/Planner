using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mnd.Planner.Domain
{
    public class Absence : Phase
    {
        public ResourceSnapshot Person { get; set; }
    }
}
