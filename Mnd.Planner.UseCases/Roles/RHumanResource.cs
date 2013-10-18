using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.Planner.Domain;
using Mnd.Planner.Domain.Repositories;
using Mnd.Planner.Domain.Roles;
using Mnd.Planner.Domain.Persistence;
using Mnd.Planner.Domain.Models;

namespace Mnd.Planner.UseCases.Roles
{
    public static class RHumanResourceImplementations
    {
        /// <summary>
        /// Plan the resource for an assignment
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        public static void PlanForRelease(this RHumanResource person, RReleasePlanning release, Project project, Milestone milestone, Deliverable deliverable, Activity activity, Period assignedPeriod, double focusFactor)
        {
            var rep = new ResourceRepository();
            try
            {
                rep.SaveReleaseAssignment(release.Id, project.Id, person.Id, milestone.Id, deliverable.Id, activity.Id, assignedPeriod.StartDate, assignedPeriod.EndDate, focusFactor);
                // make sure we have status records for all release, project, milestone and deliverable combinations
                if (release.Milestones.Count == 0)
                    release.LoadPhasesAndMilestonesAndProjects();
                release.GenerateMilestoneStatusRecords();
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        /// <summary>
        /// TODO: not used yet; first create continuing process logic
        /// Plan the resource for a continuing process
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        public static void PlanForContinuingProcess(this RHumanResource person, Process process, Deliverable deliverable, Activity activity, Period assignedPeriod, double dedication)
        {
            var rep = new ResourceRepository();
            try
            {
                rep.SaveContinuingProcessAssignment(process.Id, person.Id, deliverable.Id, activity.Id, assignedPeriod.StartDate, assignedPeriod.EndDate, dedication);
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        /// <summary>
        /// UnAssign the resource from the specified deliverable activity
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        public static void UnAssignFromRelease(this RHumanResource person, Release release, Project project, Milestone milestone, Deliverable deliverable, Activity activity, Period assignedPeriod)
        {
            var rep = new ResourceRepository();
            try
            {
                rep.DeleteReleaseAssignment(release.Id, project.Id, person.Id, milestone.Id, deliverable.Id, activity.Id, assignedPeriod.StartDate, assignedPeriod.EndDate);
            }
            catch (Exception ex)
            {
                throw;
            }
        }
    }
}
