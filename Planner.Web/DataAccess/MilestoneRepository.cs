using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MvcApplication1.Models;
using System.Data.SqlClient;

namespace MvcApplication1.DataAccess
{
    public class MilestoneRepository : SimpleCrudRepository<ReleaseModels.Milestone, MilestoneInputModel>
    {
        protected override string TableName
        {
            get { return "Milestones"; }
        }

        protected override string UpsertStoredProcedureName
        {
            get { return "sp_upsert_milestone"; }
        }

        protected override void AddUpsertCommandParameters(MilestoneInputModel model, System.Data.SqlClient.SqlCommand cmd)
        {
            cmd.Parameters.Add("@Id", System.Data.SqlDbType.Int).Value = model.Id;
            cmd.Parameters.Add("@Title", System.Data.SqlDbType.VarChar).Value = model.Title;
            cmd.Parameters.Add("@Description", System.Data.SqlDbType.VarChar).Value = model.Description ?? "";
            cmd.Parameters.Add("@Date", System.Data.SqlDbType.VarChar).Value = model.Date.ToDateTimeFromDutchString();
            cmd.Parameters.Add("@Time", System.Data.SqlDbType.VarChar).Value = model.Time ?? "";
            cmd.Parameters.Add("@PhaseId", System.Data.SqlDbType.Int).Value = model.PhaseId;
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
        }

        protected override ReleaseModels.Milestone CreateItemByDbRow(System.Data.SqlClient.SqlDataReader reader)
        {
            var item = new ReleaseModels.Milestone { Id = int.Parse(reader["MilestoneId"].ToString()), Title = reader["Title"].ToString(), Date = DateTime.Parse(reader["Date"].ToString()), Time = reader["Time"].ToString(), Description = reader["Description"].ToString() };
            
            var conn = new SqlConnection(this.ConnectionString);
            // Eager load Deliverables as being inside of the Milestone root

            using (conn)
            {
                conn.Open();

                // Prepare command
                var cmd = new SqlCommand("sp_get_deliverables_for_milestone", conn);
                cmd.Parameters.Add("@MilestoneId", System.Data.SqlDbType.Int).Value = item.Id;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                

                using (var delReader = cmd.ExecuteReader())
                {
                    while (delReader.Read())
                    {
                        var itm = new ReleaseModels.Deliverable { 
                            Id = int.Parse(delReader["DeliverableId"].ToString()), Title = delReader["Title"].ToString(), Description = delReader["Description"].ToString(), 
                            Location = delReader["Location"].ToString(), Format = delReader["Format"].ToString(), Owner = delReader["Owner"].ToString(), 
                            State = delReader["State"].ToString(), HoursRemaining = int.Parse(delReader["HoursRemaining"].ToString()), 
                            InitialHoursEstimate = int.Parse(delReader["InitialEstimate"].ToString()),
                            ActivitiesNeeded = new List<ReleaseModels.Activity>() // snapshot, empty activities array
                        };
                        item.Deliverables.Add(itm);
                    }
                }
            }

            return item;
        }

        public List<ReleaseModels.Milestone> GetMilestonesForRelease(ReleaseModels.Release release)
        {
            var conn = new SqlConnection(this.ConnectionString);

            var cmd = new SqlCommand("sp_get_phase_milestones", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("@PhaseId", System.Data.SqlDbType.Int).Value = release.Id;
            var lst = new List<ReleaseModels.Milestone>();

            using (conn)
            {
                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        var ms = this.CreateItemByDbRow(reader);
                        lst.Add(ms);
                    }
                }
            }
            return lst;
        }

    }
}