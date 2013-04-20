using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.Planner.Domain.Roles;
using Mnd.Planner.Domain;
using System.Data.SqlClient;
using Mnd.Planner.Domain.Persistence;
using Mnd.Planner.Domain.Repositories;
using Mnd.Helpers;
using System.Diagnostics;
using Mnd.Domain;

namespace Mnd.Planner.UseCases.Roles
{
    public static class RMilestoneStatusImplementations
    {
        
        public static int TotalRemainingHours(this RMilestoneStatus ms)
        {
            var workload = ms.Deliverables.Select(del => del.Scope.Select(proj => proj.Workload.Sum(x => x.HoursRemaining))).Sum(x=>x.Sum());
            return workload;
        }

        /// <summary>
        /// OBSOLETE
        /// </summary>
        /// <param name="ms"></param>
        /// <param name="startDate"></param>
        public static void GetBurnDownData(this RMilestoneStatus ms, DateTime startDate)
        {
            var rep = new ReleaseRepository();
            var result = rep.GetArtefactsProgress(ms.Release.Id);

            // determine amount days till milestone
            var period = new Period { StartDate = startDate, EndDate = ms.Date };
            var workingDays = period.AmountWorkingDays;

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

        public static List<XYPoint> GetVelocityLine(this RMilestoneStatus ms, DateTime startDate)
        {
            var lst = new List<XYPoint>();
            //var rep = new ReleaseRepository();
            //var result = rep.GetArtefactsProgress(ms.Release.Id);

            // determine amount days till milestone
            var period = new Period { StartDate = startDate, EndDate = ms.Date };
            //var workingDays = period.AmountWorkingDays;

            // get progress data for milestone
            
            //var points = result.Where(x => ms.Id == x.MilestoneId && x.ArtefactId == 28 && period.ListWorkingDays[x.StatusDate.ToDutchString()] != null).Select(aProgress => new XYPoint { Y = aProgress.HoursRemaining, X = period.ListWorkingDays[aProgress.StatusDate.ToDutchString()].Number }).ToList();
            var points = ms.GetTotalWorkloadPerDay(startDate).ToList();
            double a, b;

            List<XYPoint> bestFit = GraphHelpers.GenerateLinearBestFit(points, out a, out b);
            Debug.WriteLine("y = {0:#.####}x {1:+#.####;-#.####}", a, -b);

            for (int index = 0; index < points.Count; index++)
            {
                Debug.WriteLine("X = {0}, Y = {1}, Fit = {2:#.###}", points[index].X, points[index].Y, bestFit[index].Y);
                lst.Add(new XYPoint { X = points[index].X, Y = bestFit[index].Y });
            }
            lst.Add(GraphHelpers.CalculateBestFitValue(period.AmountWorkingDays, a, b));
            return lst;
        }

        public static List<XYPoint> GetVelocityLine(this RMilestoneStatus ms, DateTime startDate, int artefactId)
        {
            var lst = new List<XYPoint>();
            //var rep = new ReleaseRepository();
            //var result = rep.GetArtefactsProgress(ms.Release.Id);

            // determine amount days till milestone
            var period = new Period { StartDate = startDate, EndDate = ms.Date };
            //var workingDays = period.AmountWorkingDays;

            // get progress data for milestone

            //var points = result.Where(x => ms.Id == x.MilestoneId && x.ArtefactId == 28 && period.ListWorkingDays[x.StatusDate.ToDutchString()] != null).Select(aProgress => new XYPoint { Y = aProgress.HoursRemaining, X = period.ListWorkingDays[aProgress.StatusDate.ToDutchString()].Number }).ToList();
            var points = ms.GetWorkloadPerDayAndArtefact(startDate, artefactId).ToList();
            double a, b;

            List<XYPoint> bestFit = GraphHelpers.GenerateLinearBestFit(points, out a, out b);
            Debug.WriteLine("y = {0:#.####}x {1:+#.####;-#.####}", a, -b);

            for (int index = 0; index < points.Count; index++)
            {
                Debug.WriteLine("X = {0}, Y = {1}, Fit = {2:#.###}", points[index].X, points[index].Y, bestFit[index].Y);
                lst.Add(new XYPoint { X = points[index].X, Y = bestFit[index].Y });
            }
            lst.Add(GraphHelpers.CalculateBestFitValue(period.AmountWorkingDays, a, b));
            return lst;
        }

        /// <summary>
        /// OBSOLETE
        /// </summary>
        /// <param name="ms"></param>
        /// <param name="burnDownLine"></param>
        /// <returns></returns>
        public static List<XYPoint> GetVelocityLine(this RMilestoneStatus ms, List<XYPoint> burnDownLine)
        {
            var lst = new List<XYPoint>();
            double a, b;

            List<XYPoint> bestFit = GraphHelpers.GenerateLinearBestFit(burnDownLine, out a, out b);
            Debug.WriteLine("y = {0:#.####}x {1:+#.####;-#.####}", a, -b);

            for (int index = 0; index < burnDownLine.Count; index++)
            {
                Debug.WriteLine("X = {0}, Y = {1}, Fit = {2:#.###}", burnDownLine[index].X, burnDownLine[index].Y, bestFit[index].Y);
                lst.Add(new XYPoint { X = burnDownLine[index].X, Y = bestFit[index].Y });
            }
            return lst;
        }

        public static double GetVelocity(this RMilestoneStatus ms, List<XYPoint> burnDownLine)
        {
            var lst = new List<XYPoint>();
            double a, b;

            List<XYPoint> bestFit = GraphHelpers.GenerateLinearBestFit(burnDownLine, out a, out b);
            return a;
        }

        public static List<XYPoint> GetBurndownLine(this RMilestoneStatus ms, DateTime startDate, int artefactId)
        {
            //var rep = new ReleaseRepository();
            //var result = rep.GetArtefactsProgress(ms.Release.Id);

            //// determine amount days till milestone
            //var period = new Period { StartDate = startDate, EndDate = ms.Date };

            //// poc: check on deliverableId 28 (artefact code change)
            //var points = result.Where(x => ms.Id == x.MilestoneId && x.ArtefactId == artefactId && period.ListWorkingDays[x.StatusDate.ToDutchString()] != null).Select(aProgress => new XYPoint { Y = aProgress.HoursRemaining, X = period.ListWorkingDays[aProgress.StatusDate.ToDutchString()].Number}).ToList();
            var points = ms.GetWorkloadPerDayAndArtefact(startDate, artefactId).ToList();
            return points;
        }

        public static List<XYPoint> GetBurndownLine(this RMilestoneStatus ms, DateTime startDate)
        {
            //var rep = new ReleaseRepository();
            //var result = rep.GetArtefactsProgress(ms.Release.Id);

            //// determine amount days till milestone
            //var period = new Period { StartDate = startDate, EndDate = ms.Date };

            //// 
            //var points = result
            //    .Where(x => ms.Id == x.MilestoneId && period.ListWorkingDays[x.StatusDate.ToDutchString()] != null) // get items for specified milestone with statusdate within specified period
            //    .GroupBy(m => m.StatusDate.ToDutchString(), coll => coll.HoursRemaining, (key, values) => new { HoursRemaining = values.Sum(), Date = key }); // group by statusdate, elementselector (every statusdate-key returns enumerable of remaining hours), return new type

            //var res = points.Select(aProgress => new XYPoint { Y = aProgress.HoursRemaining, X = period.ListWorkingDays[aProgress.Date].Number }) // return new XYPoint type
            //    .ToList();
            var res = ms.GetTotalWorkloadPerDay(startDate).ToList();
            return res;
        }

        public static List<XYPoint> GetIdealBurndownLine(this RMilestoneStatus ms, DateTime startDate, int artefactId)
        {
            //var rep = new ReleaseRepository();
            //var result = rep.GetArtefactsProgress(ms.Release.Id);

            //// determine amount days till milestone
            var period = new Period { StartDate = startDate, EndDate = ms.Date };

            //// poc: check on deliverableId 28 (artefact code change)
            //var firstDayPoint = result
            //    .Where(x => ms.Id == x.MilestoneId && x.ArtefactId == artefactId && period.ListWorkingDays[x.StatusDate.ToDutchString()] != null)
            //    .Select(aProgress => new XYPoint { Y = aProgress.HoursRemaining, X = period.ListWorkingDays[aProgress.StatusDate.ToDutchString()].Number })
            //    .First();
            var firstDayPoint = ms.GetWorkloadPerDayAndArtefact(startDate, artefactId).First();
            var lastDayPoint = new XYPoint { X = period.AmountWorkingDays, Y = 0};
            
            var points = new List<XYPoint>();
            points.Add(firstDayPoint);
            points.Add(lastDayPoint);
            return points;
        }

        public static List<XYPoint> GetIdealBurndownLine(this RMilestoneStatus ms, DateTime startDate)
        {
            //var rep = new ReleaseRepository();
            //var result = rep.GetArtefactsProgress(ms.Release.Id);

            // determine amount days till milestone
            var period = new Period { StartDate = startDate, EndDate = ms.Date };

            // poc: check on deliverableId 28 (artefact code change)
            //var firstDayPoint = result
            //    .Where(x => ms.Id == x.MilestoneId && period.ListWorkingDays[x.StatusDate.ToDutchString()] != null) // get items for specified milestone with statusdate within specified period
            //    .GroupBy(m => m.StatusDate.ToDutchString(), coll => coll.HoursRemaining, (key, values) => new { HoursRemaining = values.Sum(), Date = key }) // group by statusdate, elementselector (every statusdate-key returns enumerable of remaining hours), return new type
            //    .Select(aProgress => new XYPoint { Y = aProgress.HoursRemaining, X = period.ListWorkingDays[aProgress.Date].Number })
            //    .First();
            var firstDayPoint = ms.GetTotalWorkloadPerDay(startDate).First();
            var lastDayPoint = new XYPoint { X = period.AmountWorkingDays, Y = 0 };

            var points = new List<XYPoint>();
            points.Add(firstDayPoint);
            points.Add(lastDayPoint);
            return points;
        }

        private static IEnumerable<XYPoint> GetTotalWorkloadPerDay(this RMilestoneStatus ms, DateTime startDate)
        {
            var rep = new ReleaseRepository();
            var result = rep.GetArtefactsProgress(ms.Release.Id);

            // determine amount days till milestone
            var period = new Period { StartDate = startDate, EndDate = ms.Date };

            // poc: check on deliverableId 28 (artefact code change)
            return result
                .Where(x => ms.Id == x.MilestoneId && period.ListWorkingDays[x.StatusDate.ToDutchString()] != null) // get items for specified milestone with statusdate within specified period
                .GroupBy(m => m.StatusDate.ToDutchString(), coll => coll.HoursRemaining, (key, values) => new { HoursRemaining = values.Sum(), Date = key }) // group by statusdate, elementselector (every statusdate-key returns enumerable of remaining hours), return new type
                .Select(aProgress => new XYPoint { Y = aProgress.HoursRemaining, X = period.ListWorkingDays[aProgress.Date].Number });
        }

        private static IEnumerable<XYPoint> GetWorkloadPerDayAndArtefact(this RMilestoneStatus ms, DateTime startDate, int artefactId)
        {
            var rep = new ReleaseRepository();
            var result = rep.GetArtefactsProgress(ms.Release.Id);

            // determine amount days till milestone
            var period = new Period { StartDate = startDate, EndDate = ms.Date };

            // poc: check on deliverableId 28 (artefact code change)
            return result
                .Where(x => ms.Id == x.MilestoneId && x.ArtefactId == artefactId && period.ListWorkingDays[x.StatusDate.ToDutchString()] != null) // get items for specified milestone with statusdate within specified period
                .GroupBy(m => m.StatusDate.ToDutchString(), coll => coll.HoursRemaining, (key, values) => new { HoursRemaining = values.Sum(), Date = key }) // group by statusdate, elementselector (every statusdate-key returns enumerable of remaining hours), return new type
                .Select(aProgress => new XYPoint { Y = aProgress.HoursRemaining, X = period.ListWorkingDays[aProgress.Date].Number });
        }
    }
}
