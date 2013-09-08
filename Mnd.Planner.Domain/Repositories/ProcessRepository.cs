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
    public class ProcessRepository : SimpleCrudRepository<Process, ProcessInputModel>
    {
        protected override string TableName
        {
            get { return "Processes"; }
        }

        protected override string UpsertStoredProcedureName
        {
            get { return "sp_upsert_process"; }
        }

        protected override Process CreateItemByDbRow(SqlDataReader reader)
        {
            var itm = new Process { Id = int.Parse(reader["Id"].ToString()), Title = reader["Title"].ToString(), Description = reader["Description"].ToString(), ShortName = reader["ShortName"].ToString(), Type = reader["Type"].ToString() };
            return itm;
        }

        protected override void AddUpsertCommandParameters(ProcessInputModel model, SqlCommand cmd)
        {
            cmd.Parameters.Add("@Id", System.Data.SqlDbType.Int).Value = model.Id;
            cmd.Parameters.Add("@Title", System.Data.SqlDbType.VarChar).Value = model.Title ?? "";
            cmd.Parameters.Add("@Descr", System.Data.SqlDbType.VarChar).Value = model.Description ?? "";
            cmd.Parameters.Add("@ShortName", System.Data.SqlDbType.VarChar).Value = model.ShortName ?? "";
            cmd.Parameters.Add("@Type", System.Data.SqlDbType.VarChar).Value = model.Type ?? "";
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
        }

    }
}
