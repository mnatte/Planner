using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data.SqlClient;
using MvcApplication1.Models;
using MvcApplication1.DataAccess;
using System.Net;

namespace MvcApplication1.Controllers
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
    }
}
