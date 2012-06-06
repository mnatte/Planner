﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MvcApplication1.Models;
using System.Web.Mvc;
using System.Data.SqlClient;

namespace MvcApplication1.Controllers
{
    public class ResourceAssignmentController : BaseCrudController<ReleaseModels.ResourceAssignment, ResourceAssignmentInputModel>
    {
        protected override string ConnectionString
        {
            get { return "Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true"; }
        }

        protected override void ConfigureUpsertCommand(ResourceAssignmentInputModel model, System.Data.SqlClient.SqlCommand cmd)
        {
            cmd.CommandText = "sp_upsert_resource_assignment";
            cmd.Parameters.Add("@Id", System.Data.SqlDbType.Int).Value = model.Id;
            cmd.Parameters.Add("@ReleaseId", System.Data.SqlDbType.Int).Value = model.PhaseId;
            cmd.Parameters.Add("@ProjectId", System.Data.SqlDbType.Int).Value = model.ProjectId;
            cmd.Parameters.Add("@PersonId", System.Data.SqlDbType.Int).Value = model.ResourceId;
            cmd.Parameters.Add("@FocusFactor", System.Data.SqlDbType.Decimal).Value = model.FocusFactor;
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
        }

        [HttpPost]
        public JsonResult SaveAssignments(ReleaseAssignmentsInputModel model)
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            int newId = 0;
            int amount = 0;
            try
            {
                using (conn)
                {
                    conn.Open();
                    var cmd = new SqlCommand("sp_upsert_resource_assignment", conn);
                    cmd.Parameters.Add("@Id", System.Data.SqlDbType.Int).Value = 0;
                    cmd.Parameters.Add("@ReleaseId", System.Data.SqlDbType.Int).Value = model.PhaseId;
                    cmd.Parameters.Add("@ProjectId", System.Data.SqlDbType.Int).Value = model.ProjectId;
                    cmd.Parameters.Add("@PersonId", System.Data.SqlDbType.Int).Value = 0;
                    cmd.Parameters.Add("@FocusFactor", System.Data.SqlDbType.Decimal).Value = 9;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    foreach (var ass in model.Assignments)
                    {
                        cmd.Parameters["@Id"].Value = ass.Id;
                        cmd.Parameters["@PersonId"].Value = ass.ResourceId;
                        cmd.Parameters["@FocusFactor"].Value = ass.FocusFactor;
                        amount += cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
            }
            return this.Json(string.Format("{0} rows deleted", amount), JsonRequestBehavior.AllowGet); 
        }

        protected override void ConfigureSelectAllCommand(System.Data.SqlClient.SqlCommand cmd)
        {
            cmd.CommandText = "sp_get_release_resources";
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
        }

        protected override void ConfigureSelectItemCommand(System.Data.SqlClient.SqlCommand cmd, int id)
        {
            cmd.CommandText = "sp_get_release_resource";
            cmd.Parameters.Add("@Id", System.Data.SqlDbType.Int).Value = id;
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
        }

        protected override void ConfigureDeleteCommand(System.Data.SqlClient.SqlCommand cmd, int id)
        {
            cmd.CommandText = string.Format("delete from ReleaseResources where id = {0}", id);
        }

        protected override ReleaseModels.ResourceAssignment CreateItemByDbRow(System.Data.SqlClient.SqlDataReader reader)
        {
            return new ReleaseModels.ResourceAssignment
            {
                Id = int.Parse(reader["Id"].ToString()),
                FocusFactor = double.Parse(reader["FocusFactor"].ToString()),
                Phase = new ReleaseModels.Phase { Id = int.Parse(reader["PhaseId"].ToString()), Title = reader["phasetitle"].ToString() },
                Resource = new ReleaseModels.Resource { Id = int.Parse(reader["PersonId"].ToString()), FirstName = reader["FirstName"].ToString(), MiddleName = reader["MiddleName"].ToString(), LastName = reader["LastName"].ToString() },
                Project = new ReleaseModels.Project { Id = int.Parse(reader["ProjectId"].ToString()), Title = reader["ProjectTitle"].ToString() }
            };
        }

        [HttpGet]
        public JsonResult GetAssignmentsByPhaseIdAndProjectId(int phaseId, int projectId)
        {
            var conn = new SqlConnection(this.ConnectionString);
            var items = new List<ReleaseModels.ResourceAssignment>();

            using (conn)
            {
                conn.Open();

                // Prepare command
                var cmd = new SqlCommand();
                cmd.Connection = conn;
                cmd.CommandText = "sp_get_assignments";
                cmd.Parameters.Add("@PhaseId", System.Data.SqlDbType.Int).Value = phaseId;
                cmd.Parameters.Add("@ProjectId", System.Data.SqlDbType.Int).Value = projectId;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        var itm = this.CreateItemByDbRow(reader);
                        items.Add(itm);
                    }
                }
            }
            return this.Json(items, JsonRequestBehavior.AllowGet);
        }
    }
}