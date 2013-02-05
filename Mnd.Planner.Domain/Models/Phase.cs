using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mnd.Planner.Domain
{
    public class Phase
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public string TfsIterationPath { get; set; }

        public Period Period
        {
            get { return new Period { EndDate = this.EndDate, StartDate = this.StartDate }; }
        }

        //public int WorkingDays
        //{
        //    get
        //    {
        //        var workingDays = Enumerable.Range(0, Convert.ToInt32(this.EndDate.Subtract(this.StartDate).TotalDays))
        //        .Select(
        //            i => new[] { DayOfWeek.Saturday, DayOfWeek.Sunday }.Contains(this.StartDate.AddDays(i).DayOfWeek) ? 0 : 1
        //            )
        //        .Sum();

        //        return workingDays;
        //    }
        //}
    }
}
