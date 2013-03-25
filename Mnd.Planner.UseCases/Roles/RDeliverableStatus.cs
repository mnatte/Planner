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
    public static class RDeliverableStatusImplementations
    {
        /// <summary>
        /// Plan the event in a release
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        public static void UpdateStatusForMilestone(this RDeliverableStatus del, RMilestoneStatus ms)
        {
            var obj = new DeliverableStatusInputModel
            {
                DeliverableId = del.Id,
                MilestoneId = ms.Id,
                ReleaseId = ms.Release.Id,
                Scope = del.Scope.Select( (project) => new ProjectStatusInputModel { Id = project.Id, Workload = project.Workload.Select( (deliv) => new ActivityStatusInputModel { Activity = deliv.Activity, HoursRemaining = deliv.HoursRemaining } ).ToList() }).ToList()
            };

            var rep = new ReleaseRepository();
            rep.SaveDeliverableStatus(obj);
        }
    }
}
