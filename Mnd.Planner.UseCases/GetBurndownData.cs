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

namespace Mnd.Planner.UseCases
{
    public class GetBurndownData : AbstractUseCase<BurndownData>
    {
        RMilestoneStatus _milestone;
        DateTime _startDate;

        public GetBurndownData(RMilestoneStatus ms, DateTime startDate)
        {
            _milestone = ms;
            _startDate = startDate;
        }

        /// <summary>
        /// return a list of xy-point lists, meaning multiple graphs
        /// </summary>
        /// <returns></returns>
        public override BurndownData Execute()
        {
            var lst = new List<GraphData>();
            var burndown = new GraphData { Values = _milestone.GetBurndownLine(_startDate), Name = "BurnDown" };
            //var velocity = new GraphData { Values = _milestone.GetVelocityLine(burndown.Values), Name = "Velocity" };
            var velocity = new GraphData { Values = _milestone.GetVelocityLine(_startDate), Name = "Velocity" };
            var ideal = new GraphData { Values = _milestone.GetIdealBurndownLine(_startDate), Name = "Ideal" };
            lst.Add(burndown);
            //lst.Add(velocity);
            lst.Add(velocity);
            lst.Add(ideal);

            var data = new BurndownData { Graphs = lst, Velocity = -Math.Round(_milestone.GetVelocity(burndown.Values), 2) };
            return data;
        }
    }
}
