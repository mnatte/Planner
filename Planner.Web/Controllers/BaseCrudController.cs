using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data.SqlClient;
using MvcApplication1.DataAccess;

namespace MvcApplication1.Controllers
{
    public abstract class BaseCrudController<T, TInputModel> : Controller where TInputModel : IBasicCrudUsable
    {
        protected BaseCrudRepository<T, TInputModel> Repository;

        protected BaseCrudController(BaseCrudRepository<T, TInputModel> repository)
        {
            this.Repository = repository;
        }

        public JsonResult GetItems()
        {
            var items = this.Repository.GetItems();
            return this.Json(items, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetItemById(int id)
        {
            var item = this.Repository.GetItemById(id);
            return this.Json(item, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult Save(TInputModel obj)
        {
            try
            {
                var item = this.Repository.Save(obj);
                return this.Json(item, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        // DELETE: /Project/Delete/5
        [HttpDelete]
        public JsonResult Delete(int id)
        {
            var result = this.Repository.Delete(id);
            return this.Json(result);
        }

    }
}
