using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.Planner.Domain.Repositories;
using Mnd.Domain;
using Mnd.Planner.UseCases.Roles;
using Mnd.Domain.Roles;

namespace Mnd.Planner.UseCases
{
    public class CreateVisualCuesForGates : AbstractUseCase
    {
        int _amtDays;
        RCueItemUploader _creator;

        public CreateVisualCuesForGates(int amtDays, RCueItemUploader creator)
        {
            _amtDays = amtDays;
            _creator = creator;
        }

        public override void Execute()
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
