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
    public class SoftwareVersionRepository : SimpleCrudRepository<Models.SoftwareVersion, SoftwareVersion>
    {
        protected override string TableName
        {
            get { return "SoftwareVersions"; }
        }

        protected override string UpsertStoredProcedureName
        {
            get { throw new NotImplementedException(); }
        }

        protected override Models.SoftwareVersion CreateItemByDbRow(SqlDataReader reader)
        {
            var itm = new Models.SoftwareVersion { Id = int.Parse(reader["Id"].ToString()), Name = reader["Name"].ToString(), Description = reader["Description"].ToString(), Number = reader["VersionNumber"].ToString() };
            return itm;
        }

        protected override void AddUpsertCommandParameters(SoftwareVersion model, SqlCommand cmd)
        {
            throw new NotImplementedException();
        }
    }
}
