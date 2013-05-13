using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.Domain;
using Mnd.Domain.Roles;
using Mnd.Planner.Domain.Repositories;
using Mnd.Planner.UseCases.Roles;

namespace Mnd.Planner.UseCases
{
    public class CreateVisualCuesForAbsences : AbstractUseCase
    {
        int _amtDays;
        RCueItemUploader _creator;

        public CreateVisualCuesForAbsences(int amtDays, RCueItemUploader creator)
        {
            _amtDays = amtDays;
            _creator = creator;
        }

        public override void Execute()
        {
            var repository = new ResourceRepository();
            var absences = repository.GetAbsencesForComingDays(_amtDays);

            foreach (var a in absences)
            {
                var builder = new StringBuilder();

                builder.Append(string.Format("{0}: {1}", a.Person.DisplayName, a.Period.ToString()));
                builder.Append("\n");

                var item = new CueItem("Absent: " + a.Person.DisplayName, a.StartDate, "9:00", builder.ToString());
                _creator.CreateVisualCue(item);
                // add notification to history table
                repository.AddNotificationToHistory(a.Id, "AwesomeNote");
            }
        }
    }
}
