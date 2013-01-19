using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data.SqlClient;
using Mnd.Planner.Web.Models;
using Mnd.Planner.Data.Models;
using Mnd.Planner.Data.DataAccess;
using Planne.Data.DataAccess;

namespace Mnd.Planner.Web.Controllers
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

        public JsonResult DeleteActivity(int id)
        {
            var result = _actRepository.Delete(id);
            return this.Json(result);
        }
    }
}
