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
            // add MultipleActiveResultSets=true to enable nested datareaders
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            ReleaseModels.Release release;

            using (conn)
            {
                conn.Open();

                var cmd = new SqlCommand("Select * from Phases where Id = 1", conn);
                using (var reader = cmd.ExecuteReader())
                {
                    reader.Read();
                    release = new ReleaseModels.Release { EndDate = DateTime.Parse(reader["EndDate"].ToString()), StartDate = DateTime.Parse(reader["StartDate"].ToString()), Title = reader["Title"].ToString() };
                }

                var cmd2 = new SqlCommand("Select * from Phases where ParentId = 1", conn);
                using (var reader = cmd2.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        release.Phases.Add (new ReleaseModels.Phase { EndDate = DateTime.Parse(reader["EndDate"].ToString()), StartDate = DateTime.Parse(reader["StartDate"].ToString()), Title = reader["Title"].ToString() });
                    }
                }

                var cmd3 = new SqlCommand("Select i.BusinessId, i.ContactPerson, i.WorkRemaining, i.Title, i.State, p.Id AS ProjectId from TfsImport i INNER JOIN Projects p on i.IterationPath LIKE p.TfsIterationPath + '%'", conn);
                using (var reader = cmd3.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        var feature = new ReleaseModels.Feature { BusinessId = reader["BusinessId"].ToString(), ContactPerson = reader["ContactPerson"].ToString(), RemainingHours = int.Parse(reader["WorkRemaining"].ToString()), Title = reader["Title"].ToString(), Status = reader["State"].ToString() };
                        
                        // find Project for Feature
                        ReleaseModels.Project project;
                        var cmd4 = new SqlCommand(String.Format("Select * from Projects where Id = {0}", reader["ProjectId"].ToString()), conn);
                        using (var reader2 = cmd4.ExecuteReader())
                        {
                            reader2.Read();
                            project = new ReleaseModels.Project { ShortName = reader2["ShortName"].ToString() };

                            var team = new ReleaseModels.Team();
                            var cmd5 = new SqlCommand(String.Format("Select * from ReleaseResources where ReleaseId = {0} and ProjectId = {1}", "1", reader["ProjectId"].ToString()), conn);
                            using (var reader3 = cmd5.ExecuteReader())
                            {
                                while (reader3.Read())
                                {
                                    var cmd6 = new SqlCommand(String.Format("Select * from Persons where Id = {0}", reader3["PersonId"].ToString()), conn);

                                    using (var reader4 = cmd6.ExecuteReader())
                                    {
                                        // TODO: focusfactor, hoursAvailable (40 p.w., 32, etc.), minus days away (vacation, etc.)

                                        reader4.Read();
                                        // reader3 is used for FocusFactor since this is stored in ReleaseResources, the rest is from Persons
                                        var teamMember = new ReleaseModels.TeamMember { Initials = reader4["Initials"].ToString(), FocusFactor = double.Parse(reader3["FocusFactor"].ToString()), AvailableHoursPerWeek = int.Parse(reader4["HoursPerWeek"].ToString()) };
                                        if (teamMember.Initials == "JS" || teamMember.Initials == "TdJ")
                                            teamMember.PeriodsAway.Add(new ReleaseModels.Phase { EndDate = new DateTime(2012, 3, 29), StartDate = new DateTime(2012, 3, 15), Title = "Vakantie" });
                                        if (teamMember.Initials == "KK")
                                            teamMember.PeriodsAway.Add(new ReleaseModels.Phase { EndDate = new DateTime(2012, 5, 2), StartDate = new DateTime(2012, 4, 21), Title = "Vakantie" });
                                        team.TeamMembers.Add(teamMember);
                                    }
                                }
                            }
                            project.ProjectTeam = team;
                        }

                        feature.Project = project;
                        release.Backlog.Add(feature);
                    }
                }

                conn.Close();
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
