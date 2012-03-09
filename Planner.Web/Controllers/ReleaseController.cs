using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MvcApplication1.Models;
using System.Data.SqlClient;

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
            var release = new ReleaseModels.Release { EndDate = new DateTime(2012, 6, 17), StartDate = new DateTime(2012, 1, 25), Title = "Release 9.2" };

            release.Phases.Add(new ReleaseModels.Phase { StartDate = new DateTime(2012, 2, 24), EndDate = new DateTime(2012, 3, 15), Title = "Development" });
            release.Phases.Add(new ReleaseModels.Phase { StartDate = new DateTime(2012, 3, 18), EndDate = new DateTime(2012, 4, 2), Title = "System Test" });
            release.Phases.Add(new ReleaseModels.Phase { StartDate = new DateTime(2012, 4, 16), EndDate = new DateTime(2012, 4, 30), Title = "UAT" });

            // focusfactor, hoursAvailable (40 p.w., 32, etc.), minus days away (vacation, etc.)

            var teamTq = new ReleaseModels.Team();
            teamTq.TeamMembers.Add(new ReleaseModels.TeamMember { Initials = "CH", FocusFactor = 0.8, AvailableHoursPerWeek = 40 });
            teamTq.TeamMembers.Add(new ReleaseModels.TeamMember { Initials = "JPB", FocusFactor = 0.8, AvailableHoursPerWeek = 40 });
            var Tq = new ReleaseModels.Project { ShortName = "TQ", ProjectTeam = teamTq };

            var teamEu = new ReleaseModels.Team();
            teamEu.TeamMembers.Add(new ReleaseModels.TeamMember { Initials = "KK", FocusFactor = 0.8, AvailableHoursPerWeek = 40 });
            teamEu.TeamMembers.Add(new ReleaseModels.TeamMember { Initials = "TdJ", FocusFactor = 0.8, AvailableHoursPerWeek = 40 });
            var Eu = new ReleaseModels.Project { ShortName = "EU", ProjectTeam = teamEu };

            var teamApac = new ReleaseModels.Team();
            teamApac.TeamMembers.Add(new ReleaseModels.TeamMember { Initials = "TH", FocusFactor = 0.8, AvailableHoursPerWeek = 40 });
            teamApac.TeamMembers.Add(new ReleaseModels.TeamMember { Initials = "AvH", FocusFactor = 0.8, AvailableHoursPerWeek = 40 });
            var Apac = new ReleaseModels.Project { ShortName = "APAC", ProjectTeam = teamApac };

            var teamOpt = new ReleaseModels.Team();
            teamOpt.TeamMembers.Add(new ReleaseModels.TeamMember { Initials = "AvB", FocusFactor = 0.8, AvailableHoursPerWeek = 40 });
            teamOpt.TeamMembers.Add(new ReleaseModels.TeamMember { Initials = "RH", FocusFactor = 0.8, AvailableHoursPerWeek = 40 });
            var Opt = new ReleaseModels.Project { ShortName = "OPTIM", ProjectTeam = teamOpt };

            using (var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI"))
            {
                var cmd = new SqlCommand("Select * from TfsImport", conn);
                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        var feature = new ReleaseModels.Feature { BusinessId = reader["BusinessId"].ToString(), ContactPerson = reader["ContactPerson"].ToString(), RemainingHours = int.Parse(reader["WorkRemaining"].ToString()), Title = reader["Title"].ToString(), Status = reader["State"].ToString() };
                        var iterationPath = reader["IterationPath"].ToString();

                        var project = Opt;
                        if (iterationPath.Contains("APAC"))
                        {
                            project = Apac;
                        }
                        else if (iterationPath.Contains("EU"))
                        {
                            project = Eu;
                        }
                        else if (iterationPath.Contains("TQ"))
                        {
                            project = Tq;
                        }
                        feature.Project = project;
                        release.Backlog.Add(feature);
                    }
                }

            }

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
