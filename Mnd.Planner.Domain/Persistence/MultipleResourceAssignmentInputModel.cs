using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Mnd.DataAccess;

namespace Mnd.Planner.Domain.Persistence
{
    public class MultipleResourceAssignmentInputModel : IBasicCrudUsable
    {
        public int Id { get; set ; }
        public List<int> ResourceIds { get; set; }
        public int ProjectId { get; set; }
        public int MilestoneId { get; set; }
        public int DeliverableId { get; set; }
        public int PhaseId { get; set; }
        public double FocusFactor { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public int ActivityId { get; set; }
    }
}