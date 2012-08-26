using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MvcApplication1.Models;

namespace MvcApplication1.DataAccess
{
    public class ResourceRepository : SimpleCrudRepository<ReleaseModels.Resource, PersonInputModel>
    {
        protected override string TableName
        {
            get { return "Persons"; }
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
            return new ReleaseModels.Resource { Id = int.Parse(reader["Id"].ToString()), FirstName = reader["FirstName"].ToString(), MiddleName = reader["MiddleName"].ToString(), LastName = reader["LastName"].ToString(), Initials = reader["Initials"].ToString(), Email = reader["Email"].ToString(), PhoneNumber = reader["PhoneNumber"].ToString(), AvailableHoursPerWeek = int.Parse(reader["HoursPerWeek"].ToString()) };
        }
    }
}