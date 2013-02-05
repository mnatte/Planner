using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.Planner.Domain.Repositories;
using Mnd.Planner.Domain.Roles;
using Mnd.Domain;
using Mnd.Planner.UseCases.Roles;

namespace Mnd.Planner.UseCases
{
    public class CreateVisualCuesForGates
    {
        int _amtDays;
        RVisualCueCreator _creator;

        public CreateVisualCuesForGates(int amtDays, RVisualCueCreator creator)
        {
            _amtDays = amtDays;
            _creator = creator;
        }

        public void Execute()
        {
            var repository = new MilestoneRepository();
            var milestones = repository.GetMilestonesForComingDays(_amtDays);

            foreach (var ms in milestones)
            {
                var builder = new StringBuilder();
                var deliverables = repository.GetConfiguredDeliverables(ms);
                foreach (var del in deliverables)
                {
                    builder.Append(string.Format("* {0}", del.Title));
                    builder.Append("\n");
                }

                builder.Append("\n\n");

                var item = new CueItem(ms.Release.Title + " - " + ms.Title, ms.Date, ms.Time, builder.ToString());
                _creator.CreateVisualCue(item);
            }
        }
    }
}
