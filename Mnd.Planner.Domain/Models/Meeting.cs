using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.Planner.Domain.Roles;

namespace Mnd.Planner.Domain.Models
{
    public class Meeting : RMeetingSchedule
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string Objective { get; set; }

        // TODO: refactor to configuration role, enabling automatic creation of releases
        public string Moment { get; set; }

        // TODO: refactor to planning role, enabling customization and planning of releases
        public DateTime Date { get; set; }
        public string Time { get; set; }
    }
}
