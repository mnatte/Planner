using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MvcApplication1.Models;
using System.Data.SqlClient;

namespace MvcApplication1.DataAccess
{
    public class ActivityRepository : SimpleCrudRepository<ReleaseModels.Activity, ActivityInputModel>
    {
        protected override string TableName
        {
            get { return "Activities"; }
        }

        protected override string UpsertStoredProcedureName
        {
            get { return "sp_upsert_activity"; }
        }

        protected override void ConfigureDeleteCommand(SqlCommand cmd, int id)
        {
            cmd.CommandText = "sp_delete_activity";
            cmd.Parameters.Add("@ActivityId", System.Data.SqlDbType.Int).Value = id;
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
        }

        protected override void AddUpsertCommandParameters(ActivityInputModel model, System.Data.SqlClient.SqlCommand cmd)
        {
            cmd.Parameters.Add("@Id", System.Data.SqlDbType.Int).Value = model.Id;
            cmd.Parameters.Add("@Title", System.Data.SqlDbType.VarChar).Value = model.Title ?? "";
            cmd.Parameters.Add("@Description", System.Data.SqlDbType.VarChar).Value = model.Description ?? "";
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
        }

        protected override ReleaseModels.Activity CreateItemByDbRow(System.Data.SqlClient.SqlDataReader reader)
        {
            var item = new ReleaseModels.Activity { Id = int.Parse(reader["Id"].ToString()), Title = reader["Title"].ToString(), Description = reader["Description"].ToString() };
            
            // Resource / Person is not a child of a Deliverable root aggregate; Persons exist without deliverables.
            // Probably we don't need this property
            //var ownerId = int.Parse(reader["OwnerId"].ToString());
            //item.Owner = null;

            return item;
        }

        // Activity is a member of the Deliverable entity. We use a "Deliverable snapshot" object to prevent loading the whole Deliverable graph
        public ReleaseModels.Deliverable GetDeliverableForActivity(ReleaseModels.Activity activity)
        {
            // mock, implement it as DeliverableRepository.
            return new ReleaseModels.Deliverable();
        }

        public List<ReleaseModels.Activity> GetDeliverableActivities(ReleaseModels.Deliverable deliverable)
        {
            var conn = new SqlConnection(this.ConnectionString);
            var items = new List<ReleaseModels.Activity>();

            using (conn)
            {
                conn.Open();

                // Prepare command
                var cmd = new SqlCommand();
                cmd.Connection = conn;
                cmd.CommandText = "get_activities_for_deliverable";
                cmd.Parameters.Add("@DeliverableId", System.Data.SqlDbType.Int).Value = deliverable.Id;
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
            return items;
        }
    }
}