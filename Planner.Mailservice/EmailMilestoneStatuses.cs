using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.Planner.Domain.Repositories;
using Mnd.Helpers;
using Mnd.Mail;
using Mnd.Domain;

namespace Mnd.Planner.UseCases
{
    public class EmailMilestoneStatuses : AbstractUseCase
    {
        string _emailAddress;
        int _amtDays;

        public EmailMilestoneStatuses(string mailAddress, int amtDays)
        {
            _emailAddress = mailAddress;
            _amtDays = amtDays;
        }

        public override void Execute()
        {
            var repository = new MilestoneRepository();
            var milestones = repository.GetMilestonesForComingDays(_amtDays);
            var builder = new StringBuilder();
            var mailer = new MailSender();

            foreach (var ms in milestones)
            {
                builder.Append("\n***********************************************");
                builder.Append(string.Format("\n{0} - {1} - {2} {3}:", ms.Release.Title, ms.Title, ms.Date.ToDutchString(), ms.Time));
                var statuses = repository.GetActivityStatusForMilestones(ms);
                builder.Append("\n----------------------------------------------");
                foreach (var state in statuses)
                {

                    builder.Append(string.Format("\n{0}: {1}", "Project", state.Project.Title));
                    builder.Append(string.Format("\n{0} - {1} - {2} hrs remaining", state.Deliverable.Title, state.Activity.Title, state.HoursRemaining));
                    builder.Append("\n----------------------------------------------");
                }

                builder.Append("\n***********************************************");
                builder.Append("\n\n");

            }
            var content = builder.ToString();
            mailer.SendMail(_emailAddress, "Milestones coming up", content);
        }
    }
}
