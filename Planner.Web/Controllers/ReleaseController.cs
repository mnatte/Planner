﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data.SqlClient;
using System.Net;
using Mnd.Planner.Domain;
using Mnd.Planner.Domain.Persistence;
using Mnd.Planner.Domain.Repositories;
using Mnd.Planner.Web.Controllers.InputModels;
using Mnd.Planner.UseCases;
using Mnd.Helpers;

namespace Mnd.Planner.Web.Controllers
{
    public class ReleaseController : Controller
    {
        public JsonResult GetReleaseSummaries()
        {
            var rep = new ReleaseRepository();
            var releases = rep.GetReleaseSummaries();
            return this.Json(releases, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetReleaseSummaryById(int id)
        {
            var rep = new ReleaseRepository();
            var release = rep.GetReleaseSummary(id);
            return this.Json(release, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetReleaseById(int id)
        {
            var rep = new ReleaseRepository();
            var release = rep.GetRelease(id);
            var result = this.Json(release, JsonRequestBehavior.AllowGet);
            return result;
        }
        
        public JsonResult GetRelease()
        {
            return GetReleaseById(1);
        }

        [HttpPost]
        public JsonResult Save(ReleaseInputModel obj)
        {
            var rep = new ReleaseRepository();
            var rel = rep.Save(obj);
            return this.Json(rel, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult SaveReleaseConfiguration(ReleaseConfigurationInputModel obj)
        {
            var rep = new ReleaseRepository();
            var rel = rep.SaveReleaseConfiguration(obj);
            return this.Json(rel, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult SaveMilestone(MilestoneInputModel obj)
        {
            var rep = new ReleaseRepository();
            var resultRelease = rep.SaveMilestone(obj);

            var result = this.Json(resultRelease, JsonRequestBehavior.AllowGet);
            return result;
        }

        [HttpPost]
        public JsonResult SaveDeliverableStatus(DeliverableStatusInputModel obj)
        {
            var rep = new ReleaseRepository();
            rep.SaveDeliverableStatus(obj);

            var result = this.Json("Saved", JsonRequestBehavior.AllowGet);
            return result;
        }

        //
        // DELETE: /Release/Delete/5
        [HttpDelete]
        public JsonResult Delete(int id)
        {
            var rep = new ReleaseRepository();
            var result = rep.Delete(id);
            if (result)
                return this.Json(string.Format("Release with Id {0} succesfully deleted", id), JsonRequestBehavior.AllowGet);
            else
                Response.StatusCode = (int)HttpStatusCode.InternalServerError;
                return this.Json(string.Format("Release with Id {0} not deleted", id), JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult UnassignMilestone(MilestoneInputModel obj)
        {
            var rep = new ReleaseRepository();
            var release = rep.UnAssignMilestone(obj);
            return this.Json(release, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult ScheduleMilestone(ScheduleReleaseEventInputModel obj)
        {
            var uc = new PlanMilestone(new Milestone { Id = obj.EventId }, obj.Date.ToDateTimeFromDutchString(), obj.Time);
            uc.Execute();

            var rep = new ReleaseRepository();
            var release = rep.GetReleaseSummary(obj.ReleaseId);
            return this.Json(release, JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        public JsonResult GetReleaseProgress(int id)
        {
            var rep = new ReleaseRepository();
            var result = rep.GetArtefactsProgress(id);
            return this.Json(result, JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        public JsonResult GetReleaseSnapshotsWithProgressStatus()
        {
            var rep = new ReleaseRepository();
            var result = rep.GetReleaseSnapshotsWithProgressData();
            return this.Json(result, JsonRequestBehavior.AllowGet);
        }

        #region Unneeded

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
        // GET: /Release/

        public ActionResult Index()
        {
            return View();
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
        #endregion
    }
}
