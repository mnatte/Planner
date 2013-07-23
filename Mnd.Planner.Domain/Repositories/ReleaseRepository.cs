using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.SqlClient;
using System.Data;
using Mnd.Helpers;
using Mnd.Planner.Domain.Persistence;
using Mnd.Planner.Domain;
using Mnd.DataAccess;

namespace Mnd.Planner.Domain.Repositories
{
    public class ReleaseRepository
    {
        public Release GetRelease(int id)
        {
            // add MultipleActiveResultSets=true to enable nested datareaders
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            Release release = null;

            using (conn)
            {
                conn.Open();

                // Release
                var cmd = new SqlCommand(string.Format("Select * from Phases where Id = {0}", id), conn);
                using (var reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                        release = new Release { Id = int.Parse(reader["Id"].ToString()), EndDate = DateTime.Parse(reader["EndDate"].ToString()), StartDate = DateTime.Parse(reader["StartDate"].ToString()), Title = reader["Title"].ToString(), Description = reader["Description"].ToString() };
                }

                // Child phases
                var cmd2 = new SqlCommand(string.Format("Select * from Phases where ParentId = {0}", id), conn);
                using (var reader = cmd2.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        release.Phases.Add(new Phase { Id = int.Parse(reader["Id"].ToString()), EndDate = DateTime.Parse(reader["EndDate"].ToString()), StartDate = DateTime.Parse(reader["StartDate"].ToString()), Title = reader["Title"].ToString(), Description = reader["Description"].ToString() });
                    }
                }

                // Projects
                using (var cmdProjects = new SqlCommand(string.Format("SELECT rp.id, rp.PhaseId as ReleaseId, rp.ProjectId, p.Title, p.[Description], p.TfsIterationPath, p.TfsDevBranch, p.ShortName FROM ReleaseProjects rp INNER JOIN Projects p on rp.ProjectId = p.Id WHERE rp.PhaseId = {0}", id), conn))
                {
                    using (var projectsReader = cmdProjects.ExecuteReader())
                    {
                        while (projectsReader.Read())
                        {
                            var project = new Project { ShortName = projectsReader["ShortName"].ToString(), Id = int.Parse(projectsReader["ProjectId"].ToString()) };

                            // Backlog
                            //var cmd3 = new SqlCommand(string.Format("Select i.BusinessId, i.ContactPerson, i.WorkRemaining, i.Title, i.State, p.Id AS ProjectId, p.ShortName as ProjectShortName from TfsImport i INNER JOIN Phases r ON i.IterationPath LIKE r.TfsIterationPath + '%' INNER JOIN Projects p on i.IterationPath LIKE p.TfsIterationPath + '%' WHERE r.Id = {0}", id), conn);
                            //using (var featuresReader = cmd3.ExecuteReader())
                            //{
                            //    while (featuresReader.Read())
                            //    {
                            //        var feature = new ReleaseModels.Feature { BusinessId = featuresReader["BusinessId"].ToString(), ContactPerson = featuresReader["ContactPerson"].ToString(), RemainingHours = int.Parse(featuresReader["WorkRemaining"].ToString()), Title = featuresReader["Title"].ToString(), Status = featuresReader["State"].ToString() };
                            //        project.Backlog.Add(feature);
                            //    }
                            //}

                            //// Assigned Resources
                            //var cmdReleaseResources = new SqlCommand(String.Format("Select rr.*, p.Initials, p.HoursPerWeek from ReleaseResources rr INNER JOIN Persons p on rr.PersonId = p.Id where rr.ReleaseId = {0} and rr.ProjectId = {1}", id, project.Id), conn);
                            //using (var releaseResourcesReader = cmdReleaseResources.ExecuteReader())
                            //{
                            //    while (releaseResourcesReader.Read())
                            //    {
                            //        var assignment = new ReleaseModels.ResourceAssignment { EndDate = DateTime.Parse(releaseResourcesReader["EndDate"].ToString()), StartDate = DateTime.Parse(releaseResourcesReader["StartDate"].ToString()), FocusFactor = double.Parse(releaseResourcesReader["FocusFactor"].ToString()), Resource = new ReleaseModels.Resource { AvailableHoursPerWeek = int.Parse(releaseResourcesReader["HoursPerWeek"].ToString()), Initials = releaseResourcesReader["Initials"].ToString() } };
                            //        // get absences
                            //        var cmdAbsences = new SqlCommand(String.Format("Select * from Absences where PersonId = {0}", releaseResourcesReader["PersonId"].ToString()), conn);
                            //        using (var absencesReader = cmdAbsences.ExecuteReader())
                            //        {
                            //            while (absencesReader.Read())
                            //            {
                            //                assignment.Resource.PeriodsAway.Add(new ReleaseModels.Phase { Id = int.Parse(absencesReader["Id"].ToString()), EndDate = DateTime.Parse(absencesReader["EndDate"].ToString()), StartDate = DateTime.Parse(absencesReader["StartDate"].ToString()), Title = absencesReader["Title"].ToString() });
                            //            }
                            //        }
                            //        project.AssignedResources.Add(assignment);
                            //    }
                            //}

                            release.Projects.Add(project);
                        }
                    }
                }
            }

