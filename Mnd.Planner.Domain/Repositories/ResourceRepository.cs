using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.SqlClient;
using Mnd.Planner.Domain.Persistence;
using Mnd.Planner.Domain;
using Mnd.DataAccess;
using Mnd.Helpers;

namespace Mnd.Planner.Domain.Repositories
{
    public class ResourceRepository : SimpleCrudRepository<Resource, PersonInputModel>
    {
        protected override string TableName
        {
            get { return "Persons"; }
        }

        protected override void ConfigureDeleteCommand(SqlCommand cmd, int id)
        {
            cmd.CommandText = "sp_delete_person";
            cmd.Parameters.Add("@PersonId", System.Data.SqlDbType.Int).Value = id;
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
        }

        protected override string UpsertStoredProcedureName
        {
            get { return "sp_upsert_person"; }
        }

        protected override void AddUpsertCommandParameters(PersonInputModel model, System.Data.SqlClient.SqlCommand cmd)
        {
            cmd.Parameters.Add("@Id", System.Data.SqlDbType.Int).Value = model.Id;
            cmd.Parameters.Add("@FirstName", System.Data.SqlDbType.VarChar).Value = model.FirstName ?? "";
            cmd.Parameters.Add("@MiddleName", System.Data.SqlDbType.VarChar).Value = model.MiddleName ?? "";
            cmd.Parameters.Add("@LastName", System.Data.SqlDbType.VarChar).Value = model.LastName ?? "";
            cmd.Parameters.Add("@Initials", System.Data.SqlDbType.VarChar).Value = model.Initials ?? "";
            cmd.Parameters.Add("@Email", System.Data.SqlDbType.VarChar).Value = model.Email ?? "";
            cmd.Parameters.Add("@PhoneNumber", System.Data.SqlDbType.VarChar).Value = model.PhoneNumber ?? "";
            cmd.Parameters.Add("@FunctionId", System.Data.SqlDbType.Int).Value = model.FunctionId;
            cmd.Parameters.Add("@CompanyId", System.Data.SqlDbType.Int).Value = model.CompanyId;
            cmd.Parameters.Add("@HoursPerWeek", System.Data.SqlDbType.Int).Value = model.HoursPerWeek;
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
        }

        protected override Resource CreateItemByDbRow(System.Data.SqlClient.SqlDataReader reader)
        {
            var res = new Resource { Id = int.Parse(reader["Id"].ToString()), FirstName = reader["FirstName"].ToString(), MiddleName = reader["MiddleName"].ToString(), LastName = reader["LastName"].ToString(), Initials = reader["Initials"].ToString(), Email = reader["Email"].ToString(), PhoneNumber = reader["PhoneNumber"].ToString(), AvailableHoursPerWeek = int.Parse(reader["HoursPerWeek"].ToString()) };
            var absences = this.GetAbsences(res.Id);
            foreach (var abs in absences)
            {
                res.PeriodsAway.Add(abs);
            }
            var assignments = this.GetAssignments(res.Id);
            foreach (var ass in assignments)
            {
                res.Assignments.Add(ass);
            }
            return res;
        }

        // ResourceAssignment might be an entity under the Resource root so it should be an immutable collection. Maybe just lazy loaded? Or just retrieved as below?
        public List<ResourceAssignment> GetAssignments(int resourceId)
        {
            var conn = new SqlConnection(this.ConnectionString);

            var cmd = new SqlCommand("sp_get_resource_assignments", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("@ResourceId", System.Data.SqlDbType.Int).Value = resourceId;
            var lst = new List<ResourceAssignment>();

            using (conn)
            {
                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        var ass = new ResourceAssignment { Activity = new Activity { Id = int.Parse(reader["ActivityId"].ToString()), Title = reader["ActivityTitle"].ToString() }, Resource = new Resource { FirstName = reader["FirstName"].ToString(), MiddleName = reader["MiddleName"].ToString(), LastName = reader["LastName"].ToString() }, FocusFactor = double.Parse(reader["FocusFactor"].ToString()), Phase = new Phase { Title = reader["PhaseTitle"].ToString(), Id = int.Parse(reader["phaseid"].ToString()) }, EndDate = DateTime.Parse(reader["EndDate"].ToString()), StartDate = DateTime.Parse(reader["StartDate"].ToString()), Project = new Project { Title = reader["projecttitle"].ToString(), Id = int.Parse(reader["projectid"].ToString()) }, Milestone = new Milestone { Id = int.Parse(reader["mileStoneId"].ToString()), Date = DateTime.Parse(reader["MilestoneDate"].ToString()) }, Deliverable = new Deliverable { Id = int.Parse(reader["deliverableId"].ToString()), Title = reader["deliverableTitle"].ToString() } };
                        lst.Add(ass);
                    }
                }
            }
            return lst;
        }

