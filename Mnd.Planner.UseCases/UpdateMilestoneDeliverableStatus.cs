using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.Domain;
using Mnd.Planner.Domain.Roles;
using Mnd.Planner.UseCases.Roles;
using Mnd.Planner.Domain;
using CuttingEdge.Conditions;

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
            // pre-conditions
            Condition.WithExceptionOnFailure<ProcessException>().Requires(_deliverable.Id > 0, "_deliverable").IsTrue(Because.MustHaveValidId);
            Condition.WithExceptionOnFailure<ProcessException>().Requires(_milestone.Id > 0, "_milestone").IsTrue(Because.MustHaveValidId);
            Condition.WithExceptionOnFailure<ProcessException>().Requires(_milestone.Release, "_milestone.Release")
                .IsNotNull(Because.MayNotBeNull)
                .Evaluate(_milestone.Release.Id > 0, Because.MustHaveValidId);

            _deliverable.UpdateStatusForMilestone(_milestone);

            // post-conditions
            Condition.Ensures(0).IsEqualTo(0); // throws PostconditionException on failure
        }
    }
}
