using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MvcApplication1.Models
{
    public class ReleaseModels
    {
        public class Phase
        {
            public string Title { get; set; }
            public DateTime StartDate { get; set; }
            public DateTime EndDate { get; set; }

            public int WorkingDays
            {
                get
                {
                    var workingDays = Enumerable.Range(0, Convert.ToInt32(this.EndDate.Subtract(this.StartDate).TotalDays))
                    .Select(
                        i => new[] { DayOfWeek.Saturday, DayOfWeek.Sunday }.Contains(this.StartDate.AddDays(i).DayOfWeek) ? 0 : 1
                        )
                    .Sum();

                    return workingDays;
                }
            }
        }

        public class Release : Phase
        {
            private List<Phase> _phases;
            public IList<Phase> Phases
            {
                get
                {
                    if (_phases == null)
                        _phases = new List<Phase>();
                    return _phases;
                }
            }

            private List<Feature> _backlog;
            public IList<Feature> Backlog
            {
                get
                {
                    if (_backlog == null)
                        _backlog = new List<Feature>();
                    return _backlog;
                }
            }
        }

        public class Feature
        {
            public string Title { get; set; }
            public string ContactPerson { get; set; }
            public string BusinessId { get; set; }
            public int Priority { get; set; }
            public int EstimatedHours { get; set; }
            public int RemainingHours { get; set; }
            public int HoursWorked { get; set; }
            public string Project { get; set; }
            public string Status { get; set; }
        }

        public class Project
        {
            public string Title { get; set; }
            public string ShortName { get; set; }
        }
    }
}