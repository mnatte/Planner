using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data.SqlClient;
using System.Net;
using System.Text;
using System.Net.Mail;
using Mnd.Mail;
using Mnd.Planner.Data.Models;
using Mnd.Planner.Data.DataAccess;
using Mnd.Helpers;

namespace Mnd.Planner.Web.Controllers
{
    public class ResourceController : BaseCrudController<ReleaseModels.Resource, PersonInputModel>
    {
        public ResourceController()
            : base(new ResourceRepository())
        { }

        [HttpPost]
        public JsonResult SaveAbsence(AbsenceInputModel obj)
        {
            var rep = this.Repository as ResourceRepository;
            var absence = rep.SaveAbsence(obj);
            return this.Json(absence, JsonRequestBehavior.AllowGet);
        }

        // DELETE: /Resource/Delete/5
        [HttpDelete]
        public JsonResult DeleteAbsence(int id)
        {
            var rep = this.Repository as ResourceRepository;
            var amount = rep.DeleteAbsence(id);

            if (amount == 1)
                return this.Json(string.Format("Absence with Id {0} succesfully deleted", id), JsonRequestBehavior.AllowGet);
            else
                Response.StatusCode = (int)HttpStatusCode.InternalServerError;
                return this.Json(string.Format("Absence with Id {0} not deleted", id), JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult MailPlanning(PeriodInputModel model)
        {
            var viewPeriod = new ReleaseModels.Period { StartDate = model.StartDate.ToDateTimeFromDutchString(), EndDate = model.EndDate.ToDateTimeFromDutchString() };
            var subject = string.Format("Resource Planning {0} - {1}", model.StartDate, model.EndDate);


            var rep = this.Repository as ResourceRepository;
            var resources = rep.GetItems();
            var builder = new StringBuilder();

            foreach(var res in resources)
            {
                builder.Append("\n***********************************************");
                builder.Append(string.Format("\n{0}:", res.DisplayName));
                foreach (var ass in res.Assignments.Where(x=>x.Period.Overlaps(viewPeriod)))
                {
                    var overlap = ass.Period.OverlappingPeriod(viewPeriod);
                    builder.Append(string.Format("\n{0} - {1}:", overlap.StartDate.ToDutchString(), overlap.EndDate.ToDutchString()));
                    builder.Append(string.Format("\n{0} - {1} - {2}: {3} ({4}%)", ass.Phase.Title, ass.Project.Title, ass.Deliverable.Title, ass.Activity.Title, ass.FocusFactor * 100));
                    builder.Append(string.Format("\nDeadline {0}: {1}", ass.Deliverable.Title, ass.Milestone.Date.ToDutchString()));
                    builder.Append("\n----------------------------------------------");
                }
                foreach (var abs in res.PeriodsAway.Where(x=>x.Period.Overlaps(viewPeriod)))
                {
                    builder.Append(string.Format("\nAbsent: {0} - {1} {2}", abs.StartDate.ToDutchString(), abs.EndDate.ToDutchString(), abs.Title));
                }
                builder.Append("\n***********************************************");
                builder.Append("\n\n");
            }
            var content = builder.ToString();

            var mailSender = new MailSender();
            mailSender.SendMail("martijn.natte@consultant.vfsco.com", subject, content);

            return this.Json(string.Format("Resourceplanning is mailed for {0} - {1}", model.StartDate, model.EndDate), JsonRequestBehavior.AllowGet);
        }
    }
}
