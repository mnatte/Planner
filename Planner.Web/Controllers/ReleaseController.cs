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

        public JsonResult GetReleaseSummaries()
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            var releases = new List<ReleaseModels.Release>();

            using (conn)
            {
                conn.Open();

                // Release
                var cmd = new SqlCommand("Select * from Phases where [Type] = 'Release'", conn);
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        releases.Add(new ReleaseModels.Release { Id = int.Parse(reader["Id"].ToString()), EndDate = DateTime.Parse(reader["EndDate"].ToString()), StartDate = DateTime.Parse(reader["StartDate"].ToString()), Title = reader["Title"].ToString(), TfsIterationPath = reader["TfsIterationPath"].ToString() });
                    }
                }
            }
            return this.Json(releases, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetReleaseById(int id)
        {
            // add MultipleActiveResultSets=true to enable nested datareaders
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            ReleaseModels.Release release;

            using (conn)
            {
                conn.Open();

                // Release
                var cmd = new SqlCommand(string.Format("Select * from Phases where Id = {0}", id), conn);
                using (var reader = cmd.ExecuteReader())
                {
                    reader.Read();
                    release = new ReleaseModels.Release { Id = int.Parse(reader["Id"].ToString()), EndDate = DateTime.Parse(reader["EndDate"].ToString()), StartDate = DateTime.Parse(reader["StartDate"].ToString()), Title = reader["Title"].ToString(), TfsIterationPath = reader["TfsIterationPath"].ToString() };
                }

                // Child phases
                var cmd2 = new SqlCommand(string.Format("Select * from Phases where ParentId = {0}", id), conn);
                using (var reader = cmd2.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        release.Phases.Add(new ReleaseModels.Phase { Id =  int.Parse(reader["Id"].ToString()), EndDate = DateTime.Parse(reader["EndDate"].ToString()), StartDate = DateTime.Parse(reader["StartDate"].ToString()), Title = reader["Title"].ToString() });
                    }
                }

                // Backlog
                var cmd3 = new SqlCommand(string.Format("Select i.BusinessId, i.ContactPerson, i.WorkRemaining, i.Title, i.State, p.Id AS ProjectId from TfsImport i INNER JOIN Phases r ON i.IterationPath LIKE r.TfsIterationPath + '%' INNER JOIN Projects p on i.IterationPath LIKE p.TfsIterationPath + '%' WHERE r.Id = {0}", id), conn);
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

                            // Resources
                            var team = new ReleaseModels.Team();
                            var cmd5 = new SqlCommand(String.Format("Select * from ReleaseResources where ReleaseId = {0} and ProjectId = {1}", id, reader["ProjectId"].ToString()), conn);
                            using (var reader3 = cmd5.ExecuteReader())
                            {
                                while (reader3.Read())
                                {
                                    var cmd6 = new SqlCommand(String.Format("Select * from Persons where Id = {0}", reader3["PersonId"].ToString()), conn);

                                    using (var reader4 = cmd6.ExecuteReader())
                                    {
                                        reader4.Read();
                                        // reader3 is used for FocusFactor since this is stored in ReleaseResources, the rest is from Persons
                                        var teamMember = new ReleaseModels.TeamMember { Initials = reader4["Initials"].ToString(), FocusFactor = double.Parse(reader3["FocusFactor"].ToString()), AvailableHoursPerWeek = int.Parse(reader4["HoursPerWeek"].ToString()) };

                                        var cmd7 = new SqlCommand(String.Format("Select * from Absences where PersonId = {0}", reader3["PersonId"].ToString()), conn);
                                        using (var reader5 = cmd7.ExecuteReader())
                                        {
                                            while (reader5.Read())
                                            {
                                                teamMember.PeriodsAway.Add(new ReleaseModels.Phase { Id = int.Parse(reader5["Id"].ToString()), EndDate = DateTime.Parse(reader5["EndDate"].ToString()), StartDate = DateTime.Parse(reader5["StartDate"].ToString()), Title = reader5["Title"].ToString() });
                                            }
                                        }
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
        
        public JsonResult GetRelease()
        {
            return GetReleaseById(1);
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

        [HttpPost]
        public JsonResult Save(ReleaseInputModel obj)
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            int newId = 0;
            try
            {
                using (conn)
                {
                    conn.Open();

                    var cmd = new SqlCommand("sp_insert_release", conn);
                    cmd.Parameters.Add("@Id", System.Data.SqlDbType.Int).Value = obj.Id;
                    cmd.Parameters.Add("@Title", System.Data.SqlDbType.VarChar).Value = obj.Title;
                    cmd.Parameters.Add("@Descr", System.Data.SqlDbType.VarChar).Value = "";// obj.Descr;
                    cmd.Parameters.Add("@StartDate", System.Data.SqlDbType.DateTime).Value = obj.StartDate.ToDateTimeFromDutchString();
                    cmd.Parameters.Add("@EndDate", System.Data.SqlDbType.DateTime).Value = obj.EndDate.ToDateTimeFromDutchString();
                    cmd.Parameters.Add("@IterationPath", System.Data.SqlDbType.VarChar).Value = obj.TfsIterationPath;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    var result = cmd.ExecuteScalar().ToString();
                    newId = result == string.Empty ? obj.Id : int.Parse(result);
                }

                return GetReleaseById(newId);
            }
            catch(Exception ex)
            {
                throw;
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
