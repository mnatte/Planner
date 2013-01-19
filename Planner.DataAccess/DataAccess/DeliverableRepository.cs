using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.SqlClient;
using Mnd.Planner.Data.DataAccess;
using Mnd.Planner.Data.Models;

namespace Planne.Data.DataAccess
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
            var item = new ReleaseModels.Deliverable
            {
                Id = int.Parse(reader["Id"].ToString()),
                Title = reader["Title"].ToString(),
                Description = reader["Description"].ToString(),
                Location = reader["Location"].ToString(),
                Format = reader["Format"].ToString(),
            };

            var actRepository = new ActivityRepository();
            var activities = actRepository.GetDeliverableActivities(item);
            foreach(var act in activities)
                item.ConfiguredActivities.Add(act);

            return item;
        }

        protected override void AddChildCollection(DeliverableInputModel obj, int parentId)
        {
            if (obj.Activities != null && obj.Activities.Count > 0)
            {
                using (var conn = new SqlConnection(this.ConnectionString))
                {
                    conn.Open();
                    using (var cmdInsertDeliverableActivity = new SqlCommand("sp_insert_deliverableactivity", conn))
                    {
                        cmdInsertDeliverableActivity.Parameters.Add("@DeliverableId", System.Data.SqlDbType.Int).Value = parentId;
                        cmdInsertDeliverableActivity.Parameters.Add("@ActivityId", System.Data.SqlDbType.Int).Value = 0;
                        cmdInsertDeliverableActivity.CommandType = System.Data.CommandType.StoredProcedure;

                        foreach (var itm in obj.Activities)
                        {
                            cmdInsertDeliverableActivity.Parameters["@ActivityId"].Value = itm.Id;
                            cmdInsertDeliverableActivity.ExecuteNonQuery();
                        }
                    }
                }
            }
        }

        protected override void ConfigureDeleteCommand(SqlCommand cmd, int id)
        {
            cmd.Parameters.Add("@DeliverableId", System.Data.SqlDbType.Int).Value = id;
            cmd.CommandText = "sp_delete_deliverable";
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
        }

        // Deliverable is a member of the Milestone aggregate root. We use a "Milestone snapshot" object to prevent loading the whole Milestone graph
        public ReleaseModels.Milestone GetMilestoneForDeliverable(ReleaseModels.Deliverable deliverable)
        {
            // mock, implement it as MilestonreRepository.
            return new ReleaseModels.Milestone();
        }
    }
}