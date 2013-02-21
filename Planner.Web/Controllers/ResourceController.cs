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
using Mnd.Helpers;
using Mnd.Planner.Domain;
using Mnd.Planner.Domain.Persistence;
using Mnd.Planner.Domain.Repositories;
using Mnd.Mvc.Rest;
using Mnd.Planner.UseCases;

namespace Mnd.Planner.Web.Controllers
{
    public class ResourceController : BaseCrudController<Resource, PersonInputModel>
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
            var viewPeriod = new Period { StartDate = model.StartDate.ToDateTimeFromDutchString(), EndDate = model.EndDate.ToDateTimeFromDutchString() };
            var uc = new EmailResourcePlanning(viewPeriod);
            uc.Execute();
            return this.Json(string.Format("Resourceplanning is mailed for {0} - {1}", model.StartDate, model.EndDate), JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult PlanResource(ResourceAssignmentInputModel model)
        {
            var period = new Period { StartDate = model.StartDate.ToDateTimeFromDutchString(), EndDate = model.EndDate.ToDateTimeFromDutchString() };
            var uc = new PlanResource(new Resource { Id = model.ResourceId }, new Release { Id = model.PhaseId }, new Project { Id = model.ProjectId }, new Milestone { Id = model.MilestoneId }, new Deliverable { Id = model.DeliverableId }, new Activity { Id = model.ActivityId }, period, model.FocusFactor);
            uc.Execute();
            return this.Json(string.Format("Resourceplanning is mailed for {0} - {1}", model.StartDate, model.EndDate), JsonRequestBehavior.AllowGet);
        }
    }
}
