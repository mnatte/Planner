using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Mnd.Mvc.Rest;
using Mnd.Planner.Domain.Models;
using Mnd.Planner.Domain.Persistence;
using Mnd.Planner.Domain.Repositories;
using Mnd.Planner.Web.Controllers.InputModels;
using Mnd.Planner.UseCases;
using Mnd.Planner.Domain;
using Mnd.Helpers;

namespace Mnd.Planner.Web.Controllers
{
    public class MeetingController : BaseCrudController<Meeting, MeetingInputModel>
    {
        //
        // GET: /Meeting/

        public MeetingController() 
            :base(new MeetingRepository()) 
        {}

        [HttpPost]
        public JsonResult Schedule(ScheduleReleaseEventInputModel model)
        {
            var uc = new PlanMeeting(new Meeting { Id = model.EventId }, new Release { Id = model.ReleaseId }, model.Date.ToDateTimeFromDutchString(), model.Time);
            uc.Execute();
            return this.Json(string.Format("Meeting is planned"), JsonRequestBehavior.AllowGet);
        }

    }
}
