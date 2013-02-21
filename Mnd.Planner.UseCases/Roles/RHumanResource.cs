using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.Planner.Domain;
using Mnd.Planner.Domain.Repositories;
using Mnd.Planner.Domain.Roles;
using Mnd.Planner.Domain.Persistence;

namespace Mnd.Planner.UseCases.Roles
{
    public static class RHumanResourceImplementations
    {
        /// <summary>
        /// Plan the event in a release
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        public static void Plan(this RHumanResource person, Release release, Project project, Milestone milestone, Deliverable deliverable, Activity activity, Period assignedPeriod, double focusFactor)
        {
            var rep = new ResourceRepository();
            try
            {
                rep.SaveAssignment(release.Id, project.Id, person.Id, milestone.Id, deliverable.Id, activity.Id, assignedPeriod.StartDate, assignedPeriod.EndDate, focusFactor);
            }
            catch (Exception ex)
            {
                throw;
            }
        }
    }
}
