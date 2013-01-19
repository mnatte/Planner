using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data.SqlClient;
using Mnd.Planner.Data.Models;
using Mnd.Planner.Data.DataAccess;

namespace Mnd.Planner.Web.Controllers
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
            var rep = new ProjectRepository();
            var project = rep.GetProject(id);

            return this.Json(project, JsonRequestBehavior.AllowGet);
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
