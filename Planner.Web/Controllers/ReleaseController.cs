using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MvcApplication1.Models;

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
            var Tq = new ReleaseModels.Project { ShortName = "TQ" };
            var Eu = new ReleaseModels.Project { ShortName = "EU" };
            var Jpn = new ReleaseModels.Project { ShortName = "JPN" };
            var Opt = new ReleaseModels.Project { ShortName = "OPTIM" };

            var release = new ReleaseModels.Release { EndDate = new DateTime(2012, 6, 17), StartDate = new DateTime(2012, 1, 25), Title = "Release 9.2" };

            release.Phases.Add(new ReleaseModels.Phase { StartDate = new DateTime(2012, 2, 24), EndDate = new DateTime(2012, 3, 15), Title = "Development" });
            release.Phases.Add(new ReleaseModels.Phase { StartDate = new DateTime(2012, 3, 18), EndDate = new DateTime(2012, 4, 2), Title = "System Test" });
            release.Phases.Add(new ReleaseModels.Phase { StartDate = new DateTime(2012, 4, 16), EndDate = new DateTime(2012, 4, 30), Title = "UAT" });

            release.Backlog.Add(new ReleaseModels.Feature { BusinessId = "TP100", ContactPerson = "Kris Kater", EstimatedHours = 12, HoursWorked = 2, Priority = 15, Project = "TQ", RemainingHours=12, Title = "TQ Scorecard", Status="Ready For Dev"});
            release.Backlog.Add(new ReleaseModels.Feature { BusinessId = "TP230", ContactPerson = "Arno van Hout", EstimatedHours = 10, HoursWorked = 0, Priority = 2, Project = "TQ", RemainingHours = 10, Title = "GUI Maintenance", Status = "Ready For Dev" });
            release.Backlog.Add(new ReleaseModels.Feature { BusinessId = "TP140", ContactPerson = "Arno van Hout", EstimatedHours = 210, HoursWorked = 30, Priority = 1, Project = "EU", RemainingHours = 120, Title = "NEXT Integration", Status = "Under Development" });
            release.Backlog.Add(new ReleaseModels.Feature { BusinessId = "TP6035", ContactPerson = "Tanvir Hossain", EstimatedHours = 120, HoursWorked = 0, Priority = 10, Project = "JPN", RemainingHours = 110, Title = "Use case A", Status = "Under Analysis" });
            release.Backlog.Add(new ReleaseModels.Feature { BusinessId = "TP0030", ContactPerson = "Twan de Jong", EstimatedHours = 91, HoursWorked = 20, Priority = 21, Project = "JPN", RemainingHours = 78, Title = "Use case B", Status = "Ready For SystemTest" });
            release.Backlog.Add(new ReleaseModels.Feature { BusinessId = "1234", ContactPerson = "Andreas van Bergen", EstimatedHours = 40, HoursWorked = 0, Priority = 3, Project = "OPTIM", RemainingHours = 40, Title = "Reduce DB calls", Status = "Ready For Dev" });
            release.Backlog.Add(new ReleaseModels.Feature { BusinessId = "2345", ContactPerson = "Martijn van der Munnik", EstimatedHours = 30, HoursWorked = 0, Priority = 4, Project = "OPTIM", RemainingHours = 30, Title = "Remove Threading", Status = "Under Development" });
            release.Backlog.Add(new ReleaseModels.Feature { BusinessId = "3456", ContactPerson = "Reinier Hutzeson", EstimatedHours = 35, HoursWorked = 10, Priority = 5, Project = "OPTIM", RemainingHours = 35, Title = "Implement Caching", Status = "Under Development" });

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
