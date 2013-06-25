using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.Domain;
using Mnd.Planner.Domain.Roles;
using Mnd.Planner.UseCases.Roles;
using Mnd.Planner.Domain;
using Mnd.Planner.Domain.Models;
using Mnd.Planner.Domain.Repositories;

namespace Mnd.Planner.UseCases
{
    /// <summary>
    /// Set start and end date for a period
    /// </summary>
    public class PlanEnvironment : AbstractUseCase<Mnd.Planner.Domain.Models.Environment>
    {
        Phase _period;
        //Release _release;
        SoftwareVersion _version;
        Mnd.Planner.Domain.Models.Environment _environment;

        public PlanEnvironment(Phase period, SoftwareVersion version, Mnd.Planner.Domain.Models.Environment environment)
        {
            _period = period;
            _version = version;
            _environment = environment;
        }

        public override Mnd.Planner.Domain.Models.Environment Execute()
        {
            Phase phase = null;
            var rep = new EnvironmentRepository();
            var relRep = new ReleaseRepository();

            if (_period.Id > 0)
            {
                // existing phase needs update
                phase = relRep.UpdatePhase(_period);
            }
            else
            {
                // new phase must be inserted
                phase = relRep.AddPeriod(_period);

                // add assignment
                rep.SaveAssignment(_environment.Id, phase.Id, _version.Id, phase.Title);
            }
           

            // return environment with planning
            var env = rep.GetItemById(_environment.Id);
            env.LoadPlanning();
            return env;
        }
    }
}
