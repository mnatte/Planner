using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.Domain;
using Mnd.Planner.Domain.Roles;
using Mnd.Planner.UseCases.Roles;
using Mnd.Planner.Domain;

namespace Mnd.Planner.UseCases
{
    public class PlanMeeting : AbstractUseCase
    {
        RMeetingSchedule _meeting;
        Release _release;
        DateTime _date;
        string _time;

        public PlanMeeting(RMeetingSchedule meeting, Release release, DateTime date, string time)
        {
            _meeting = meeting;
            _release = release;
            _date = date;
            _time = time;
        }

        public override void Execute()
        {
            _meeting.Plan(_release, _date, _time);
        }
    }
}
