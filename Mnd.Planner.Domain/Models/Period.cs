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

        public int WorkingDays
        {
            get
            {
                if (this.StartDate > this.EndDate)
                    throw new Exception("StartDate is smaller than EndDate");
                var workingDays = Enumerable.Range(0, Convert.ToInt32(this.EndDate.Subtract(this.StartDate).TotalDays))
                .Select(
                    i => new[] { DayOfWeek.Saturday, DayOfWeek.Sunday }.Contains(this.StartDate.AddDays(i).DayOfWeek) ? 0 : 1
                    )
                .Sum();

                return workingDays;
            }
        }

        public int TotalDays
        {
            get
            {
                var workingDays = Enumerable.Range(0, Convert.ToInt32(this.EndDate.Subtract(this.StartDate).TotalDays)).Sum();
                return workingDays;
            }
        }
    }
}
