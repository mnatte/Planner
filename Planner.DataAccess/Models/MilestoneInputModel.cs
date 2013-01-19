using System;
using System.Collections.Generic;
using System.Linq;
using Mnd.Planner.Data.DataAccess;

namespace Mnd.Planner.Data.Models
{
    public class MilestoneInputModel : IBasicCrudUsable
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string Time { get; set; }
        public string Date { get; set; }
        public int PhaseId { get; set; }
        public List<ReleaseModels.Deliverable> Deliverables { get; set; }
    }
}