using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.Planner.Domain.Roles;
using Mnd.Planner.Domain;
using System.Data.SqlClient;
using Mnd.Planner.Domain.Persistence;
using Mnd.Planner.Domain.Repositories;

namespace Mnd.Planner.UseCases.Roles
{
    public static class RMilestoneStatusImplementations
    {
        
        public static int TotalRemainingHours(this RMilestoneStatus ms)
        {
            var workload = ms.Deliverables.Select(del => del.Scope.Select(proj => proj.Workload.Sum(x => x.HoursRemaining))).Sum(x=>x.Sum());
            return workload;
        }

        public static void GetBurnDownData(this RMilestoneStatus ms, DateTime startDate)
        {
            var rep = new ReleaseRepository();
            var result = rep.GetArtefactsProgress(ms.Release.Id);

            // determine amount days till milestone
            var period = new Period { StartDate = startDate, EndDate = ms.Date };
            var workingDays = period.WorkingDays;

            // get progress data for milestone
            var count = 0;
            var totalProgress = result.Where(x => ms.Id == x.MilestoneId).Select(x => new { HoursRemaining = x.HoursRemaining, StatusDate = x.StatusDate, DayNumber = count++ }).ToList().OrderBy(x=>x.StatusDate);

            // determine slope of known status data
            var amountDays = totalProgress.Count();
            var avgDays = totalProgress.Select(x => x.DayNumber).Average();
            var avgHours = totalProgress.Select(x => x.HoursRemaining).Average();
            var deviations = totalProgress.Select(x => new { xDeviation = x.DayNumber - avgDays, yDeviation = x.HoursRemaining - avgHours, xDevTimesyDev = (x.DayNumber - avgDays) * (x.HoursRemaining - avgHours), xDevSquare = (x.DayNumber - avgDays) * (x.DayNumber - avgDays) }).ToList();
            // divide SUM( (x - avgX) * (y - avgY) ) by SUM( (x - avgX) * (x - avgX) )
            var slope = deviations.Select(x => x.xDevTimesyDev).Sum() / deviations.Select(x => x.xDevSquare).Sum();

            // determine intercept: avgY = (slope * avgX) + intercept -> intercept = -((slope * avgX) - avgY)
            var intercept = -((slope * avgDays) - avgHours);

            // formula best fitted line: amtHours = slope * amtDays + intercept
        }
    }
}
