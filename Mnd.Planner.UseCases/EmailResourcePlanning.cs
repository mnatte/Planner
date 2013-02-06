using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.Domain;
using Mnd.Planner.Domain;
using Mnd.Mail;
using Mnd.Planner.Domain.Repositories;
using Mnd.Helpers;

namespace Mnd.Planner.UseCases
{
    public class EmailResourcePlanning : AbstractUseCase
    {
        Period _viewPeriod;
        MailSender _mailer;

        public EmailResourcePlanning(Period period)
        {
            _mailer = new MailSender();
            _viewPeriod = period;
        }

        public override void Execute()
        {
            var subject = string.Format("Resource Planning {0} - {1}", _viewPeriod.StartDate.ToDutchString(), _viewPeriod.EndDate.ToDutchString());
            var rep = new ResourceRepository();
            var resources = rep.GetItems();
            var builder = new StringBuilder();

            foreach (var res in resources)
            {
                builder.Append("\n***********************************************");
                builder.Append(string.Format("\n{0}:", res.DisplayName));
                foreach (var ass in res.Assignments.Where(x => x.Period.Overlaps(_viewPeriod)))
                {
                    var overlap = ass.Period.OverlappingPeriod(_viewPeriod);
                    builder.Append(string.Format("\n{0} - {1}:", overlap.StartDate.ToDutchString(), overlap.EndDate.ToDutchString()));
                    builder.Append(string.Format("\n{0} - {1} - {2}: {3} ({4}%)", ass.Phase.Title, ass.Project.Title, ass.Deliverable.Title, ass.Activity.Title, ass.FocusFactor * 100));
                    builder.Append(string.Format("\nDeadline {0}: {1}", ass.Deliverable.Title, ass.Milestone.Date.ToDutchString()));
                    builder.Append("\n----------------------------------------------");
                }
                foreach (var abs in res.PeriodsAway.Where(x => x.Period.Overlaps(_viewPeriod)))
                {
                    builder.Append(string.Format("\nAbsent: {0} - {1} {2}", abs.StartDate.ToDutchString(), abs.EndDate.ToDutchString(), abs.Title));
                }
                builder.Append("\n***********************************************");
                builder.Append("\n\n");
            }
            var content = builder.ToString();
            _mailer.SendMail("martijn.natte@consultant.vfsco.com", subject, content);
        }
    }
}
