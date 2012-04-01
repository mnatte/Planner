using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MvcApplication1.Models
{
    public class ReleaseModels
    {
        public class Periods
        {
            private List<Release> _phases;
            public IList<Release> Releases
            {
                get
                {
                    if (_phases == null)
                        _phases = new List<Release>();
                    return _phases;
                }
            }

            private List<Absence> _absences;
            public IList<Absence> Absences
            {
                get
                {
                    if (_absences == null)
                        _absences = new List<Absence>();
                    return _absences;
                }
            }
        }
        public class Phase
        {
            public int Id { get; set; }
            public string Title { get; set; }
            public DateTime StartDate { get; set; }
            public DateTime EndDate { get; set; }
            public string TfsIterationPath { get; set; }

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

        public class Absence : Phase
        {
            public ReleaseModels.Resource Person { get; set; }
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

            /// <summary>
            /// Use Backlog to access Features to Projects to Teams (to Resources)
            /// </summary>
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

            //private List<Team> _teams;
            //public IList<Team> Teams
            //{
            //    get
            //    {
            //        if (_teams == null)
            //            _teams = new List<Team>();
            //        return _teams;
            //    }
            //}
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
            public Project Project { get; set; }
            public string Status { get; set; }
        }

        public class Project
        {
            public string Title { get; set; }
            public string ShortName { get; set; }
            public Team ProjectTeam { get; set; }
        }

        public class Team
        {
            private List<TeamMember> _teamMembers;
            public IList<TeamMember> TeamMembers
            {
                get
                {
                    if (_teamMembers == null)
                        _teamMembers = new List<TeamMember>();
                    return _teamMembers;
                }
            }
        }

        public class Resource
        {
            public string FirstName { get; set; }
            public string MiddleName { get; set; }
            public string LastName { get; set; }
            public string Initials { get; set; }
            public string DisplayName { get { return string.Format("{0} {1} {2}", this.FirstName, this.MiddleName ?? "", this.LastName); } }
            public int AvailableHoursPerWeek { get; set; }
            public Role Function { get; set; }

            private List<Phase> _periodsAway;
            public IList<Phase> PeriodsAway
            {
                get
                {
                    if (_periodsAway == null)
                        _periodsAway = new List<Phase>();
                    return _periodsAway;
                }
            }
        }

        // DCI Role? Persist use case with release, project, team, teammembers, etc.
        public class TeamMember : Resource
        {
            public double FocusFactor { get; set; }
            // Role in team is something else than official Function of resource
            public Role Role { get; set; }
        }

        public class Role
        {
            public string Name { get; set; }

            private List<string> _activities;
            public IList<string> Activities
            {
                get
                {
                    if (_activities == null)
                        _activities = new List<string>();
                    return _activities;
                }
            }
        }
    }
}