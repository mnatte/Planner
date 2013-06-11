using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using Mnd.DataAccess;
using Mnd.Planner.Domain.Persistence;
using Mnd.Planner.Domain.Models;
using Mnd.Helpers;

namespace Mnd.Planner.Domain.Repositories
{
    public class EnvironmentRepository : SimpleCrudRepository<Models.Environment, EnvironmentInputModel>
    {
        protected override string TableName
        {
            get { return "Environments"; }
        }

        protected override string UpsertStoredProcedureName
        {
            get { return "sp_upsert_environment"; }
        }

        protected override Models.Environment CreateItemByDbRow(SqlDataReader reader)
        {
            var itm = new Models.Environment { Id = int.Parse(reader["Id"].ToString()), Name = reader["Name"].ToString(), Description = reader["Description"].ToString(), Location = reader["Location"].ToString(), ShortName = reader["ShortName"].ToString() };
            return itm;
        }

        protected override void AddUpsertCommandParameters(EnvironmentInputModel model, SqlCommand cmd)
        {
            cmd.Parameters.Add("@Id", System.Data.SqlDbType.Int).Value = model.Id;
            cmd.Parameters.Add("@Name", System.Data.SqlDbType.VarChar).Value = model.Name ?? "";
            cmd.Parameters.Add("@Description", System.Data.SqlDbType.VarChar).Value = model.Description ?? "";
            cmd.Parameters.Add("@Location", System.Data.SqlDbType.VarChar).Value = model.Location ?? "";
            cmd.Parameters.Add("@ShortName", System.Data.SqlDbType.VarChar).Value = model.ShortName ?? "";
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
        }

        public List<EnvironmentAssignment> GetAssignments(int environmentId)
        {
            var lst = new List<EnvironmentAssignment>();

            var conn = new SqlConnection(this.ConnectionString);
            var cmd = new SqlCommand("sp_get_environment_assignments", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("@EnvironmentId", System.Data.SqlDbType.Int).Value = environmentId;

            using (conn)
            {
                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        var ass = new EnvironmentAssignment { Environment = new Models.Environment { Location = reader["Location"].ToString(), Name = reader["EnvironmentName"].ToString() }, Version = new SoftwareVersion { Number = reader["VersionNumber"].ToString(), Description = reader["Description"].ToString() }, Phase = new Phase { Title = reader["PhaseTitle"].ToString(), EndDate = DateTime.Parse(reader["EndDate"].ToString()), StartDate = DateTime.Parse(reader["StartDate"].ToString()) } };
                        lst.Add(ass);
                    }
                }
            }
            return lst;

        }
    }
}
