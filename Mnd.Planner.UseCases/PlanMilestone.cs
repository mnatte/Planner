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
    public class PlanMilestone : AbstractUseCase
    {
        RMilestoneSchedule _milestone;
        Release _release;
        DateTime _date;
        string _time;

        public PlanMilestone(RMilestoneSchedule meeting, DateTime date, string time)
        {
            _milestone = meeting;
            _date = date;
            _time = time;
        }

        public override void Execute()
        {
            _milestone.Plan(_date, _time);
        }
    }
}