            conn.Close();
            return release;
        }

        public Release GetReleaseSummary(int id)
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            Release release = null;

            using (conn)
            {
                conn.Open();

                // Release
                var cmd = new SqlCommand(string.Format("Select * from Phases where Id = {0}", id), conn);
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        release = new Release { Id = int.Parse(reader["Id"].ToString()), EndDate = DateTime.Parse(reader["EndDate"].ToString()), StartDate = DateTime.Parse(reader["StartDate"].ToString()), Title = reader["Title"].ToString() };

                        // Child phases
                        var cmd2 = new SqlCommand(string.Format("Select * from Phases where ParentId = {0}", release.Id), conn);
                        using (var reader2 = cmd2.ExecuteReader())
                        {
                            while (reader2.Read())
                            {
                                release.Phases.Add(new Phase { Id = int.Parse(reader2["Id"].ToString()), EndDate = DateTime.Parse(reader2["EndDate"].ToString()), StartDate = DateTime.Parse(reader2["StartDate"].ToString()), Title = reader2["Title"].ToString() });
                            }
                        }

                        var projs = new SqlCommand(string.Format("Select rp.ProjectId, p.Title, p.ShortName from ReleaseProjects rp inner join Projects p on rp.ProjectId = p.Id where PhaseId = {0}", release.Id), conn);
                        using (var reader3 = projs.ExecuteReader())
                        {
                            while (reader3.Read())
                            {
                                var p = new Project { Id = int.Parse(reader3["ProjectId"].ToString()), Title = reader3["Title"].ToString(), ShortName = reader3["ShortName"].ToString() };
                                release.Projects.Add(p);
                            }
                        }

                        // Milestones
                        var milestones = GetMilestonesForRelease(release, conn);
                        foreach (var ms in milestones)
                            release.Milestones.Add(ms);
                    }
                }
            }
            return release;
        }

        public List<Release> GetReleaseSummaries()
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            var releases = new List<Release>();

            using (conn)
            {
                conn.Open();

                // Release
                // TODO: add different 'Type' value to child phases, these are also labelled 'Release', hence where clause on ParentId
                var cmd = new SqlCommand("Select * from Phases where Type = 'Release' AND ISNULL(ParentId, 0) = 0", conn);
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        var rel = new Release { Id = int.Parse(reader["Id"].ToString()), EndDate = DateTime.Parse(reader["EndDate"].ToString()), StartDate = DateTime.Parse(reader["StartDate"].ToString()), Title = reader["Title"].ToString() };

                        // Child phases
                        var cmd2 = new SqlCommand(string.Format("Select * from Phases where ParentId = {0}", rel.Id), conn);
                        using (var reader2 = cmd2.ExecuteReader())
                        {
                            while (reader2.Read())
                            {
                                rel.Phases.Add(new Phase { Id = int.Parse(reader2["Id"].ToString()), EndDate = DateTime.Parse(reader2["EndDate"].ToString()), StartDate = DateTime.Parse(reader2["StartDate"].ToString()), Title = reader2["Title"].ToString() });
                            }
                        }

                        // Projects
                        var projs = new SqlCommand(string.Format("Select rp.ProjectId, p.Title, p.ShortName from ReleaseProjects rp inner join Projects p on rp.ProjectId = p.Id where PhaseId = {0}", rel.Id), conn);
                        using (var reader3 = projs.ExecuteReader())
                        {
                            while (reader3.Read())
                            {
                                var p = new Project { Id = int.Parse(reader3["ProjectId"].ToString()), Title = reader3["Title"].ToString(), ShortName = reader3["ShortName"].ToString() };
                                rel.Projects.Add(p);
                            }
                        }

                        // Milestones
                        var milestones = GetMilestonesForRelease(rel, conn);
                        foreach (var ms in milestones)
                            rel.Milestones.Add(ms);

                        releases.Add(rel);
                    }
                }
            }
            return releases;
        }

        public Release Save(ReleaseInputModel obj)
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            int newId = 0;
            try
            {
                using (conn)
                {
                    conn.Open();

                    var cmd = new SqlCommand("sp_upsert_release", conn);
                    cmd.Parameters.Add("@Id", System.Data.SqlDbType.Int).Value = obj.Id;
                    cmd.Parameters.Add("@Title", System.Data.SqlDbType.VarChar).Value = obj.Title;
                    cmd.Parameters.Add("@Descr", System.Data.SqlDbType.VarChar).Value = "";// obj.Descr;
                    cmd.Parameters.Add("@StartDate", System.Data.SqlDbType.DateTime).Value = obj.StartDate.ToDateTimeFromDutchString();
                    cmd.Parameters.Add("@EndDate", System.Data.SqlDbType.DateTime).Value = obj.EndDate.ToDateTimeFromDutchString();
                    cmd.Parameters.Add("@ParentId", System.Data.SqlDbType.Int).Value = obj.ParentId;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    var result = cmd.ExecuteScalar().ToString();

                    if (result == string.Empty && obj.ParentId == 0)
                    // it's an update of a root node
                    {
                        newId = obj.Id;
                    }
                    else if (result != string.Empty && obj.ParentId == 0)
                    // it's an insert of a root node
                    {
                        newId = int.Parse(result);
                    }
                    else
                    // it's a child; return parentId
                    {
                        newId = obj.ParentId;
                    }

                    // completely renew the Projects for the Release as set in the client app
                    var cmdDelCross = new SqlCommand(string.Format("Delete from ReleaseProjects where PhaseId = {0}", newId), conn);
                    cmdDelCross.ExecuteNonQuery();

                    if (obj.Projects != null && obj.Projects.Count > 0)
                    {
                        var cmdInsertReleaseProject = new SqlCommand("sp_insert_releaseproject", conn);
                        cmdInsertReleaseProject.Parameters.Add("@ReleaseId", System.Data.SqlDbType.Int).Value = newId;
                        cmdInsertReleaseProject.Parameters.Add("@ProjectId", System.Data.SqlDbType.Int).Value = 0;
                        cmdInsertReleaseProject.CommandType = System.Data.CommandType.StoredProcedure;

                        foreach (var proj in obj.Projects)
                        {
                            cmdInsertReleaseProject.Parameters["@ProjectId"].Value = proj.Id;
                            cmdInsertReleaseProject.ExecuteNonQuery();
                        }
                    }
                }
                var rel = this.GetReleaseSummary(newId);
                this.GenerateStatusRecords(rel);

                return rel;
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public Release UpdateDates(ReleaseInputModel obj)
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            try
            {
                using (conn)
                {
                    conn.Open();

                    var cmd = new SqlCommand("sp_update_phase_dates", conn);
                    cmd.Parameters.Add("@Id", System.Data.SqlDbType.Int).Value = obj.Id;
                    cmd.Parameters.Add("@StartDate", System.Data.SqlDbType.DateTime).Value = obj.StartDate.ToDateTimeFromDutchString();
                    cmd.Parameters.Add("@EndDate", System.Data.SqlDbType.DateTime).Value = obj.EndDate.ToDateTimeFromDutchString();
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.ExecuteNonQuery();
                }
                var rel = this.GetReleaseSummary(obj.Id);
                return rel;
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public bool StatusRecordsExist(int releaseId, int milestoneId, int deliverableId, int projectId)
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            using (conn)
            {
                conn.Open();
                var cmdCountStatusRecords = new SqlCommand("sp_count_milestonestatus_records", conn);
                cmdCountStatusRecords.Parameters.Add("@ReleaseId", System.Data.SqlDbType.Int).Value = releaseId;
                cmdCountStatusRecords.Parameters.Add("@ProjectId", System.Data.SqlDbType.Int).Value = projectId;
                cmdCountStatusRecords.Parameters.Add("@MilestoneId", System.Data.SqlDbType.Int).Value = milestoneId;
                cmdCountStatusRecords.Parameters.Add("@DeliverableId", System.Data.SqlDbType.Int).Value = deliverableId;
                cmdCountStatusRecords.CommandType = System.Data.CommandType.StoredProcedure;
                            
                var recs = int.Parse(cmdCountStatusRecords.ExecuteScalar().ToString());
                return recs > 0;
            }
        }

        public bool Delete(int id)
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            try
            {
                using (conn)
                {
                    conn.Open();

                    var cmd = new SqlCommand("sp_delete_release", conn);
                    cmd.Parameters.Add("@ReleaseId", System.Data.SqlDbType.Int).Value = id;
                    SqlParameter returnParameter = cmd.Parameters.Add("RetVal", SqlDbType.Int);
                    returnParameter.Direction = ParameterDirection.ReturnValue;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.ExecuteNonQuery();

                    int returnValue = (int)returnParameter.Value;
                    return returnValue == 1;
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public Milestone SaveMilestone(MilestoneInputModel obj)
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            int milestoneId = 0;
            try
            {
                using (conn)
                {
                    conn.Open();

                    var cmd = new SqlCommand("sp_upsert_milestone", conn);
                    cmd.Parameters.Add("@Id", System.Data.SqlDbType.Int).Value = obj.Id;
                    cmd.Parameters.Add("@Title", System.Data.SqlDbType.VarChar).Value = obj.Title;
                    cmd.Parameters.Add("@Description", System.Data.SqlDbType.VarChar).Value = obj.Description ?? "";
                    cmd.Parameters.Add("@Date", System.Data.SqlDbType.VarChar).Value = obj.Date.ToDateTimeFromDutchString();
                    cmd.Parameters.Add("@Time", System.Data.SqlDbType.VarChar).Value = obj.Time ?? "";
                    cmd.Parameters.Add("@PhaseId", System.Data.SqlDbType.Int).Value = obj.PhaseId;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    var result = cmd.ExecuteScalar();
                    var newId = result == null ? 0 : int.Parse(result.ToString());

                    // it's an update (case 1) or an insert (case 2)
                    milestoneId = newId == 0 ? obj.Id : newId;

                    // completely renew the Deliverables for the Milestone as set in the client app
                    var cmdDelCross = new SqlCommand(string.Format("Delete from MilestoneDeliverables where MilestoneId = {0}", milestoneId), conn);
                    cmdDelCross.ExecuteNonQuery();

                    if (obj.Deliverables != null && obj.Deliverables.Count > 0)
                    {
                        var cmdInserMilestoneDeliverable = new SqlCommand("sp_insert_milestonedeliverable", conn);
                        cmdInserMilestoneDeliverable.Parameters.Add("@MilestoneId", System.Data.SqlDbType.Int).Value = milestoneId;
                        cmdInserMilestoneDeliverable.Parameters.Add("@DeliverableId", System.Data.SqlDbType.Int).Value = 0;
                        /*cmdInserMilestoneDeliverable.Parameters.Add("@HoursRemaining", System.Data.SqlDbType.Int).Value = 0;
                        cmdInserMilestoneDeliverable.Parameters.Add("@InitialEstimate", System.Data.SqlDbType.Int).Value = 0;
                        cmdInserMilestoneDeliverable.Parameters.Add("@Owner", System.Data.SqlDbType.VarChar).Value = string.Empty;
                        cmdInserMilestoneDeliverable.Parameters.Add("@State", System.Data.SqlDbType.VarChar).Value = string.Empty;*/
                        cmdInserMilestoneDeliverable.CommandType = System.Data.CommandType.StoredProcedure;

                        foreach (var itm in obj.Deliverables)
                        {
                            cmdInserMilestoneDeliverable.Parameters["@DeliverableId"].Value = itm.Id;
                            /*cmdInserMilestoneDeliverable.Parameters["@HoursRemaining"].Value = itm.HoursRemaining;
                            cmdInserMilestoneDeliverable.Parameters["@InitialEstimate"].Value = itm.InitialHoursEstimate;
                            cmdInserMilestoneDeliverable.Parameters["@Owner"].Value = itm.Owner ?? "";
                            cmdInserMilestoneDeliverable.Parameters["@State"].Value = itm.State ?? "";*/

                            cmdInserMilestoneDeliverable.ExecuteNonQuery();
                        }
                    }

                }

                var rel = this.GetReleaseSummary(obj.PhaseId);
                this.GenerateStatusRecords(rel);
                var msrep = new MilestoneRepository();
                var milestone = msrep.GetItemById(milestoneId);
                return milestone;

            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public void GenerateStatusRecords(Release rel)
        {
            // create status records when not existing based on release configuration
            foreach (var ms in rel.Milestones)
            {
                foreach (var deliverable in ms.Deliverables)
                {
                    foreach (var proj in rel.Projects)
                    {
                        if (!this.StatusRecordsExist(rel.Id, ms.Id, deliverable.Id, proj.Id))
                        {
                            var input = new StatusInputModel
                            {
                                ProjectId = proj.Id,
                                DeliverableId = deliverable.Id,
                                MilestoneId =  ms.Id,
                                ReleaseId = rel.Id,
                                ActivityStatuses = new List<DeliverableActivityStatusInputModel>()
                            };
                            foreach (var act in deliverable.ConfiguredActivities)
                            {
                                input.ActivityStatuses.Add(new DeliverableActivityStatusInputModel { ActivityId = act.Id, HoursRemaining = 0 });
                            }
                            this.CreateDeliverableStatusRecords(input);
                        }
                    }
                }
            }
        }

        public Release UnAssignMilestone(MilestoneInputModel obj)
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            try
            {
                using (conn)
                {
                    conn.Open();

                    var cmd = new SqlCommand("sp_unassign_milestone_from_release", conn);
                    cmd.Parameters.Add("@ReleaseId", System.Data.SqlDbType.Int).Value = obj.PhaseId;
                    cmd.Parameters.Add("@MilestoneId", System.Data.SqlDbType.Int).Value = obj.Id;
                    SqlParameter returnParameter = cmd.Parameters.Add("RetVal", SqlDbType.Int);
                    returnParameter.Direction = ParameterDirection.ReturnValue;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.ExecuteNonQuery();

                }

                return this.GetRelease(obj.PhaseId);
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        private int DeleteMilestone(int milestoneId)
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            var result = 0;
            try
            {
                using (conn)
                {
                    conn.Open();

                    var cmd = new SqlCommand("sp_delete_milestone", conn);
                    cmd.Parameters.Add("@MilestoneId", System.Data.SqlDbType.Int).Value = milestoneId;
                    SqlParameter returnParameter = cmd.Parameters.Add("RetVal", SqlDbType.Int);
                    returnParameter.Direction = ParameterDirection.ReturnValue;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.ExecuteNonQuery();
                    result = (int)cmd.Parameters["RetVal"].Value;

                }

                return result;
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        // Is Milestone an entity of the Release aggregate root?
        protected List<Milestone> GetMilestonesForRelease(Release release, SqlConnection conn)
        {
            var repository = new MilestoneRepository();
            return repository.GetMilestonesForRelease(release);
        }

        public void SaveDeliverableStatus(DeliverableStatusInputModel obj)
        {
            var input = new StatusInputModel { DeliverableId = obj.DeliverableId, MilestoneId = obj.MilestoneId, ReleaseId = obj.ReleaseId, ActivityStatuses = new List<DeliverableActivityStatusInputModel>() };

            foreach (var proj in obj.Scope)
            {
                input.ProjectId = proj.Id;
                foreach (var act in proj.Workload)
                {
                    input.ActivityStatuses.Add(new DeliverableActivityStatusInputModel { ActivityId = act.Activity.Id, HoursRemaining = act.HoursRemaining });
                }

                this.CreateDeliverableStatusRecords(input);
                input.ActivityStatuses.Clear();
            }
        }

        public void CreateDeliverableStatusRecords(StatusInputModel obj)
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            try
            {
                using (conn)
                {
                    conn.Open();

                    var cmd = new SqlCommand("sp_insert_milestonestatus", conn);
                    cmd.Parameters.Add("@ReleaseId", System.Data.SqlDbType.Int).Value = obj.ReleaseId;
                    cmd.Parameters.Add("@MilestoneId", System.Data.SqlDbType.Int).Value = obj.MilestoneId;
                    cmd.Parameters.Add("@DeliverableId", System.Data.SqlDbType.Int).Value = obj.DeliverableId;
                    cmd.Parameters.Add("@ProjectId", System.Data.SqlDbType.Int).Value = obj.ProjectId;
                    cmd.Parameters.Add("@ActivityId", System.Data.SqlDbType.Int).Value = 0;
                    cmd.Parameters.Add("@HoursRemaining", System.Data.SqlDbType.Int).Value = 0;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    // add to history table for reporting purposes
                    var cmd2 = new SqlCommand("sp_insert_remainingwork_history_table", conn);
                    cmd2.Parameters.Add("@ReleaseId", System.Data.SqlDbType.Int).Value = obj.ReleaseId;
                    cmd2.Parameters.Add("@MilestoneId", System.Data.SqlDbType.Int).Value = obj.MilestoneId;
                    cmd2.Parameters.Add("@DeliverableId", System.Data.SqlDbType.Int).Value = obj.DeliverableId;
                    cmd2.Parameters.Add("@ProjectId", System.Data.SqlDbType.Int).Value = obj.ProjectId;
                    cmd2.Parameters.Add("@ActivityId", System.Data.SqlDbType.Int).Value = 0;
                    cmd2.Parameters.Add("@HoursRemaining", System.Data.SqlDbType.Int).Value = 0;
                    cmd2.CommandType = System.Data.CommandType.StoredProcedure;
                    
                    // completely renew the ProjectActivityStatuses for the Milestone Deliverables as set in the client app
                    var cmdDelCross = new SqlCommand(string.Format("DELETE FROM MilestoneStatus WHERE ReleaseId = {0} AND MilestoneId = {1} AND DeliverableId = {2} AND ProjectId = {3}", obj.ReleaseId, obj.MilestoneId, obj.DeliverableId, obj.ProjectId), conn);
                    cmdDelCross.ExecuteNonQuery();

                    foreach (var itm in obj.ActivityStatuses)
                    {
                        //cmd.Parameters["@ProjectId"].Value = itm.ProjectId;
                        cmd.Parameters["@ActivityId"].Value = itm.ActivityId;
                        cmd.Parameters["@HoursRemaining"].Value = itm.HoursRemaining;
                        cmd.ExecuteNonQuery();

                        cmd2.Parameters["@ActivityId"].Value = itm.ActivityId;
                        cmd2.Parameters["@HoursRemaining"].Value = itm.HoursRemaining;
                        cmd2.ExecuteNonQuery();
                    }

                    
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        private int UnAssignProject(int releaseId, int projectId)
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            var result = 0;
            try
            {
                using (conn)
                {
                    conn.Open();

                    var cmd = new SqlCommand("sp_unassign_project_from_release", conn);
                    cmd.Parameters.Add("@ReleaseId", System.Data.SqlDbType.Int).Value = releaseId;
                    cmd.Parameters.Add("@ProjectId", System.Data.SqlDbType.Int).Value = projectId;
                    SqlParameter returnParameter = cmd.Parameters.Add("RetVal", SqlDbType.Int);
                    returnParameter.Direction = ParameterDirection.ReturnValue;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.ExecuteNonQuery();
                    result = (int)cmd.Parameters["RetVal"].Value;

                }

                return result;
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public Release SaveReleaseConfiguration(ReleaseConfigurationInputModel obj)
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            int newId = 0;
            try
            {
                using (conn)
                {
                    conn.Open();

                    var cmd = new SqlCommand("sp_upsert_release", conn);
                    cmd.Parameters.Add("@Id", System.Data.SqlDbType.Int).Value = obj.Id;
                    cmd.Parameters.Add("@Title", System.Data.SqlDbType.VarChar).Value = obj.Title;
                    cmd.Parameters.Add("@Descr", System.Data.SqlDbType.VarChar).Value = "";// obj.Descr;
                    cmd.Parameters.Add("@StartDate", System.Data.SqlDbType.DateTime).Value = obj.StartDate.ToDateTimeFromDutchString();
                    cmd.Parameters.Add("@EndDate", System.Data.SqlDbType.DateTime).Value = obj.EndDate.ToDateTimeFromDutchString();
                    cmd.Parameters.Add("@ParentId", System.Data.SqlDbType.Int).Value = DBNull.Value;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    var result = cmd.ExecuteScalar().ToString();

                    if (result == string.Empty)
                    // it's an update
                    {
                        newId = obj.Id;
                    }
                    else
                    // it's an insert
                    {
                        newId = int.Parse(result);
                    }

                    // clean up Milestones that are in database but not present in the inputmodel
                    // do cleaning before storing the new milestone(s) to db, otherwise this / these will be deleted immediately since the newly generated id probably does not match the id passed in the inputmodel
                    var msrep = new MilestoneRepository();
                    // get all existing milestoneid's for this release
                    var currentMilestones = msrep.GetConfiguredMilestonesForRelease(newId).Select(m => m.Id).ToList();
                    // get all milestoneId's contained in the inputmodel
                    var newMilestones = obj.Milestones.Select(m => m.Id).ToList();
                    // remove all new id's from existing id's, keeping all obsolete id's. 'RemoveAll' returns the amount removed, the collection itself is changed
                    var amountObsolete = currentMilestones.RemoveAll(ms => newMilestones.Contains(ms));
                    foreach (var obsoleteId in currentMilestones)
                    {
                        this.DeleteMilestone(obsoleteId);
                    }

                    foreach (var phase in obj.Phases)
                    {
                        this.SavePhaseConfiguration(phase, newId);
                    }

                    foreach (var milestone in obj.Milestones)
                    {
                        this.SaveMilestoneConfiguration(milestone, newId);
                    }

                    // Projects are not value objects, they can be tracked and maintained seperately.
                    // They do however belong to the Release aggregate but they need to be assigned / unassigned, not just deleted and inserted

                    var projRep = new ProjectRepository();
                    // get all existing projectid's for this release
                    var currentProjects = projRep.GetConfiguredProjectsForRelease(newId).Select(m => m.Id).ToList();
                    // create copy to determine obsolete projects
                    var obsoleteProjects = new List<int>();
                    obsoleteProjects.AddRange(currentProjects);

                    // remove all configured id's in inputmodel from existing id's, keeping all obsolete id's. 'RemoveAll' returns the amount removed, the collection itself is changed
                    var amountObsoleteProjects = obsoleteProjects.RemoveAll(p => obj.Projects.Contains(p));
                    foreach (var obsoleteId in obsoleteProjects)
                    {
                        this.UnAssignProject(newId, obsoleteId);
                    }

                    // remove current projects from configured projects in inputmodel, leaving all new projects
                    obj.Projects.RemoveAll(p => currentProjects.Contains(p));

                    // completely renew the Projects for the Release as set in the client app
                    //var cmdDelCross = new SqlCommand(string.Format("Delete from ReleaseProjects where PhaseId = {0}", newId), conn);
                    //cmdDelCross.ExecuteNonQuery();

                    if (obj.Projects != null && obj.Projects.Count > 0)
                    {
                        var cmdInsertReleaseProject = new SqlCommand("sp_insert_releaseproject", conn);
                        cmdInsertReleaseProject.Parameters.Add("@ReleaseId", System.Data.SqlDbType.Int).Value = newId;
                        cmdInsertReleaseProject.Parameters.Add("@ProjectId", System.Data.SqlDbType.Int).Value = 0;
                        cmdInsertReleaseProject.CommandType = System.Data.CommandType.StoredProcedure;

                        foreach (var projId in obj.Projects)
                        {
                            cmdInsertReleaseProject.Parameters["@ProjectId"].Value = projId;
                            cmdInsertReleaseProject.ExecuteNonQuery();
                        }
                    }
                }

                var rel = this.GetReleaseSummary(newId);
                this.GenerateStatusRecords(rel);

                return rel;
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        private void SaveMilestoneConfiguration(MilestoneConfigurationInputModel obj, int releaseId)
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            int milestoneId = 0;
            try
            {
                using (conn)
                {
                    conn.Open();

                    var cmd = new SqlCommand("sp_upsert_milestone", conn);
                    cmd.Parameters.Add("@Id", System.Data.SqlDbType.Int).Value = obj.Id;
                    cmd.Parameters.Add("@Title", System.Data.SqlDbType.VarChar).Value = obj.Title;
                    cmd.Parameters.Add("@Description", System.Data.SqlDbType.VarChar).Value = obj.Description ?? "";
                    cmd.Parameters.Add("@Date", System.Data.SqlDbType.VarChar).Value = obj.Date.ToDateTimeFromDutchString();
                    cmd.Parameters.Add("@Time", System.Data.SqlDbType.VarChar).Value = obj.Time ?? "";
                    cmd.Parameters.Add("@PhaseId", System.Data.SqlDbType.Int).Value = releaseId;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    var result = cmd.ExecuteScalar();
                    var newId = result == null ? 0 : int.Parse(result.ToString());

                    // it's an update (case 1) or an insert (case 2)
                    milestoneId = newId == 0 ? obj.Id : newId;

                    // completely renew the Deliverables for the Milestone as set in the client app
                    var cmdDelCross = new SqlCommand(string.Format("Delete from MilestoneDeliverables where MilestoneId = {0}", milestoneId), conn);
                    cmdDelCross.ExecuteNonQuery();

                    if (obj.Deliverables != null && obj.Deliverables.Count > 0)
                    {
                        var cmdInserMilestoneDeliverable = new SqlCommand("sp_insert_milestonedeliverable", conn);
                        cmdInserMilestoneDeliverable.Parameters.Add("@MilestoneId", System.Data.SqlDbType.Int).Value = milestoneId;
                        cmdInserMilestoneDeliverable.Parameters.Add("@DeliverableId", System.Data.SqlDbType.Int).Value = 0;
                        cmdInserMilestoneDeliverable.CommandType = System.Data.CommandType.StoredProcedure;

                        foreach (var deliverableId in obj.Deliverables)
                        {
                            cmdInserMilestoneDeliverable.Parameters["@DeliverableId"].Value = deliverableId;
                            cmdInserMilestoneDeliverable.ExecuteNonQuery();
                        }
                    }

                    // clean up resource assignments of the removed milestonedeliverables for the release
                    var cmdClean = new SqlCommand("sp_remove_orphan_resource_assignments", conn);
                    cmdClean.Parameters.Add("@ReleaseId", System.Data.SqlDbType.Int).Value = releaseId;
                    cmdClean.CommandType = System.Data.CommandType.StoredProcedure;
                    cmdClean.ExecuteNonQuery();

                    // clean up work status history of the removed milestonedeliverables for the release
                    var cmdClean2 = new SqlCommand("sp_remove_orphan_work_history_milestone_deliverables", conn);
                    cmdClean2.Parameters.Add("@ReleaseId", System.Data.SqlDbType.Int).Value = releaseId;
                    cmdClean2.CommandType = System.Data.CommandType.StoredProcedure;
                    cmdClean2.ExecuteNonQuery();
                }

                //var rel = this.GetReleaseSummary(releaseId);
                //this.GenerateStatusRecords(rel);
                //var msrep = new MilestoneRepository();
                //var milestone = msrep.GetItemById(milestoneId);
                //return milestone;

            }
            catch (Exception ex)
            {
                throw;
            }
        }

        /// <summary>
        /// Update phase info
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        public Phase UpdatePhase(Phase evt)
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            try
            {
                using (conn)
                {
                    conn.Open();

                    var cmd = new SqlCommand("sp_update_phase", conn);
                    cmd.Parameters.Add("@Id", System.Data.SqlDbType.Int).Value = evt.Id;
                    cmd.Parameters.Add("@StartDate", System.Data.SqlDbType.DateTime).Value = evt.StartDate;
                    cmd.Parameters.Add("@EndDate", System.Data.SqlDbType.DateTime).Value = evt.EndDate;
                    cmd.Parameters.Add("@Title", System.Data.SqlDbType.VarChar).Value = evt.Title;
                    cmd.Parameters.Add("@Description", System.Data.SqlDbType.VarChar).Value = evt.Description ?? "";
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.ExecuteNonQuery();

                    var rep = new ReleaseRepository();
                    var phase = rep.GetRelease(evt.Id);

                    return phase;
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        /// <summary>
        /// Save new Period
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        public Phase AddPeriod(Phase phase)
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            var newId = 0;
            try
            {
                using (conn)
                {
                    conn.Open();

                    var cmd = new SqlCommand("sp_insert_period", conn);
                    cmd.Parameters.Add("@Title", System.Data.SqlDbType.VarChar).Value = phase.Title;
                    cmd.Parameters.Add("@StartDate", System.Data.SqlDbType.DateTime).Value = phase.StartDate;
                    cmd.Parameters.Add("@EndDate", System.Data.SqlDbType.DateTime).Value = phase.EndDate;
                    cmd.Parameters.Add("@Description", System.Data.SqlDbType.VarChar).Value = "";

                    var returnParameter = new SqlParameter("@NewId", SqlDbType.Int);
                    returnParameter.Direction = ParameterDirection.Output;
                    cmd.Parameters.Add(returnParameter);
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.ExecuteNonQuery();

                    newId = (int)returnParameter.Value;
                }
                return new Phase { Title = phase.Title, EndDate = phase.EndDate, StartDate = phase.StartDate, Id = newId };
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        private void SavePhaseConfiguration(PhaseConfigurationInputModel obj, int parentId)
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            try
            {
                using (conn)
                {
                    conn.Open();

                    var cmd = new SqlCommand("sp_upsert_release", conn);
                    cmd.Parameters.Add("@Id", System.Data.SqlDbType.Int).Value = obj.Id;
                    cmd.Parameters.Add("@Title", System.Data.SqlDbType.VarChar).Value = obj.Title;
                    cmd.Parameters.Add("@Descr", System.Data.SqlDbType.VarChar).Value = "";// obj.Descr;
                    cmd.Parameters.Add("@StartDate", System.Data.SqlDbType.DateTime).Value = obj.StartDate.ToDateTimeFromDutchString();
                    cmd.Parameters.Add("@EndDate", System.Data.SqlDbType.DateTime).Value = obj.EndDate.ToDateTimeFromDutchString();
                    cmd.Parameters.Add("@ParentId", System.Data.SqlDbType.Int).Value = parentId;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    var result = cmd.ExecuteScalar().ToString();
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public List<ArtefactActivityProgressReport> GetArtefactsProgress(int releaseId)
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            var lst = new List<ArtefactActivityProgressReport>();
            try
            {
                using (conn)
                {
                    conn.Open();

                    var cmd = new SqlCommand("sp_get_release_progress", conn);
                    cmd.Parameters.Add("@ReleaseId", System.Data.SqlDbType.Int).Value = releaseId;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            var status = new ArtefactActivityProgressReport { HoursRemaining = int.Parse(reader["HoursRemaining"].ToString()), StatusDate = DateTime.Parse(reader["StatusDate"].ToString()), Release = reader["Release"].ToString(), Artefact = reader["Artefact"].ToString(), Milestone = reader["Milestone"].ToString(), MilestoneId = int.Parse(reader["MilestoneId"].ToString()), ArtefactId = int.Parse(reader["ArtefactId"].ToString()) };

                            lst.Add(status);
                        }
                    }
                }
                return lst;
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public List<ArtefactActivityProgressReport> GetArtefactsProgress(int phaseId, int milestoneId)
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            var lst = new List<ArtefactActivityProgressReport>();
            try
            {
                using (conn)
                {
                    conn.Open();

                    var cmd = new SqlCommand("sp_get_milestone_progress", conn);
                    cmd.Parameters.Add("@PhaseId", System.Data.SqlDbType.Int).Value = phaseId;
                    cmd.Parameters.Add("@MilestoneId", System.Data.SqlDbType.Int).Value = milestoneId;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            var status = new ArtefactActivityProgressReport { HoursRemaining = int.Parse(reader["HoursRemaining"].ToString()), StatusDate = DateTime.Parse(reader["StatusDate"].ToString()), Release = reader["Release"].ToString(), Artefact = reader["Artefact"].ToString(), Milestone = reader["Milestone"].ToString(), MilestoneId = int.Parse(reader["MilestoneId"].ToString()), ArtefactId = int.Parse(reader["ArtefactId"].ToString()) };

                            lst.Add(status);
                        }
                    }
                }
                return lst;
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public List<Release> GetReleaseSnapshotsWithProgressData()
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            var allMilestones = new List<Milestone>();
            try
            {
                using (conn)
                {
                    conn.Open();

                    var cmd = new SqlCommand("sp_get_release_snapshots_with_progress_data", conn);
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            // get records with PhaseId, PhaseTitle, MilestoneId, MilestoneTitle
                            var status = new Milestone { Id = int.Parse(reader["MilestoneId"].ToString()), Title = reader["MilestoneTitle"].ToString(), Release = new Release { Id = int.Parse(reader["PhaseId"].ToString()), Title = reader["PhaseTitle"].ToString() } };

                            allMilestones.Add(status);
                        }
                    }
                }
                // create hierarchical structure
                var phases = allMilestones
                    .GroupBy(m => new { m.Release.Id, m.Release.Title }, // group by two columns, making an ANONYMOUS object
                                m => new Milestone { Id = m.Id, Title = m.Title }, // every grouped record contains an IEnumerable<Milestone>
                                (key, values) => new Release(values.ToList()) { Id = key.Id, Title = key.Title }); // key is the grouping columns, values is the IEnumerable<Milestone> from 2nd param function
                                                                                                                   // create a new Release object
                //var phases = allMilestones
                //    .GroupBy(m => new { m.Release.Id, m.Release.Title }) // group by two columns, making a Release object
                //    .Select(m => new Release(m.ToList()) { Id = m.Key.Id, Title = m.Key.Title });
                
                return phases.ToList();
            }
            catch (Exception ex)
            {
                throw;
            }
        }
    }
}