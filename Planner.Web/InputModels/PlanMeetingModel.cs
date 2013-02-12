using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mnd.Planner.Web.Controllers.InputModels
{
    public class PlanMeetingInputModel
    {
        public string Time { get; set; }
        public string Date { get; set; }
        public int ReleaseId { get; set; }
        public int MeetingId { get; set; }
    }
}
