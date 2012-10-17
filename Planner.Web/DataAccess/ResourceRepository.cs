using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MvcApplication1.Models;
using System.Data.SqlClient;

namespace MvcApplication1.DataAccess
{
    public class ResourceRepository : SimpleCrudRepository<ReleaseModels.Resource, PersonInputModel>
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

        protected override ReleaseModels.Resource CreateItemByDbRow(System.Data.SqlClient.SqlDataReader reader)
        {
            var res = new ReleaseModels.Resource { Id = int.Parse(reader["Id"].ToString()), FirstName = reader["FirstName"].ToString(), MiddleName = reader["MiddleName"].ToString(), LastName = reader["LastName"].ToString(), Initials = reader["Initials"].ToString(), Email = reader["Email"].ToString(), PhoneNumber = reader["PhoneNumber"].ToString(), AvailableHoursPerWeek = int.Parse(reader["HoursPerWeek"].ToString()) };
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
        public List<ReleaseModels.ResourceAssignment> GetAssignments(int resourceId)
        {
            var conn = new SqlConnection(this.ConnectionString);

            var cmd = new SqlCommand("sp_get_resource_assignments", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("@ResourceId", System.Data.SqlDbType.Int).Value = resourceId;
            var lst = new List<ReleaseModels.ResourceAssignment>();

            using (conn)
            {
                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        var ass = new ReleaseModels.ResourceAssignment { Activity = new ReleaseModels.Activity { Id = int.Parse(reader["ActivityId"].ToString()), Title = reader["ActivityTitle"].ToString() }, Resource = new ReleaseModels.Resource { FirstName = reader["FirstName"].ToString(), MiddleName = reader["MiddleName"].ToString(), LastName = reader["LastName"].ToString() }, FocusFactor = double.Parse(reader["FocusFactor"].ToString()), Phase = new ReleaseModels.Phase { Title = reader["PhaseTitle"].ToString() }, EndDate = DateTime.Parse(reader["EndDate"].ToString()), StartDate = DateTime.Parse(reader["StartDate"].ToString()), Project = new ReleaseModels.Project { Title = reader["projecttitle"].ToString() } };
                        lst.Add(ass);
                    }
                }
            }
            return lst;
        }

        public List<ReleaseModels.Absence> GetAbsences(int resourceId)
        {
            var conn = new SqlConnection(this.ConnectionString);

            var cmd = new SqlCommand("sp_get_person_absences", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("@ResourceId", System.Data.SqlDbType.Int).Value = resourceId;
            var lst = new List<ReleaseModels.Absence>();

            using (conn)
            {
                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        var ass = new ReleaseModels.Absence { Title = reader["Title"].ToString(), Person = new ReleaseModels.Resource { FirstName = reader["FirstName"].ToString(), MiddleName = reader["MiddleName"].ToString(), LastName = reader["LastName"].ToString() }, EndDate = DateTime.Parse(reader["EndDate"].ToString()), StartDate = DateTime.Parse(reader["StartDate"].ToString()) };
                        lst.Add(ass);
                    }
                }
            }
            return lst;
        }
    }
}