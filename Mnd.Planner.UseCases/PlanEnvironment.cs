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
    public class PlanEnvironment : AbstractUseCase
    {
        Period _period;
        //Release _release;
        SoftwareVersion _version;
        Mnd.Planner.Domain.Models.Environment _environment;

        public PlanEnvironment(Period period, SoftwareVersion version, Mnd.Planner.Domain.Models.Environment environment)
        {
            _period = period;
            _version = version;
            _environment = environment;
        }

        public override void Execute()
        {
            var period = _period.Save();

            var rep = new EnvironmentRepository();
            rep.SaveAssignment(_environment.Id, period.Id, _version.Id, period.Title);
        }
    }
}
