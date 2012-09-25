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

        private ReleaseModels.Release _release { get; set; }

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
            var milestone = new ReleaseModels.Milestone { Id = int.Parse(reader["MilestoneId"].ToString()), Title = reader["Title"].ToString(), Date = DateTime.Parse(reader["Date"].ToString()), Time = reader["Time"].ToString(), Description = reader["Description"].ToString() };
            var projRep = new ProjectRepository();
            var actRep = new ActivityRepository();
            
            var conn = new SqlConnection(this.ConnectionString);
            // Eager load Deliverables as being inside of the Milestone root

            using (conn)
            {
                conn.Open();

                // Prepare command
                var cmd = new SqlCommand("sp_get_deliverables_for_milestone", conn);
                cmd.Parameters.Add("@MilestoneId", System.Data.SqlDbType.Int).Value = milestone.Id;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                

                using (var delReader = cmd.ExecuteReader())
                {
                    while (delReader.Read())
                    {
                        var deliv = new ReleaseModels.Deliverable { 
                            Id = int.Parse(delReader["DeliverableId"].ToString()), Title = delReader["Title"].ToString(), Description = delReader["Description"].ToString(), 
                            Location = delReader["Location"].ToString(), Format = delReader["Format"].ToString(), Owner = delReader["Owner"].ToString(), 
                            State = delReader["State"].ToString(), HoursRemaining = int.Parse(delReader["HoursRemaining"].ToString()), 
                            InitialHoursEstimate = int.Parse(delReader["InitialEstimate"].ToString()),
                            // ActivitiesNeeded => snapshot, empty activities array
                        };

                        var cmdAct = new SqlCommand("get_activities_for_deliverable", conn);
                        cmdAct.Parameters.Add("@DeliverableId", System.Data.SqlDbType.Int).Value = deliv.Id;
                        cmdAct.CommandType = System.Data.CommandType.StoredProcedure;
                        using (var actReader = cmdAct.ExecuteReader())
                        {
                            while(actReader.Read())
                            {
                                deliv.ConfiguredActivities.Add(new ReleaseModels.Activity { Id = int.Parse(actReader["Id"].ToString()), Title = actReader["Title"].ToString(), Description = actReader["Description"].ToString() }); 
                            }
                        }

                        foreach (var proj in _release.Projects)
                        {
                            deliv.Scope.Add(projRep.GetProjectWithWorkload(proj.Id, _release.Id, milestone.Id, deliv.Id));
                        }

                        milestone.Deliverables.Add(deliv);
                    }
                }
            }

            return milestone;
        }

        public List<ReleaseModels.Milestone> GetMilestonesForRelease(ReleaseModels.Release release)
        {
            _release = release;

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