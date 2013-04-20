using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.Helpers;

namespace Mnd.Planner.Domain
{
    public class Day
    {
        public DateTime Date { get; set; }
        public int Number { get; set; }
    }

    public class DayList : List<Day>
    {
        ///// <summary>
        ///// OBSOLETE?
        ///// </summary>
        ///// <param name="index"></param>
        ///// <returns></returns>
        //public Day this[DateTime index]
        //{
        //    get
        //    {
        //        return this.Where(x => x.Date.ToShortDateString() == index.ToShortDateString()).SingleOrDefault();
        //    }
        //}

        public Day this[string index]
        {
            get
            {
                return this.Where(x => x.Date.ToDutchString() == index).SingleOrDefault();
            }
        }
    }

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

        public int AmountWorkingDays
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

        public DayList ListWorkingDays
        {
            get
            {
                var dayNum = 0;

                var workingDays = Enumerable.Range(0, Convert.ToInt32(this.EndDate.Subtract(this.StartDate).TotalDays))
                    .Select(
                        i => {
                                if (!(new[] { DayOfWeek.Saturday, DayOfWeek.Sunday }.Contains(this.StartDate.AddDays(i).DayOfWeek)))
                                {
                                    dayNum++;
                                    return new Day { Date = this.StartDate.AddDays(i), Number = dayNum };
                                }
                                else
                                {
                                    return null;
                                }
                            })
                    .Where(x => x != null);
                var lst = new DayList();
                lst.AddRange(workingDays.ToList());
                return lst;
            }
        }

        public DayList ListAllDays
        {
            get
            {
                var dayNum = 0;

                var allDays = Enumerable.Range(0, Convert.ToInt32(this.EndDate.Subtract(this.StartDate).TotalDays))
                    .Select(i =>
                        {
                            dayNum++;
                            return new Day { Date = this.StartDate.AddDays(i), Number = dayNum };
                        });
                var lst = new DayList();
                lst.AddRange(allDays.ToList());
                return lst;
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
