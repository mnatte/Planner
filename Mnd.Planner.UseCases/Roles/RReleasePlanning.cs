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
    public static class RReleasePlanningImplementations
    {
        /// <summary>
        /// Load Release configuration
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        public static void LoadPhasesAndMilestonesAndProjects(this RReleasePlanning release)
        {
            var rep = new ReleaseRepository();
            var rel =  rep.GetReleaseSummary(release.Id);
            release.Milestones.AddRange(rel.Milestones);
            release.Phases.AddRange(rel.Phases);
            release.Projects.AddRange(rel.Projects);
        }

        /// <summary>
        /// Create status records for Milestone Deliverables. Used in Release Planning Overview for status as well as planning overview
        /// </summary>
        /// <param name="release"></param>
        public static void GenerateMilestoneStatusRecords(this RReleasePlanning release)
        {
            var rep = new ReleaseRepository();
            rep.GenerateStatusRecords(release);
        }
    }
}
