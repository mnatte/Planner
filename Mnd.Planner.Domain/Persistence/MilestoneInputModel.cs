using System;
using System.Collections.Generic;
using System.Linq;
using Mnd.DataAccess;
using Mnd.Planner.Domain;

namespace Mnd.Planner.Domain.Persistence
{
    public class MilestoneInputModel : IBasicCrudUsable
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string Time { get; set; }
        public string Date { get; set; }
        public int PhaseId { get; set; }
        public List<Deliverable> Deliverables { get; set; }
    }
}