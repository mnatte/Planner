using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mnd.Planner.Domain
{
    public class Period
    {
        public Period(DateTime startDate, DateTime endDate, string title)
        {
            this.StartDate = startDate;
            this.EndDate = endDate;
            this.Title = title;
        }

        public Period()
        { }

        public string Title { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }

        public bool Overlaps(Period other)
        {
            return
                (this.StartDate >= other.StartDate && this.StartDate <= other.EndDate) ||
                (this.EndDate >= other.StartDate && this.EndDate <= other.EndDate) ||
                (other.StartDate >= this.StartDate && other.StartDate <= this.EndDate) ||
                (other.EndDate >= this.StartDate && other.EndDate <= this.EndDate);
        }

        public Period OverlappingPeriod(Period other)
        {
            if (this.Overlaps(other))
            {
                DateTime startDate;
                DateTime endDate;

                if (this.StartDate > other.StartDate)
                    startDate = this.StartDate;
                else
                    startDate = other.StartDate;
                if (this.EndDate < other.EndDate)
                    endDate = this.EndDate;
                else
                    endDate = other.EndDate;
                return new Period(startDate, endDate, "overlapping period");
            }
            else
                return null;
        }
    }
}
