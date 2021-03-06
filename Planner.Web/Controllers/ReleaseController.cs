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
using Mnd.Domain;
using Microsoft.Web.Mvc;
using System.Web.Script.Serialization;

namespace Mnd.Planner.Web.Controllers
{
    public class ReleaseController : Controller
    {
        public ContentResult GetReleaseSummaries()
        {
            var rep = new ReleaseRepository();
            var releases = rep.GetReleaseSummaries();

            var serializer = new JavaScriptSerializer();

            // For simplicity just use Int32's max value.
            // You could always read the value from the config section mentioned above.
            serializer.MaxJsonLength = Int32.MaxValue;

            var result = new ContentResult
            {
                Content = serializer.Serialize(releases),
                ContentType = "application/json",
            };
            return result;
            
            //return this.Json(releases, JsonRequestBehavior.AllowGet);
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
            //var rep = new ReleaseRepository();
            //rep.SaveDeliverableStatus(obj);
            var del = new Deliverable { Id = obj.DeliverableId };
            foreach(var proj in obj.Scope)
            {
                var project = new Project { Id = proj.Id };
                foreach (var act in proj.Workload)
                {
                    project.Workload.Add(new ActivityStatus { Activity = act.Activity, HoursRemaining = act.HoursRemaining });
                }
                del.Scope.Add(project);
            }
            var ms = new Milestone { Id = obj.MilestoneId, Release = new Release { Id = obj.ReleaseId } };

            var uc = new UpdateMilestoneDeliverableStatus(del, ms);
            uc.Execute();

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

        [HttpPost]
        public JsonResult SchedulePhase(ScheduleReleasePhaseInputModel obj)
        {
            var uc = new ReschedulePeriod(new Phase { Id = obj.EventId }, obj.StartDate.ToDateTimeFromDutchString(), obj.EndDate.ToDateTimeFromDutchString());
            uc.Execute();

            var rep = new ReleaseRepository();
            var release = rep.GetReleaseSummary(obj.ReleaseId);
            return this.Json(release, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// Retrieve progress data for Milestone
        /// </summary>
        /// <param name="phaseid"></param>
        /// <param name="milestoneId"></param>
        /// <returns></returns>
        [HttpGet]
        public JsonResult GetReleaseProgress(int phaseid, int milestoneId)
        {
            // get complete progress data per artefact
            var rep = new ReleaseRepository();
            var progress = rep.GetArtefactsProgress(phaseid, milestoneId);

            // get burndown for total
            var msRep = new MilestoneRepository();
            var ms = msRep.GetItemById(milestoneId);

            try
            {
                // TODO: determine startdate by using the Phase startdate to which the Milestone is connected
                var uc = new GetBurndownData(new Milestone { Id = milestoneId, Date = ms.Date, Release = new Release { Id = phaseid } }, DateTime.Now.AddDays(-40));
                var burndown = uc.Execute();

                return this.Json(new { Progress = progress, Burndown = burndown }, JsonRequestBehavior.AllowGet);
            }
            catch (ConditionNotMetException ex)
            {
                HttpContext.Response.StatusDescription = string.Format("A condition has not been met: {0}", ex.Message);
                HttpContext.Response.StatusCode = 400;
                return this.Json(string.Format("A condition has not been met: {0}", ex.Message), JsonRequestBehavior.AllowGet);
            }
            catch (ProcessException ex)
            {
                HttpContext.Response.StatusDescription = string.Format("A use case processing exception has occurred: {0}", ex.Message);
                HttpContext.Response.StatusCode = 400;
                return this.Json(string.Format("A use case processing exception has occurred: {0}", ex.Message), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                HttpContext.Response.StatusDescription = string.Format("An exception has occurred: {0}", ex.Message);
                HttpContext.Response.StatusCode = 500;
                return this.Json(string.Format("An exception has occurred: {0}", ex.Message), JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Retrieve release snapshots for navigation / selection purposes. No progress data included
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public JsonResult GetReleaseSnapshotsWithProgressStatus()
        {
            var rep = new ReleaseRepository();
            var result = rep.GetReleaseSnapshotsWithProgressData();
            return this.Json(result, JsonRequestBehavior.AllowGet);
        }

        // TODO: move to Process Controller

        [HttpGet]
        public JsonResult GetProcessPerformance(int releaseId)
        {
            // todo: return performance data
            var uc = new GetBurndownData(new Milestone { Id = 24, Release = new Release { Id = releaseId }, Date = DateTime.Parse("24 April 2013") }, DateTime.Now.AddDays(-40));
            var burndown = uc.Execute();
            return this.Json(burndown, JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        public JsonResult CreateVisualCuesForGates(int amountDays)
        {
            var uc = new CreateVisualCuesForGates(amountDays, new AwesomeNoteWriter());
            uc.Execute();
            return this.Json("Visual cues created in AwesomeNote", JsonRequestBehavior.AllowGet);
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
