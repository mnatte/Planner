using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.Planner.Domain.Roles;

namespace Mnd.Planner.Domain
{
    public class Phase : Period, RPeriodSchedule, RPhaseFlyWeight
    {
        public int Id { get; set; }
        public string Description { get; set; }
        //public DateTime StartDate { get; set; }
        //public DateTime EndDate { get; set; }

        public Period Period
        {
            get { return new Period { EndDate = this.EndDate, StartDate = this.StartDate }; }
        }
    }
}
