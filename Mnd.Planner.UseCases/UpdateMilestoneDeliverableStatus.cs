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
    public class UpdateMilestoneDeliverableStatus : AbstractUseCase
    {
        RDeliverableStatus _deliverable;
        RMilestoneStatus _milestone;

        public UpdateMilestoneDeliverableStatus(RDeliverableStatus deliverable, RMilestoneStatus milestone)
        {
            _deliverable = deliverable;
            _milestone = milestone;
        }

        public override void Execute()
        {
            _deliverable.UpdateStatusForMilestone(_milestone);
        }
    }
}
