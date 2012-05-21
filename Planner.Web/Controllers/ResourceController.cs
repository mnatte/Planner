using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data.SqlClient;
using MvcApplication1.Models;

namespace MvcApplication1.Controllers
{
    public class ResourceController : Controller
    {
        //
        // GET: /Person/

        public ActionResult Index()
        {
            return View();
        }

        private ReleaseModels.Resource CreateResourceByDbRow(SqlDataReader reader)
        {
            return new ReleaseModels.Resource { Id = int.Parse(reader["Id"].ToString()), FirstName = reader["FirstName"].ToString(), MiddleName = reader["MiddleName"].ToString(), LastName = reader["LastName"].ToString(), Initials = reader["Initials"].ToString(), Email = reader["Email"].ToString(), PhoneNumber = reader["PhoneNumber"].ToString(), AvailableHoursPerWeek = int.Parse(reader["HoursPerWeek"].ToString()) };
        }

        public JsonResult GetResources()
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            var resources = new List<ReleaseModels.Resource>();

            using (conn)
            {
                conn.Open();

                // Release
                var cmd = new SqlCommand("Select * from Persons", conn);
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        // TODO: add Company and Function
                        var p = CreateResourceByDbRow(reader);   
                        resources.Add(p);
                    }
                }
            }
            return this.Json(resources, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetResourceById(int id)
        {
            // add MultipleActiveResultSets=true to enable nested datareaders
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            ReleaseModels.Resource p = null;

            using (conn)
            {
                conn.Open();

                // Release
                var cmd = new SqlCommand(string.Format("Select * from Persons where Id = {0}", id), conn);
                using (var reader = cmd.ExecuteReader())
                {
                    reader.Read();
                    // TODO: add Company and Function
                    p = CreateResourceByDbRow(reader);
                }
                conn.Close();
            }

            return this.Json(p, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult Save(PersonInputModel obj)
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            int newId = 0;
            try
            {
                using (conn)
                {
                    conn.Open();

                    var cmd = new SqlCommand("sp_upsert_person", conn);
                    cmd.Parameters.Add("@Id", System.Data.SqlDbType.Int).Value = obj.Id;
                    cmd.Parameters.Add("@FirstName", System.Data.SqlDbType.VarChar).Value = obj.FirstName ?? "";
                    cmd.Parameters.Add("@MiddleName", System.Data.SqlDbType.VarChar).Value = obj.MiddleName ?? "";
                    cmd.Parameters.Add("@LastName", System.Data.SqlDbType.VarChar).Value = obj.LastName ?? "";
                    cmd.Parameters.Add("@Initials", System.Data.SqlDbType.VarChar).Value = obj.Initials ?? "";
                    cmd.Parameters.Add("@Email", System.Data.SqlDbType.VarChar).Value = obj.Email ?? "";
                    cmd.Parameters.Add("@PhoneNumber", System.Data.SqlDbType.VarChar).Value = obj.PhoneNumber ?? "";
                    cmd.Parameters.Add("@FunctionId", System.Data.SqlDbType.Int).Value = obj.FunctionId;
                    cmd.Parameters.Add("@CompanyId", System.Data.SqlDbType.Int).Value = obj.CompanyId;
                    cmd.Parameters.Add("@HoursPerWeek", System.Data.SqlDbType.Int).Value = obj.HoursPerWeek;
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

                return GetResourceById(newId);
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
                    var cmdMain = new SqlCommand(string.Format("Delete from Persons where Id = {0}", id), conn);
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
