﻿using System;
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
                var cmd = new SqlCommand("Select * from Phases where ISNULL(ParentId, 0) = 0", conn);
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        var rel = new ReleaseModels.Release { Id = int.Parse(reader["Id"].ToString()), EndDate = DateTime.Parse(reader["EndDate"].ToString()), StartDate = DateTime.Parse(reader["StartDate"].ToString()), Title = reader["Title"].ToString(), TfsIterationPath = reader["TfsIterationPath"].ToString() };

                        // Child phases
                        var cmd2 = new SqlCommand(string.Format("Select * from Phases where ParentId = {0}", rel.Id), conn);
                        using (var reader2 = cmd2.ExecuteReader())
                        {
                            while (reader2.Read())
                            {
                                rel.Phases.Add(new ReleaseModels.Phase { Id = int.Parse(reader2["Id"].ToString()), EndDate = DateTime.Parse(reader2["EndDate"].ToString()), StartDate = DateTime.Parse(reader2["StartDate"].ToString()), Title = reader2["Title"].ToString(), TfsIterationPath = reader2["TfsIterationPath"].ToString() });
                            }
                        }

                        var projs = new SqlCommand(string.Format("Select rp.ProjectId, p.Title, p.ShortName from ReleaseProjects rp inner join Projects p on rp.ProjectId = p.Id where PhaseId = {0}", rel.Id), conn);
                        using (var reader3 = projs.ExecuteReader())
                        {
                            while (reader3.Read())
                            {
                                var p = new ReleaseModels.Project { Id = int.Parse(reader3["ProjectId"].ToString()), Title = reader3["Title"].ToString(), ShortName = reader3["ShortName"].ToString() };
                                rel.Projects.Add(p);
                            }
                        }
                        releases.Add(rel);
                    }
                }
            }
            return this.Json(releases, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetReleaseSummaryById(int id)
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            ReleaseModels.Release release = null;

            using (conn)
            {
                conn.Open();

                // Release
                var cmd = new SqlCommand(string.Format("Select * from Phases where Id = {0}", id), conn);
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        release = new ReleaseModels.Release { Id = int.Parse(reader["Id"].ToString()), EndDate = DateTime.Parse(reader["EndDate"].ToString()), StartDate = DateTime.Parse(reader["StartDate"].ToString()), Title = reader["Title"].ToString(), TfsIterationPath = reader["TfsIterationPath"].ToString() };

                        // Child phases
                        var cmd2 = new SqlCommand(string.Format("Select * from Phases where ParentId = {0}", release.Id), conn);
                        using (var reader2 = cmd2.ExecuteReader())
                        {
                            while (reader2.Read())
                            {
                                release.Phases.Add(new ReleaseModels.Phase { Id = int.Parse(reader2["Id"].ToString()), EndDate = DateTime.Parse(reader2["EndDate"].ToString()), StartDate = DateTime.Parse(reader2["StartDate"].ToString()), Title = reader2["Title"].ToString(), TfsIterationPath = reader2["TfsIterationPath"].ToString() });
                            }
                        }

                        var projs = new SqlCommand(string.Format("Select rp.ProjectId, p.Title, p.ShortName from ReleaseProjects rp inner join Projects p on rp.ProjectId = p.Id where PhaseId = {0}", release.Id), conn);
                        using (var reader3 = projs.ExecuteReader())
                        {
                            while (reader3.Read())
                            {
                                var p = new ReleaseModels.Project { Id = int.Parse(reader3["ProjectId"].ToString()), Title = reader3["Title"].ToString(), ShortName = reader3["ShortName"].ToString() };
                                release.Projects.Add(p);
                            }
                        }
                    }
                }
            }
            return this.Json(release, JsonRequestBehavior.AllowGet);
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
                        release.Phases.Add(new ReleaseModels.Phase { Id = int.Parse(reader["Id"].ToString()), EndDate = DateTime.Parse(reader["EndDate"].ToString()), StartDate = DateTime.Parse(reader["StartDate"].ToString()), Title = reader["Title"].ToString(), TfsIterationPath = reader["TfsIterationPath"].ToString() });
                    }
                }

                // Projects
                using (var cmdProjects = new SqlCommand(string.Format("SELECT rp.id, rp.PhaseId as ReleaseId, rp.ProjectId, p.Title, p.[Description], p.TfsIterationPath, p.TfsDevBranch, p.ShortName FROM ReleaseProjects rp INNER JOIN Projects p on rp.ProjectId = p.Id WHERE rp.PhaseId = {0}", id), conn))
                {
                    using (var projectsReader = cmdProjects.ExecuteReader())
                    {
                        while (projectsReader.Read())
                        {
                            var project = new ReleaseModels.Project { ShortName = projectsReader["ShortName"].ToString(), Id = int.Parse(projectsReader["ProjectId"].ToString()) };

                            // Backlog
                            var cmd3 = new SqlCommand(string.Format("Select i.BusinessId, i.ContactPerson, i.WorkRemaining, i.Title, i.State, p.Id AS ProjectId, p.ShortName as ProjectShortName from TfsImport i INNER JOIN Phases r ON i.IterationPath LIKE r.TfsIterationPath + '%' INNER JOIN Projects p on i.IterationPath LIKE p.TfsIterationPath + '%' WHERE r.Id = {0}", id), conn);
                            using (var featuresReader = cmd3.ExecuteReader())
                            {
                                while (featuresReader.Read())
                                {
                                    var feature = new ReleaseModels.Feature { BusinessId = featuresReader["BusinessId"].ToString(), ContactPerson = featuresReader["ContactPerson"].ToString(), RemainingHours = int.Parse(featuresReader["WorkRemaining"].ToString()), Title = featuresReader["Title"].ToString(), Status = featuresReader["State"].ToString() };
                                    project.Backlog.Add(feature);
                                }
                            }

                            // Assigned Resources
                            var cmdReleaseResources = new SqlCommand(String.Format("Select rr.*, p.Initials, p.HoursPerWeek from ReleaseResources rr INNER JOIN Persons p on rr.PersonId = p.Id where rr.ReleaseId = {0} and rr.ProjectId = {1}", id, project.Id), conn);
                            using (var releaseResourcesReader = cmdReleaseResources.ExecuteReader())
                            {
                                while (releaseResourcesReader.Read())
                                {
                                    var assignment = new ReleaseModels.ResourceAssignment { EndDate = DateTime.Parse(releaseResourcesReader["EndDate"].ToString()), StartDate = DateTime.Parse(releaseResourcesReader["StartDate"].ToString()), FocusFactor = double.Parse(releaseResourcesReader["FocusFactor"].ToString()), Resource = new ReleaseModels.Resource { AvailableHoursPerWeek = int.Parse(releaseResourcesReader["HoursPerWeek"].ToString()), Initials = releaseResourcesReader["Initials"].ToString() } };
                                    // get absences
                                    var cmdAbsences = new SqlCommand(String.Format("Select * from Absences where PersonId = {0}", releaseResourcesReader["PersonId"].ToString()), conn);
                                    using (var absencesReader = cmdAbsences.ExecuteReader())
                                    {
                                        while (absencesReader.Read())
                                        {
                                            assignment.Resource.PeriodsAway.Add(new ReleaseModels.Phase { Id = int.Parse(absencesReader["Id"].ToString()), EndDate = DateTime.Parse(absencesReader["EndDate"].ToString()), StartDate = DateTime.Parse(absencesReader["StartDate"].ToString()), Title = absencesReader["Title"].ToString() });
                                        }
                                    }
                                    project.AssignedResources.Add(assignment);
                                }
                            }

                            release.Projects.Add(project);
                        }
                    }
                }
            }

            conn.Close();

            var result = this.Json(release, JsonRequestBehavior.AllowGet);
            return result;
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

                    var cmd = new SqlCommand("sp_upsert_release", conn);
                    cmd.Parameters.Add("@Id", System.Data.SqlDbType.Int).Value = obj.Id;
                    cmd.Parameters.Add("@Title", System.Data.SqlDbType.VarChar).Value = obj.Title;
                    cmd.Parameters.Add("@Descr", System.Data.SqlDbType.VarChar).Value = "";// obj.Descr;
                    cmd.Parameters.Add("@StartDate", System.Data.SqlDbType.DateTime).Value = obj.StartDate.ToDateTimeFromDutchString();
                    cmd.Parameters.Add("@EndDate", System.Data.SqlDbType.DateTime).Value = obj.EndDate.ToDateTimeFromDutchString();
                    cmd.Parameters.Add("@IterationPath", System.Data.SqlDbType.VarChar).Value = obj.TfsIterationPath ?? "";
                    cmd.Parameters.Add("@ParentId", System.Data.SqlDbType.Int).Value = obj.ParentId;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    var result = cmd.ExecuteScalar().ToString();

                    if (result == string.Empty && obj.ParentId == 0)
                    // it's an update of a root node
                    {
                        newId = obj.Id;
                    }
                    else if (result != string.Empty && obj.ParentId == 0)
                    // it's an insert of a root node
                    {
                            newId = int.Parse(result);
                    }
                    else
                    // it's a child; return parentId
                    {
                        newId = obj.ParentId;
                    }

                    // completely renew the Projects for the Release as set in the client app
                    var cmdDelCross = new SqlCommand(string.Format("Delete from ReleaseProjects where PhaseId = {0}", newId), conn);
                    cmdDelCross.ExecuteNonQuery();

                    if (obj.Projects != null && obj.Projects.Count > 0)
                    {
                        var cmdInsertReleaseProject = new SqlCommand("sp_insert_releaseproject", conn);
                        cmdInsertReleaseProject.Parameters.Add("@ReleaseId", System.Data.SqlDbType.Int).Value = obj.Id;
                        cmdInsertReleaseProject.Parameters.Add("@ProjectId", System.Data.SqlDbType.Int).Value = 0;
                        cmdInsertReleaseProject.CommandType = System.Data.CommandType.StoredProcedure;

                        foreach (var proj in obj.Projects)
                        {
                            cmdInsertReleaseProject.Parameters["@ProjectId"].Value = proj.Id;
                            cmdInsertReleaseProject.ExecuteNonQuery();
                        }
                    }
                }

                return GetReleaseSummaryById(newId);
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
        // DELETE: /Release/Delete/5
        [HttpDelete]
        public JsonResult Delete(int id)
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            int amount = 0;
            try
            {
                using (conn)
                {
                    conn.Open();

                    // Remove Child phases
                    var cmdChild = new SqlCommand(string.Format("Select * from Phases where ParentId = {0}", id), conn);
                    using (var reader = cmdChild.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            var cmdPhases = new SqlCommand(string.Format("Delete from Phases where Id = {0}", reader["Id"].ToString()), conn);
                            amount += cmdPhases.ExecuteNonQuery();
                        }
                    }

                    // Remove Release
                    var cmdMain = new SqlCommand(string.Format("Delete from Phases where Id = {0}", id), conn);
                    amount += cmdMain.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                throw;
            }
            return this.Json(string.Format("{0} rows deleted", amount), JsonRequestBehavior.AllowGet); 
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
