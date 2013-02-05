using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data.SqlClient;
using Mnd.Planner.Domain.Persistence;
using Mnd.Planner.Domain.Repositories;
using Mnd.Helpers;
using Mnd.Planner.Domain;
using Mnd.Mvc.Rest;

namespace Mnd.Planner.Web.Controllers
{
    public class ResourceAssignmentController : BaseCrudController<ResourceAssignment, ResourceAssignmentInputModel>
    {
        protected ResourceRepository ResourceRepository { get; set; }
        // TODO: refactor to ResourceAssignment being a child of the Resource aggregate root
        public ResourceAssignmentController()
            : base(null)
        {
            this.ResourceRepository = new ResourceRepository();
        }

        //protected override string ConnectionString
        //{
        //    get { return "Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true"; }
        //}

        //protected override void ConfigureUpsertCommand(ResourceAssignmentInputModel model, System.Data.SqlClient.SqlCommand cmd)
        //{
        //    cmd.CommandText = "sp_insert_resource_assignment";
        //    cmd.Parameters.Add("@Id", System.Data.SqlDbType.Int).Value = model.Id;
        //    cmd.Parameters.Add("@ReleaseId", System.Data.SqlDbType.Int).Value = model.PhaseId;
        //    cmd.Parameters.Add("@ProjectId", System.Data.SqlDbType.Int).Value = model.ProjectId;
        //    cmd.Parameters.Add("@PersonId", System.Data.SqlDbType.Int).Value = model.ResourceId;
        //    cmd.Parameters.Add("@FocusFactor", System.Data.SqlDbType.Decimal).Value = model.FocusFactor;
        //    cmd.CommandType = System.Data.CommandType.StoredProcedure;
        //}


