using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.SqlClient;
using Mnd.Planner.Domain.Persistence;
using Mnd.Planner.Domain;
using Mnd.DataAccess;
using Mnd.Helpers;

namespace Mnd.Planner.Domain.Repositories
{
    public class MilestoneRepository : SimpleCrudRepository<Milestone, MilestoneInputModel>
    {
        protected override string TableName
        {
            get { return "Milestones"; }
        }

        protected override void ConfigureSelectItemCommand(SqlCommand cmd, int id)
        {
            cmd.CommandText = "sp_get_milestone_by_id";
            cmd.Parameters.Add("@Id", System.Data.SqlDbType.Int).Value = id;
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
        }

        protected override string UpsertStoredProcedureName
        {
            get { return "sp_upsert_milestone"; }
        }

        //private ReleaseModels.Release _release { get; set; }

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

        protected override Milestone CreateItemByDbRow(System.Data.SqlClient.SqlDataReader reader)
        {
            var milestone = new Milestone { Id = int.Parse(reader["MilestoneId"].ToString()), Title = reader["Title"].ToString(), Date = DateTime.Parse(reader["Date"].ToString()), Time = reader["Time"].ToString(), Description = reader["Description"].ToString() };
            var configuredDeliverables = this.GetConfiguredDeliverables(milestone);
            foreach(var del in configuredDeliverables)
                milestone.Deliverables.Add(del);

            return milestone;
        }

        protected Deliverable AddDeliverableStatus(Deliverable deliverable, Milestone milestone, Release release)
        {
            var projRep = new ProjectRepository();

            foreach (var proj in release.Projects)
            {
                deliverable.Scope.Add(projRep.GetProjectWithWorkload(proj.Id, release.Id, milestone.Id, deliverable.Id));
            }
            return deliverable;
        }

        public List<Deliverable> GetConfiguredDeliverables(Milestone milestone)
        {
            var lst = new List<Deliverable>();
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
                        var deliv = new Deliverable { 
                            Id = int.Parse(delReader["DeliverableId"].ToString()), Title = delReader["Title"].ToString(), Description = delReader["Description"].ToString(), 
                            Location = delReader["Location"].ToString(), Format = delReader["Format"].ToString()//, Owner = delReader["Owner"].ToString()
                        };

                        var cmdAct = new SqlCommand("get_activities_for_deliverable", conn);
                        cmdAct.Parameters.Add("@DeliverableId", System.Data.SqlDbType.Int).Value = deliv.Id;
                        cmdAct.CommandType = System.Data.CommandType.StoredProcedure;
                        using (var actReader = cmdAct.ExecuteReader())
                        {
                            while(actReader.Read())
                            {
                                deliv.ConfiguredActivities.Add(new Activity { Id = int.Parse(actReader["Id"].ToString()), Title = actReader["Title"].ToString(), Description = actReader["Description"].ToString() }); 
                            }
                        }
                        lst.Add(deliv);
                    }
                }
            }
            return lst;
        }

        /// <summary>
        /// Gets complete Milestones, including Configured Deliverables and Deliverables Status
        /// </summary>
        /// <param name="release"></param>
        /// <returns></returns>
        public List<Milestone> GetMilestonesForRelease(Release release)
        {
            //_release = release;

            var conn = new SqlConnection(this.ConnectionString);

            var cmd = new SqlCommand("sp_get_phase_milestones", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("@PhaseId", System.Data.SqlDbType.Int).Value = release.Id;
            var lst = new List<Milestone>();

            using (conn)
            {
                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        var ms = this.CreateItemByDbRow(reader);
                        foreach (var del in ms.Deliverables)
                            this.AddDeliverableStatus(del, ms, release);
                        lst.Add(ms);
                    }
                }
            }
            return lst;
        }

        public List<Milestone> GetConfiguredMilestonesForRelease(int releaseId)
        {
            //_release = release;

            var conn = new SqlConnection(this.ConnectionString);

            var cmd = new SqlCommand("sp_get_phase_milestones", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("@PhaseId", System.Data.SqlDbType.Int).Value = releaseId;
            var lst = new List<Milestone>();

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

        public List<Milestone> GetMilestonesForComingDays(int amountDays)
        {
            var conn = new SqlConnection(this.ConnectionString);

            var cmd = new SqlCommand("sp_get_milestones_for_next_days", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("@AmountDays", System.Data.SqlDbType.Int).Value = amountDays;
            var lst = new List<Milestone>();

            using (conn)
            {
                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        var milestone = new Milestone { Id = int.Parse(reader["Id"].ToString()), Title = reader["Title"].ToString(), Date = DateTime.Parse(reader["Date"].ToString()), Time = reader["Time"].ToString(), Description = reader["Description"].ToString(), Release = new Release { Id = int.Parse(reader["ReleaseId"].ToString()), Title = reader["ReleaseTitle"].ToString() } };
                        lst.Add(milestone);
                    }
                }
            }
            return lst;
        }

        public void AddNotificationToHistory(int milestoneId, int releaseId, string notificationType)
        {
            var conn = new SqlConnection(this.ConnectionString);

            var cmd = new SqlCommand("sp_add_notification_to_history", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("@EventId", System.Data.SqlDbType.Int).Value = milestoneId;
            cmd.Parameters.Add("@PhaseId", System.Data.SqlDbType.Int).Value = releaseId;
            cmd.Parameters.Add("@EventType", System.Data.SqlDbType.VarChar).Value = "Milestone";
            cmd.Parameters.Add("@NotificationType", System.Data.SqlDbType.VarChar).Value = notificationType;

            using (conn)
            {
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public List<ActivityStatus> GetActivityStatusForMilestones(Milestone milestone)
        {
            var conn = new SqlConnection(this.ConnectionString);

            var cmd = new SqlCommand("sp_get_deliverable_status_for_milestone", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("@MilestoneId", System.Data.SqlDbType.Int).Value = milestone.Id;
            var lst = new List<ActivityStatus>();

            using (conn)
            {
                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        var actStatus = new ActivityStatus { Activity = new Activity { Title = reader["ActivityTitle"].ToString() }, Deliverable = new Deliverable { Title = reader["DeliverableTitle"].ToString(), Format = reader["DeliverableFormat"].ToString() }, Project = new Project { Title = reader["ProjectTitle"].ToString() }, HoursRemaining = int.Parse(reader["HoursRemaining"].ToString()) };
                        lst.Add(actStatus);
                    }
                }
            }
            return lst;
        }
    }
}