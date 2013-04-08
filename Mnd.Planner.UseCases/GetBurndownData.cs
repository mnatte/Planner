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
    public class GetBurndownData : AbstractUseCase
    {
        RMilestoneStatus _milestone;
        DateTime _startDate;

        public GetBurndownData(RMilestoneStatus ms, DateTime startDate)
        {
            _milestone = ms;
            _startDate = startDate;
        }

        public override void Execute()
        {
            _milestone.GetBurndownLine(_startDate);
        }
    }
}
