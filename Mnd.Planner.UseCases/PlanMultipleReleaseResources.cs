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
    public class PlanMultipleReleaseResources: AbstractUseCase
    {
        List<RHumanResource> _resources;
        Release _release;
        Project _project;
        Milestone _milestone;
        Deliverable _deliverable;
        Activity _activity;
        Period _period;
        double _focusFactor;

        public PlanMultipleReleaseResources(List<RHumanResource> resources, Release release, Project project, Milestone milestone, Deliverable deliverable, Activity activity, Period period, double focusFactor)
        {
            _resources = resources;
            _release = release;
            _milestone = milestone;
            _deliverable = deliverable;
            _activity = activity;
            _focusFactor = focusFactor;
            _period = period;
            _project = project;
        }

        public override void Execute()
        {
            foreach (var resource in _resources)
            {
                var uc = new PlanReleaseResource(resource, _release, _project, _milestone, _deliverable, _activity, _period, _focusFactor);
                uc.Execute();
            }
               
        }
    }
}
