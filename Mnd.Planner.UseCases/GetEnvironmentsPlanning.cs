using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.Domain;
using Mnd.Planner.Domain.Roles;
using Mnd.Planner.UseCases.Roles;
using Mnd.Planner.Domain;
using Mnd.Helpers;
using Mnd.Planner.Domain.Models;
using CuttingEdge.Conditions;
using Mnd.Planner.Domain.Repositories;

namespace Mnd.Planner.UseCases
{
    public class GetEnvironmentsPlanning : AbstractUseCase<List<Mnd.Planner.Domain.Models.Environment>>
    {
        //RAssignedResource _resource;
        //DateTime _startDate;

        public GetEnvironmentsPlanning()
        {
            //_resource = resource;
            //_startDate = startDate;
        }

        /// <summary>
        /// return a list of xy-point lists, meaning multiple graphs
        /// </summary>
        /// <returns></returns>
        public override List<Mnd.Planner.Domain.Models.Environment> Execute()
        {
            // pre-conditions
            //Condition.WithExceptionOnFailure<ConditionNotMetException>().Requires(_resource, "_resource").IsNotNull(Because.MayNotBeNull);

            var rep = new EnvironmentRepository();
            var items = rep.GetItems();

            foreach (var itm in items)
                itm.LoadPlanning();

            return items;
        }
    }
}
