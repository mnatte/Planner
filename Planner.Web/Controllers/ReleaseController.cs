using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MvcApplication1.Controllers
{
    public class ReleaseController : Controller
    {
        //
        // GET: /Release/

        public ActionResult Index()
        {
            return View();
        }
        
        public JsonResult GetRelease()
        {
            var release = new MvcApplication1.Models.ReleaseModels.Release { EndDate = new DateTime(2012, 6, 17), StartDate = new DateTime(2012, 1, 25), Title = "Release 9.2", WorkingDays = 92 };
            release.Phases.Add(new Models.ReleaseModels.Phase { EndDate = new DateTime(2012, 2, 24), StartDate = new DateTime(2012, 3, 15), Title = "Development", WorkingDays = 35 });
            return this.Json(release, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /Release/Details/5

        public ActionResult Details(int id)
        {
            return View();
        }

        //
        // GET: /Release/Create

        public ActionResult Create()
        {
            return View();
        } 

        //
        // POST: /Release/Create

        [HttpPost]
        public ActionResult Create(FormCollection collection)
        {
            try
            {
                // TODO: Add insert logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }
        
        //
        // GET: /Release/Edit/5
 
        public ActionResult Edit(int id)
        {
            return View();
        }

        //
        // POST: /Release/Edit/5

        [HttpPost]
        public ActionResult Edit(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add update logic here
 
                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        //
        // GET: /Release/Delete/5
 
        public ActionResult Delete(int id)
        {
            return View();
        }

        //
        // POST: /Release/Delete/5

        [HttpPost]
        public ActionResult Delete(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add delete logic here
 
                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }
    }
}
