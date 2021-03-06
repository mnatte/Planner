﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.Domain;
using Mnd.Planner.Domain.Roles;
using Mnd.Planner.UseCases.Roles;
using Mnd.Planner.Domain;
using Mnd.Planner.Domain.Models;

namespace Mnd.Planner.UseCases
{
    public class PlanContinuingProcessResource: AbstractUseCase
    {
        RHumanResource _resource;
        Process _process;
        Deliverable _deliverable;
        Activity _activity;
        Period _period;
        double _dedication;

        public PlanContinuingProcessResource(RHumanResource resource, Process process, Deliverable deliverable, Activity activity, Period period, double dedication)
        {
            _resource = resource;
            _process = process;
            _deliverable = deliverable;
            _activity = activity;
            _dedication = dedication;
            _period = period;
        }

        public override void Execute()
        {
            _resource.PlanForContinuingProcess(_process, _deliverable, _activity, _period, _dedication);
        }
    }
}
