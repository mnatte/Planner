using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data.SqlClient;
using MvcApplication1.Models;

namespace MvcApplication1.Controllers
{
    public class MilestoneController : Controller
    {
        //
        // GET: /Projects/

        public ActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public JsonResult Save(MilestoneInputModel obj)
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            int newId = 0;
            try
            {
                using (conn)
                {
                    conn.Open();

                    var cmd = new SqlCommand("sp_upsert_milestone", conn);
                    cmd.Parameters.Add("@Id", System.Data.SqlDbType.Int).Value = obj.Id;
                    cmd.Parameters.Add("@Title", System.Data.SqlDbType.VarChar).Value = obj.Title;
                    cmd.Parameters.Add("@Description", System.Data.SqlDbType.VarChar).Value = obj.Description ?? "";
                    cmd.Parameters.Add("@Date", System.Data.SqlDbType.VarChar).Value = obj.Date.ToDateTimeFromDutchString();
                    cmd.Parameters.Add("@Time", System.Data.SqlDbType.VarChar).Value = obj.Time ?? "";
                    cmd.Parameters.Add("@PhaseId", System.Data.SqlDbType.Int).Value = obj.PhaseId;
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

        // DELETE: /Milestone/Delete/5
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
                    var cmdMain = new SqlCommand(string.Format("Delete from Milestones where Id = {0}", id), conn);
                    amount += cmdMain.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                throw;
            }
            return this.Json(string.Format("{0} rows deleted", amount), JsonRequestBehavior.AllowGet);
        }

        //public JsonResult GetProjects()
        //{
        //    var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
        //    var projects = new List<ReleaseModels.Project>();

        //    using (conn)
        //    {
        //        conn.Open();

        //        // Release
        //        var cmd = new SqlCommand("Select * from Projects", conn);
        //        using (var reader = cmd.ExecuteReader())
        //        {
        //            while (reader.Read())
        //            {
        //                var p = new ReleaseModels.Project { Id = int.Parse(reader["Id"].ToString()), Title = reader["Title"].ToString(), Description = reader["Description"].ToString(), ShortName = reader["ShortName"].ToString(), TfsDevBranch = reader["TfsDevBranch"].ToString(), TfsIterationPath = reader["TfsIterationPath"].ToString() };
        //                projects.Add(p);
        //            }
        //        }
        //    }
        //    return this.Json(projects, JsonRequestBehavior.AllowGet);
        //}

        public JsonResult GetMilestoneById(int id)
        {
            // add MultipleActiveResultSets=true to enable nested datareaders
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            ReleaseModels.Milestone m = null;

            using (conn)
            {
                conn.Open();

                // Release
                var cmd = new SqlCommand(string.Format("Select * from Milestones where Id = {0}", id), conn);
                using (var reader = cmd.ExecuteReader())
                {
                    reader.Read();
                    m = new ReleaseModels.Milestone { Id = int.Parse(reader["Id"].ToString()), Title = reader["Title"].ToString(), Description = reader["Description"].ToString(), Date = DateTime.Parse(reader["ShortName"].ToString()), Time = reader["Time"].ToString(), TfsIterationPath = reader["TfsIterationPath"].ToString() };
                }

                conn.Close();
            }

            return this.Json(p, JsonRequestBehavior.AllowGet);
        }

    }
}
