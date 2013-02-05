using System;
using System.Collections.Generic;
using System.Linq;

namespace Mnd.Planner.Domain.Persistence
{
    public class PeriodInputModel
    {
        public string Title { get; set; }
        public string Descr { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
    }
}