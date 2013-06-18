using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.DataAccess;
using Mnd.Planner.Domain.Models;

namespace Mnd.Planner.Domain.Persistence
{
    public class EnvironmentAssignmentInputModel : IBasicCrudUsable
    {
        public int Id { get; set; }
        public string Purpose { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public Mnd.Planner.Domain.Models.Environment Environment { get; set; }
        public SoftwareVersion Version { get; set; }
        // used for removing assignment
        public int PhaseId { get; set; }
    }
}