        [HttpPost]
        public JsonResult SaveAssignment(ResourceAssignmentInputModel model)
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            int newId = 0;
            Resource resource;
            try
            {
                using (conn)
                {
                    conn.Open();

                    // DDD: We don't need to find assignments by Id, we can simply delete all items and add new ones. No history needed.
                    // Therefore we might say that Assignment is an entity under the Release root since it is accessed as an IMMUTABLE collection: no updates, just new instances.
                    var delStatement = string.Format("delete from ReleaseResources where ReleaseId = {0} and ProjectId = {1} and PersonId = {2} and ActivityId = {3} and MilestoneId = {4} and DeliverableId = {5}", model.PhaseId, model.ProjectId, model.ResourceId, model.ActivityId, model.MilestoneId, model.DeliverableId);
                    var delCmd = new SqlCommand(delStatement, conn);
                    delCmd.ExecuteNonQuery();

                    var cmd = new SqlCommand("sp_insert_resource_assignment", conn);
                    cmd.Parameters.Add("@Id", System.Data.SqlDbType.Int).Value = 0;
                    cmd.Parameters.Add("@ReleaseId", System.Data.SqlDbType.Int).Value = model.PhaseId;
                    cmd.Parameters.Add("@ProjectId", System.Data.SqlDbType.Int).Value = model.ProjectId;
                    cmd.Parameters.Add("@PersonId", System.Data.SqlDbType.Int).Value = model.ResourceId;
                    cmd.Parameters.Add("@MilestoneId", System.Data.SqlDbType.Int).Value = model.MilestoneId;
                    cmd.Parameters.Add("@DeliverableId", System.Data.SqlDbType.Int).Value = model.DeliverableId;
                    cmd.Parameters.Add("@FocusFactor", System.Data.SqlDbType.Decimal).Value = model.FocusFactor;
                    cmd.Parameters.Add("@StartDate", System.Data.SqlDbType.DateTime).Value = model.StartDate.ToDateTimeFromDutchString();
                    cmd.Parameters.Add("@EndDate", System.Data.SqlDbType.DateTime).Value = model.EndDate.ToDateTimeFromDutchString();
                    cmd.Parameters.Add("@ActivityId", System.Data.SqlDbType.Int).Value = model.ActivityId;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    newId= int.Parse(cmd.ExecuteScalar().ToString());
                    
                    // return entire resource so we have all assignments and absences
                    var resRep = new ResourceRepository();
                    resource = resRep.GetItemById(model.ResourceId);
                }
            }
            catch (Exception ex)
            {
                return this.Json(string.Format("error: {0}", ex.Message), JsonRequestBehavior.AllowGet);
            }
            return this.Json(resource, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult DeleteAssignment(ResourceAssignmentInputModel model)
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            Resource resource;
            try
            {
                using (conn)
                {
                    conn.Open();

                    // DDD: We don't need to find assignments by Id, we can simply delete all items and add new ones. No history needed.
                    // Therefore we might say that Assignment is an entity under the Release root since it is accessed as an IMMUTABLE collection: no updates, just new instances.
                    var delStatement = string.Format("delete from ReleaseResources where ReleaseId = {0} and ProjectId = {1} and PersonId = {2} and ActivityId = {3} and MilestoneId = {4} and DeliverableId = {5}", model.PhaseId, model.ProjectId, model.ResourceId, model.ActivityId, model.MilestoneId, model.DeliverableId);
                    var delCmd = new SqlCommand(delStatement, conn);
                    delCmd.ExecuteNonQuery();

                    // return entire resource so we have all assignments and absences
                    var resRep = new ResourceRepository();
                    resource = resRep.GetItemById(model.ResourceId);
                }
            }
            catch (Exception ex)
            {
                return this.Json(string.Format("error: {0}", ex.Message), JsonRequestBehavior.AllowGet);
            }
            return this.Json(resource, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult SaveAssignments(ReleaseAssignmentsInputModel model)
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            int amount = 0;
            try
            {
                using (conn)
                {
                    conn.Open();

                    // DDD: We don't need to find assignments by Id, we can simply delete all items and add new ones. No history needed.
                    // Therefore we might say that Assignment is an entity under the Release root since it is accessed as an IMMUTABLE collection: no updates, just new instances.
                    var delCmd = new SqlCommand(string.Format("delete from ReleaseResources where ReleaseId = {0} and ProjectId = {1}", model.PhaseId, model.ProjectId), conn);
                    delCmd.ExecuteNonQuery();

                    var cmd = new SqlCommand("sp_insert_resource_assignment", conn);
                    cmd.Parameters.Add("@Id", System.Data.SqlDbType.Int).Value = 0;
                    cmd.Parameters.Add("@ReleaseId", System.Data.SqlDbType.Int).Value = model.PhaseId;
                    cmd.Parameters.Add("@ProjectId", System.Data.SqlDbType.Int).Value = model.ProjectId;
                    cmd.Parameters.Add("@PersonId", System.Data.SqlDbType.Int).Value = 0;
                    cmd.Parameters.Add("@MilestoneId", System.Data.SqlDbType.Int).Value = 0;
                    cmd.Parameters.Add("@DeliverableId", System.Data.SqlDbType.Int).Value = 0;
                    cmd.Parameters.Add("@FocusFactor", System.Data.SqlDbType.Decimal).Value = 0;
                    cmd.Parameters.Add("@StartDate", System.Data.SqlDbType.DateTime).Value = 0;
                    cmd.Parameters.Add("@EndDate", System.Data.SqlDbType.DateTime).Value = 0;
                    cmd.Parameters.Add("@ActivityId", System.Data.SqlDbType.Int).Value = 0;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    foreach (var ass in model.Assignments)
                    {
                        cmd.Parameters["@Id"].Value = ass.Id;
                        cmd.Parameters["@PersonId"].Value = ass.ResourceId;
                        cmd.Parameters["@MilestoneId"].Value = ass.MilestoneId;
                        cmd.Parameters["@DeliverableId"].Value = ass.DeliverableId;
                        cmd.Parameters["@FocusFactor"].Value = ass.FocusFactor;
                        cmd.Parameters["@StartDate"].Value = ass.StartDate.ToDateTimeFromDutchString();
                        cmd.Parameters["@EndDate"].Value = ass.EndDate.ToDateTimeFromDutchString();
                        cmd.Parameters["@ActivityId"].Value = ass.ActivityId;
                        amount += cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                return this.Json(string.Format("error: {0}", ex.Message), JsonRequestBehavior.AllowGet);
            }
            return this.Json(string.Format("{0} assignments saved", amount), JsonRequestBehavior.AllowGet); 
        }

        //protected override void ConfigureSelectAllCommand(System.Data.SqlClient.SqlCommand cmd)
        //{
        //    cmd.CommandText = "sp_get_release_resources";
        //    cmd.CommandType = System.Data.CommandType.StoredProcedure;
        //}

        //protected override void ConfigureSelectItemCommand(System.Data.SqlClient.SqlCommand cmd, int id)
        //{
        //    cmd.CommandText = "sp_get_release_resource";
        //    cmd.Parameters.Add("@Id", System.Data.SqlDbType.Int).Value = id;
        //    cmd.CommandType = System.Data.CommandType.StoredProcedure;
        //}

        //protected override void ConfigureDeleteCommand(System.Data.SqlClient.SqlCommand cmd, int id)
        //{
        //    cmd.CommandText = string.Format("delete from ReleaseResources where id = {0}", id);
        //}

        protected ResourceAssignment CreateItemByDbRow(System.Data.SqlClient.SqlDataReader reader)
        {
            var resRep = new ResourceRepository();
            var resource = new Resource { Id = int.Parse(reader["PersonId"].ToString()), FirstName = reader["FirstName"].ToString(), MiddleName = reader["MiddleName"].ToString(), LastName = reader["LastName"].ToString() };
            resource.PeriodsAway.AddRange(resRep.GetAbsences(resource.Id));
            return new ResourceAssignment
            {
                Id = int.Parse(reader["Id"].ToString()),
                FocusFactor = double.Parse(reader["FocusFactor"].ToString()),
                Phase = new Phase { Id = int.Parse(reader["PhaseId"].ToString()), Title = reader["phasetitle"].ToString() },
                Resource = resource,
                Project = new Project { Id = int.Parse(reader["ProjectId"].ToString()), Title = reader["ProjectTitle"].ToString() },
                //TODO: fill ActivitiesNeeded
                Deliverable = new Deliverable { Id = int.Parse(reader["DeliverableId"].ToString()), Title = reader["DeliverableTitle"].ToString() },
                Milestone = new Milestone { Id = int.Parse(reader["MilestoneId"].ToString()), Title = reader["MilestoneTitle"].ToString() },
                StartDate = DateTime.Parse(reader["StartDate"].ToString()),
                EndDate = DateTime.Parse(reader["EndDate"].ToString()),
                Activity = new Activity { Id = int.Parse(reader["ActivityId"].ToString()), Title = reader["ActivityTitle"].ToString() }
            };
        }

        [HttpGet]
        public JsonResult GetAssignmentsByPhaseIdAndProjectId(int phaseId, int projectId)
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            var items = new List<ResourceAssignment>();

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

        [HttpGet]
        public JsonResult GetAssignmentsByPhaseIdAndProjectIdAndMilestoneIdAndDeliverableId(int phaseId, int projectId, int milestoneId, int deliverableId)
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            var items = new List<ResourceAssignment>();

            using (conn)
            {
                conn.Open();

                // Prepare command
                var cmd = new SqlCommand();
                cmd.Connection = conn;
                cmd.CommandText = "get_release_deliverable_assignments";
                cmd.Parameters.Add("@PhaseId", System.Data.SqlDbType.Int).Value = phaseId;
                cmd.Parameters.Add("@ProjectId", System.Data.SqlDbType.Int).Value = projectId;
                cmd.Parameters.Add("@MilestoneId", System.Data.SqlDbType.Int).Value = milestoneId;
                cmd.Parameters.Add("@DeliverableId", System.Data.SqlDbType.Int).Value = deliverableId;
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

        [HttpGet]
        public JsonResult GetAssignmentsByPhaseId(int phaseId)
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            var items = new List<ResourceAssignment>();

            using (conn)
            {
                conn.Open();

                // Prepare command
                var cmd = new SqlCommand();
                cmd.Connection = conn;
                cmd.CommandText = "sp_get_release_deliverable_assignments";
                cmd.Parameters.Add("@PhaseId", System.Data.SqlDbType.Int).Value = phaseId;
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

        [HttpGet]
        public JsonResult GetAssignmentsByResourceId(int resourceId)
        {
            var lst = this.ResourceRepository.GetAssignments(resourceId);
            return this.Json(lst, JsonRequestBehavior.AllowGet);
        }
    }
}