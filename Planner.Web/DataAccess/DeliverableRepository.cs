using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MvcApplication1.Models;

namespace MvcApplication1.DataAccess
{
    public class DeliverableRepository : SimpleCrudRepository<ReleaseModels.Deliverable, DeliverableInputModel>
    {
        protected override string TableName
        {
            get { return "Deliverables"; }
        }

        protected override string UpsertStoredProcedureName
        {
            get { return "sp_upsert_deliverable"; }
        }

        protected override void AddUpsertCommandParameters(DeliverableInputModel model, System.Data.SqlClient.SqlCommand cmd)
        {
            cmd.Parameters.Add("@Id", System.Data.SqlDbType.Int).Value = model.Id;
            cmd.Parameters.Add("@Title", System.Data.SqlDbType.VarChar).Value = model.Title ?? "";
            cmd.Parameters.Add("@Description", System.Data.SqlDbType.VarChar).Value = model.Description ?? "";
            cmd.Parameters.Add("@Format", System.Data.SqlDbType.VarChar).Value = model.Format ?? "";
            cmd.Parameters.Add("@Location", System.Data.SqlDbType.VarChar).Value = model.Location ?? "";
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
        }

        protected override ReleaseModels.Deliverable CreateItemByDbRow(System.Data.SqlClient.SqlDataReader reader)
        {
            var item = new ReleaseModels.Deliverable { Id = int.Parse(reader["Id"].ToString()), Title = reader["Title"].ToString(), Description = reader["Description"].ToString(), Location = reader["Location"].ToString(), Format = reader["Format"].ToString() };
            
            // Resource / Person is not a child of a Deliverable root aggregate; Persons exist without deliverables.
            // Probably we don't need this property
            //var ownerId = int.Parse(reader["OwnerId"].ToString());
            //item.Owner = null;

            return item;
        }
    }
}