using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data.SqlClient;
using MvcApplication1.Models;

namespace MvcApplication1.Controllers
{
    public class ProjectController : Controller
    {
        //
        // GET: /Projects/

        public ActionResult Index()
        {
            return View();
        }

        public JsonResult GetProjects()
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            var projects = new List<ReleaseModels.Project>();

            using (conn)
            {
                conn.Open();

                // Release
                var cmd = new SqlCommand("Select * from Projects", conn);
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        var p = new ReleaseModels.Project { Id = int.Parse(reader["Id"].ToString()), Title = reader["Title"].ToString(), Description = reader["Description"].ToString(), ShortName = reader["ShortName"].ToString(), TfsDevBranch = reader["TfsDevBranch"].ToString(), TfsIterationPath = reader["TfsIterationPath"].ToString() };
                        projects.Add(p);
                    }
                }
            }
            return this.Json(projects, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetProjectById(int id)
        {
            // add MultipleActiveResultSets=true to enable nested datareaders
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            ReleaseModels.Project p = null;

            using (conn)
            {
                conn.Open();

                // Release
                var cmd = new SqlCommand(string.Format("Select * from Projects where Id = {0}", id), conn);
                using (var reader = cmd.ExecuteReader())
                {
                    reader.Read();
                    p = new ReleaseModels.Project { Id = int.Parse(reader["Id"].ToString()), Title = reader["Title"].ToString(), Description = reader["Description"].ToString(), ShortName = reader["ShortName"].ToString(), TfsDevBranch = reader["TfsDevBranch"].ToString(), TfsIterationPath = reader["TfsIterationPath"].ToString() };
                }

                // Backlog
                /*var cmd3 = new SqlCommand(string.Format("Select i.BusinessId, i.ContactPerson, i.WorkRemaining, i.Title, i.State, p.Id AS ProjectId from TfsImport i INNER JOIN Phases r ON i.IterationPath LIKE r.TfsIterationPath + '%' INNER JOIN Projects p on i.IterationPath LIKE p.TfsIterationPath + '%' WHERE r.Id = {0}", id), conn);
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
                */
                conn.Close();
            }

            return this.Json(p, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult Save(ProjectInputModel obj)
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            int newId = 0;
            try
            {
                using (conn)
                {
                    conn.Open();

                    var cmd = new SqlCommand("sp_upsert_project", conn);
                    cmd.Parameters.Add("@Id", System.Data.SqlDbType.Int).Value = obj.Id;
                    cmd.Parameters.Add("@Title", System.Data.SqlDbType.VarChar).Value = obj.Title;
                    cmd.Parameters.Add("@Descr", System.Data.SqlDbType.VarChar).Value = obj.Descr ?? "";
                    cmd.Parameters.Add("@ShortName", System.Data.SqlDbType.VarChar).Value = obj.ShortName ?? "";
                    cmd.Parameters.Add("@TfsDevBranch", System.Data.SqlDbType.VarChar).Value = obj.TfsDevBranch ?? "";
                    cmd.Parameters.Add("@IterationPath", System.Data.SqlDbType.VarChar).Value = obj.TfsIterationPath ?? "";
                    cmd.Parameters.Add("@ContactPersonId", System.Data.SqlDbType.Int).Value = obj.ContactPersonId;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    var result = cmd.ExecuteScalar().ToString();

                    if (result == string.Empty)
                    // it's an update
                    {
                        newId = obj.Id;
                    }
                    else if (result != string.Empty)
                    // it's an insert
                    {
                        newId = int.Parse(result);
                    }

                }

                return GetProjectById(newId);
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
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            int amount = 0;
            try
            {
                using (conn)
                {
                    conn.Open();

                    // Remove Project
                    var cmdMain = new SqlCommand(string.Format("Delete from Projects where Id = {0}", id), conn);
                    amount += cmdMain.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                throw;
            }
            return this.Json(string.Format("{0} rows deleted", amount), JsonRequestBehavior.AllowGet);
        }

    }
}
