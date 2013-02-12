using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mnd.Planner.Domain.Roles
{
    public interface RMeetingSchedule
    {
        // Domain properties
        int Id { get; }
        DateTime Date { get; set; }
        string Time { get; set; }
    }
}
