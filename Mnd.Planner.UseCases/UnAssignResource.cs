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
    public class UnAssignResource: AbstractUseCase
    {
        RHumanResource _resource;
        Release _release;
        Project _project;
        Milestone _milestone;
        Deliverable _deliverable;
        Activity _activity;
        Period _period;

        public UnAssignResource(RHumanResource resource, Release release, Project project, Milestone milestone, Deliverable deliverable, Activity activity, Period period)
        {
            _resource = resource;
            _release = release;
            _milestone = milestone;
            _deliverable = deliverable;
            _activity = activity;
            _period = period;
            _project = project;
        }

        public override void Execute()
        {
            _resource.UnAssign(_release, _project, _milestone, _deliverable, _activity, _period);
        }
    }
}
