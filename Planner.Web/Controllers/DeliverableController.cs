using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data.SqlClient;
using MvcApplication1.Models;
using MvcApplication1.DataAccess;

namespace MvcApplication1.Controllers
{
    public class DeliverableController : BaseCrudController<ReleaseModels.Deliverable, DeliverableInputModel>
    {
        private ActivityRepository _actRepository;

        public DeliverableController() 
            :base(new DeliverableRepository()) 
        {
            _actRepository = new ActivityRepository();
        }

        public JsonResult GetAllActivities()
        {
            var lst = _actRepository.GetItems();
            return this.Json(lst, JsonRequestBehavior.AllowGet);
        }

        public JsonResult SaveActivity(ActivityInputModel act)
        {
            var result = _actRepository.Save(act);
            return this.Json(result);
        }

        public JsonResult DeleteActivity(int activityId)
        {
            var result = _actRepository.Delete(activityId);
            return this.Json(result);
        }
    }
}
