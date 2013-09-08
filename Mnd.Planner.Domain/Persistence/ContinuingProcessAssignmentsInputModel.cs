using System;
using System.Collections.Generic;
using System.Linq;
using Mnd.DataAccess;

namespace Mnd.Planner.Domain.Persistence
{
    public class ContinuingProcessAssignmentInputModel : IBasicCrudUsable
    {
        public int Id { get; set; }
        public int ProcessId { get; set; }
        public int PersonId { get; set; }
        public int DeliverableId { get; set; }
        public int ActivityId { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public int HoursPerWeek { get; set; }
    }
}