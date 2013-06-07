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
    /// <summary>
    /// Set start and end date for a period
    /// </summary>
    public class PlanPeriod : AbstractUseCase
    {
        RPeriodSchedule _period;
        Release _release;
        DateTime _startDate;
        DateTime _endDate;

        public PlanPeriod(RPeriodSchedule period, DateTime startDate, DateTime endDate)
        {
            _period = period;
            _startDate = startDate;
            _endDate = endDate;
        }

        public override void Execute()
        {
            _period.Plan(_startDate, _endDate);
        }
    }
}
