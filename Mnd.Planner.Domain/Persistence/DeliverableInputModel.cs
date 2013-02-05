using System;
using System.Collections.Generic;
using System.Linq;
using Mnd.Planner.Domain;
using Mnd.DataAccess;

namespace Mnd.Planner.Domain.Persistence
{

    #region Deliverable Configuration

    public class DeliverableInputModel : IBasicCrudUsable
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string Location { get; set; }
        public string Format { get; set; }
        public List<Activity> Activities { get; set; }
    }

    #endregion

    #region Deliverable Status

    // {"id":4 
    // "scope":[{"id":3, "workload":[{"hoursRemaining":"2","activity":{"id":1,"title":"Development","description":""}},{"hoursRemaining":"2","activity":{"id":3,"title":"Code Review","description":""}}

    public class DeliverableStatusInputModel
    {
        public int ReleaseId { get; set; }
        public int MilestoneId { get; set; }
        public int DeliverableId { get; set; }
        public List<ProjectStatusInputModel> Scope { get; set; }
    }

    // "scope":[{"id":3, "workload":[{"hoursRemaining":"2","activity":{"id":1,"title":"Development","description":""}},{"hoursRemaining":"2","activity":{"id":3,"title":"Code Review","description":""}}
    public class ProjectStatusInputModel
    {
        public int Id { get; set; }
        public List<ActivityStatusInputModel> Workload { get; set; }
    }

    //"workload":[{"hoursRemaining":"2","activity":{"id":1,"title":"Development","description":""}
    public class ActivityStatusInputModel
    {
        public int HoursRemaining { get; set; }
        public Activity Activity { get; set; }
    }

    #endregion
}