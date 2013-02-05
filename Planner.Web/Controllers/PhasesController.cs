using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Mnd.Planner.Web.Models;
using System.Data.SqlClient;
using Mnd.Planner.Domain;
using Mnd.Planner.Domain.Persistence;
using Mnd.Planner.Domain.Repositories;

namespace Mnd.Planner.Web.Controllers
{
    public class PhasesController : Controller
    {
        //
        // GET: /Release/

        public ActionResult Index()
        {
            return View();
        }
        
        public JsonResult GetPhases()
        {
            // add MultipleActiveResultSets=true to enable nested datareaders
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            Periods periods = new Periods();

            using (conn)
            {
                conn.Open();

                var cmd = new SqlCommand("Select * from Phases where ISNULL(ParentId, 0) = 0", conn);
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        var release = new Release { EndDate = DateTime.Parse(reader["EndDate"].ToString()), StartDate = DateTime.Parse(reader["StartDate"].ToString()), Title = reader["Title"].ToString() };
                        var cmd2 = new SqlCommand(string.Format("Select * from Phases where ParentId = {0}", reader["Id"].ToString()), conn);
                        using (var reader2 = cmd2.ExecuteReader())
                        {
                            while (reader2.Read())
                            {
                                release.Phases.Add(new Phase { EndDate = DateTime.Parse(reader2["EndDate"].ToString()), StartDate = DateTime.Parse(reader2["StartDate"].ToString()), Title = reader2["Title"].ToString() });
                            }
                        }
                        periods.Releases.Add(release);
                    }
                }

                var cmd3 = new SqlCommand("Select * from Absences a inner join Persons p on a.PersonId = p.Id", conn);
                using (var reader3 = cmd3.ExecuteReader())
                {
                    while (reader3.Read())
                    {
                        periods.Absences.Add(new Absence { EndDate = DateTime.Parse(reader3["EndDate"].ToString()), StartDate = DateTime.Parse(reader3["StartDate"].ToString()), Title = string.Format("{0} - {1}", reader3["Initials"].ToString(), reader3["Title"].ToString()), Person = new Resource { Initials = reader3["Initials"].ToString() } });
                    }
                }

                conn.Close();
            }

            return this.Json(periods, JsonRequestBehavior.AllowGet);
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
