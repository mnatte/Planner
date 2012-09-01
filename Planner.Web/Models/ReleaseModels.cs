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

        public class Milestone
        {
            public int Id { get; set; }
            public string Title { get; set; }
            public string Description { get; set; }
            public DateTime Date { get; set; }
            public string Time { get; set; }
            private List<Deliverable> _deliverables;
            public IList<Deliverable> Deliverables
            {
                get
                {
                    if (_deliverables == null)
                        _deliverables = new List<Deliverable>();
                    return _deliverables;
                }
            }
        }

        public class Deliverable
        {
            public int Id { get; set; }
            public string Title { get; set; }
            public string Description { get; set; }
            public string Location { get; set; }
            public string State { get; set; }
            public string Owner { get; set; }
            public string Format { get; set; }
            public int InitialHoursEstimate { get; set; }
            public int HoursRemaining { get; set; }
        }


        public class ResourceAssignment
        {
            public int Id { get; set; }
            public ReleaseModels.Resource Resource { get; set; }
            public ReleaseModels.Phase Phase { get; set; }
            public ReleaseModels.Project Project { get; set; }
            public double FocusFactor { get; set; }
            public DateTime StartDate { get; set; }
            public DateTime EndDate { get; set; }
            public string Activity { get; set; }
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
            /// Enable coupling of Projects to Releases to resources 
            /// </summary>
            private List<Project> _projects;
            public IList<Project> Projects
            {
                get
                {
                    if (_projects == null)
                        _projects = new List<Project>();
                    return _projects;
                }
            }

            private List<Milestone> _milestones;
            public IList<Milestone> Milestones
            {
                get
                {
                    if (_milestones == null)
                        _milestones = new List<Milestone>();
                    return _milestones;
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
            public Project Project { get; set; }
            public string Status { get; set; }
        }

        public class Project
        {
            public int Id { get; set; }
            public string Title { get; set; }
            public string ShortName { get; set; }
            public string Description { get; set; }
            public string TfsIterationPath { get; set; }
            public string TfsDevBranch { get; set; }
            private List<ResourceAssignment> _assignedResources;
            public IList<ResourceAssignment> AssignedResources
            {
                get
                {
                    if (_assignedResources == null)
                        _assignedResources = new List<ResourceAssignment>();
                    return _assignedResources;
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
            public int Id { get; set; }
            public string FirstName { get; set; }
            public string MiddleName { get; set; }
            public string LastName { get; set; }
            public string Initials { get; set; }
            public string Email { get; set; }
            public string PhoneNumber { get; set; }
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