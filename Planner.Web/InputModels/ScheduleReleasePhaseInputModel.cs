using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mnd.Planner.Web.Controllers.InputModels
{
    public class ScheduleReleasePhaseInputModel
    {
        public string EndDate { get; set; }
        public string StartDate { get; set; }
        public int ReleaseId { get; set; }
        public int EventId { get; set; }
    }
}
