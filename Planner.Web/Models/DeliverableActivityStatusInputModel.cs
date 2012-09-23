using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MvcApplication1.Models
{
    public class StatusInputModel
    {
        public ReleaseInputModel Release { get; set; }
        public MilestoneInputModel Milestone { get; set; }
        public DeliverableInputModel Deliverable { get; set; }
        public List<DeliverableActivityStatusInputModel> ActivityStatuses { get; set; }
    }

    public class DeliverableActivityStatusInputModel
    {
        public int ReleaseId { get; set; }
        public int ProjectId { get; set; }
        public int MilestoneId { get; set; }
        public int DeliverableId { get; set; }
        public int ActivityId { get; set; }
        public int HoursRemaining { get; set; }
    }
}