using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Mnd.Mvc.Rest;
using Mnd.Planner.Domain.Models;
using Mnd.Planner.Domain.Persistence;
using Mnd.Planner.Domain.Repositories;
using Mnd.Planner.UseCases;
using Mnd.Planner.Domain;
using Mnd.Helpers;

namespace Mnd.Planner.Web.Controllers
{
    public class EnvironmentController : BaseCrudController<Mnd.Planner.Domain.Models.Environment, EnvironmentInputModel>
    {
        public EnvironmentController()
            : base(new EnvironmentRepository())
        { }
        //
        // GET: /Environment/

        public ActionResult Index()
        {
            return View();
        }

        public JsonResult GetEnvironmentsWithPlanning()
        {
            var uc = new GetEnvironmentsPlanning();
            var items = uc.Execute();

            return this.Json(items, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetAllVersions()
        {
            //var uc = new GetEnvironmentsPlanning();
            //var items = uc.Execute();

            var rep = new SoftwareVersionRepository();
            var items = rep.GetItems();

            return this.Json(items, JsonRequestBehavior.AllowGet);
        }

        public JsonResult AddAssignment(EnvironmentAssignmentInputModel ass)
        {
            var uc = new PlanEnvironment(new Phase { Id = ass.PhaseId, Title = ass.Purpose, EndDate = ass.EndDate.ToDateTimeFromDutchString(), StartDate = ass.StartDate.ToDateTimeFromDutchString() }, ass.Version, ass.Environment);
            var env = uc.Execute();

            return this.Json(env, JsonRequestBehavior.AllowGet);
        }

        public JsonResult RemoveAssignment(EnvironmentAssignmentInputModel ass)
        {
            var uc = new UnAssignEnvironment(new Phase { Id = ass.PhaseId }, ass.Version, ass.Environment);
            var env = uc.Execute();

            return this.Json(env, JsonRequestBehavior.AllowGet);
        }
    }
}