        public List<Absence> GetAbsences(int resourceId)
        {
            var conn = new SqlConnection(this.ConnectionString);

            var cmd = new SqlCommand("sp_get_person_absences", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("@ResourceId", System.Data.SqlDbType.Int).Value = resourceId;
            var lst = new List<Absence>();

            using (conn)
            {
                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        var ass = new Absence { Id = int.Parse(reader["Id"].ToString()), Title = reader["Title"].ToString(), EndDate = DateTime.Parse(reader["EndDate"].ToString()), StartDate = DateTime.Parse(reader["StartDate"].ToString()) };
                        lst.Add(ass);
                    }
                }
            }
            return lst;
        }

        public Absence SaveAbsence(AbsenceInputModel obj)
        {
            var conn = new SqlConnection(this.ConnectionString);

            var cmd = new SqlCommand("sp_save_absence", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            // TODO: add params
            cmd.Parameters.Add("@Id", System.Data.SqlDbType.Int).Value = obj.Id;
            cmd.Parameters.Add("@PersonId", System.Data.SqlDbType.Int).Value = obj.PersonId;
            cmd.Parameters.Add("@StartDate", System.Data.SqlDbType.DateTime).Value = obj.StartDate.ToDateTimeFromDutchString();
            cmd.Parameters.Add("@EndDate", System.Data.SqlDbType.DateTime).Value = obj.EndDate.ToDateTimeFromDutchString();
            cmd.Parameters.Add("@Title", System.Data.SqlDbType.VarChar).Value = obj.Title;
            var abs = new Absence();

            var person = this.GetItemById(obj.PersonId);

            using (conn)
            {
                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    reader.Read();
                    abs = new Absence { Id = int.Parse(reader["Id"].ToString()), Title = reader["Title"].ToString(), EndDate = DateTime.Parse(reader["EndDate"].ToString()), StartDate = DateTime.Parse(reader["StartDate"].ToString()), Person = new ResourceSnapshot { FirstName = person.FirstName, LastName = person.LastName, MiddleName = person.MiddleName, Id = person.Id, Initials = person.Initials } };
                }
            }
            return abs;
        }

        public void SaveAssignment(int releaseId, int projectId, int personId, int milestoneId, int deliverableId, int activityId, DateTime startDate, DateTime endDate, double focusFactor)
        {
            var conn = new SqlConnection(this.ConnectionString);

            var cmd = new SqlCommand("sp_insert_resource_assignment", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            // TODO: add params
            cmd.Parameters.Add("@Id", System.Data.SqlDbType.Int).Value = 0; // not needed
            cmd.Parameters.Add("@ReleaseId", System.Data.SqlDbType.Int).Value = releaseId;
            cmd.Parameters.Add("@ProjectId", System.Data.SqlDbType.Int).Value = projectId;
            cmd.Parameters.Add("@PersonId", System.Data.SqlDbType.Int).Value = personId;
            cmd.Parameters.Add("@MilestoneId", System.Data.SqlDbType.Int).Value = milestoneId;
            cmd.Parameters.Add("@DeliverableId", System.Data.SqlDbType.Int).Value = deliverableId;
            cmd.Parameters.Add("@ActivityId", System.Data.SqlDbType.Int).Value = activityId;
            cmd.Parameters.Add("@FocusFactor", System.Data.SqlDbType.Decimal).Value = focusFactor;
            cmd.Parameters.Add("@StartDate", System.Data.SqlDbType.DateTime).Value = startDate;
            cmd.Parameters.Add("@EndDate", System.Data.SqlDbType.DateTime).Value = endDate;

            using (conn)
            {
                conn.Open();
                cmd.ExecuteNonQuery();
            }

        }

        public int DeleteAbsence(int id)
        {
            var conn = new SqlConnection(this.ConnectionString);
            var amt = 0;

            var cmd = new SqlCommand("sp_delete_absence", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            // TODO: add params
            cmd.Parameters.Add("@Id", System.Data.SqlDbType.Int).Value = id;
            var abs = new Absence();

            using (conn)
            {
                conn.Open();
                amt = cmd.ExecuteNonQuery();
            }
            return amt;
        }
    }
}