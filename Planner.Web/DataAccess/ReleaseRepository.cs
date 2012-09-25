using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MvcApplication1.Models;
using System.Data.SqlClient;

namespace MvcApplication1.DataAccess
{
    public class ReleaseRepository
    {
        public ReleaseModels.Release GetRelease(int id)
        {
            // add MultipleActiveResultSets=true to enable nested datareaders
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            ReleaseModels.Release release;

            using (conn)
            {
                conn.Open();

                // Release
                var cmd = new SqlCommand(string.Format("Select * from Phases where Id = {0}", id), conn);
                using (var reader = cmd.ExecuteReader())
                {
                    reader.Read();
                    release = new ReleaseModels.Release { Id = int.Parse(reader["Id"].ToString()), EndDate = DateTime.Parse(reader["EndDate"].ToString()), StartDate = DateTime.Parse(reader["StartDate"].ToString()), Title = reader["Title"].ToString(), TfsIterationPath = reader["TfsIterationPath"].ToString() };
                }

                // Child phases
                var cmd2 = new SqlCommand(string.Format("Select * from Phases where ParentId = {0}", id), conn);
                using (var reader = cmd2.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        release.Phases.Add(new ReleaseModels.Phase { Id = int.Parse(reader["Id"].ToString()), EndDate = DateTime.Parse(reader["EndDate"].ToString()), StartDate = DateTime.Parse(reader["StartDate"].ToString()), Title = reader["Title"].ToString(), TfsIterationPath = reader["TfsIterationPath"].ToString() });
                    }
                }

                // Projects
                using (var cmdProjects = new SqlCommand(string.Format("SELECT rp.id, rp.PhaseId as ReleaseId, rp.ProjectId, p.Title, p.[Description], p.TfsIterationPath, p.TfsDevBranch, p.ShortName FROM ReleaseProjects rp INNER JOIN Projects p on rp.ProjectId = p.Id WHERE rp.PhaseId = {0}", id), conn))
                {
                    using (var projectsReader = cmdProjects.ExecuteReader())
                    {
                        while (projectsReader.Read())
                        {
                            var project = new ReleaseModels.Project { ShortName = projectsReader["ShortName"].ToString(), Id = int.Parse(projectsReader["ProjectId"].ToString()) };

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

        public ReleaseModels.Release GetReleaseSummary(int id)
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            ReleaseModels.Release release = null;

            using (conn)
            {
                conn.Open();

                // Release
                var cmd = new SqlCommand(string.Format("Select * from Phases where Id = {0}", id), conn);
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        release = new ReleaseModels.Release { Id = int.Parse(reader["Id"].ToString()), EndDate = DateTime.Parse(reader["EndDate"].ToString()), StartDate = DateTime.Parse(reader["StartDate"].ToString()), Title = reader["Title"].ToString(), TfsIterationPath = reader["TfsIterationPath"].ToString() };

                        // Child phases
                        var cmd2 = new SqlCommand(string.Format("Select * from Phases where ParentId = {0}", release.Id), conn);
                        using (var reader2 = cmd2.ExecuteReader())
                        {
                            while (reader2.Read())
                            {
                                release.Phases.Add(new ReleaseModels.Phase { Id = int.Parse(reader2["Id"].ToString()), EndDate = DateTime.Parse(reader2["EndDate"].ToString()), StartDate = DateTime.Parse(reader2["StartDate"].ToString()), Title = reader2["Title"].ToString(), TfsIterationPath = reader2["TfsIterationPath"].ToString() });
                            }
                        }

                        var projs = new SqlCommand(string.Format("Select rp.ProjectId, p.Title, p.ShortName from ReleaseProjects rp inner join Projects p on rp.ProjectId = p.Id where PhaseId = {0}", release.Id), conn);
                        using (var reader3 = projs.ExecuteReader())
                        {
                            while (reader3.Read())
                            {
                                var p = new ReleaseModels.Project { Id = int.Parse(reader3["ProjectId"].ToString()), Title = reader3["Title"].ToString(), ShortName = reader3["ShortName"].ToString() };
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

        public List<ReleaseModels.Release> GetReleaseSummaries()
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            var releases = new List<ReleaseModels.Release>();

            using (conn)
            {
                conn.Open();

                // Release
                var cmd = new SqlCommand("Select * from Phases where ISNULL(ParentId, 0) = 0 AND Id <> 84", conn);
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        var rel = new ReleaseModels.Release { Id = int.Parse(reader["Id"].ToString()), EndDate = DateTime.Parse(reader["EndDate"].ToString()), StartDate = DateTime.Parse(reader["StartDate"].ToString()), Title = reader["Title"].ToString(), TfsIterationPath = reader["TfsIterationPath"].ToString() };

                        // Child phases
                        var cmd2 = new SqlCommand(string.Format("Select * from Phases where ParentId = {0}", rel.Id), conn);
                        using (var reader2 = cmd2.ExecuteReader())
                        {
                            while (reader2.Read())
                            {
                                rel.Phases.Add(new ReleaseModels.Phase { Id = int.Parse(reader2["Id"].ToString()), EndDate = DateTime.Parse(reader2["EndDate"].ToString()), StartDate = DateTime.Parse(reader2["StartDate"].ToString()), Title = reader2["Title"].ToString(), TfsIterationPath = reader2["TfsIterationPath"].ToString() });
                            }
                        }

                        // Projects
                        var projs = new SqlCommand(string.Format("Select rp.ProjectId, p.Title, p.ShortName from ReleaseProjects rp inner join Projects p on rp.ProjectId = p.Id where PhaseId = {0}", rel.Id), conn);
                        using (var reader3 = projs.ExecuteReader())
                        {
                            while (reader3.Read())
                            {
                                var p = new ReleaseModels.Project { Id = int.Parse(reader3["ProjectId"].ToString()), Title = reader3["Title"].ToString(), ShortName = reader3["ShortName"].ToString() };
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

        public ReleaseModels.Release Save(ReleaseInputModel obj)
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
                    cmd.Parameters.Add("@IterationPath", System.Data.SqlDbType.VarChar).Value = obj.TfsIterationPath ?? "";
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
                        cmdInsertReleaseProject.Parameters.Add("@ReleaseId", System.Data.SqlDbType.Int).Value = obj.Id;
                        cmdInsertReleaseProject.Parameters.Add("@ProjectId", System.Data.SqlDbType.Int).Value = 0;
                        cmdInsertReleaseProject.CommandType = System.Data.CommandType.StoredProcedure;

                        foreach (var proj in obj.Projects)
                        {
                            cmdInsertReleaseProject.Parameters["@ProjectId"].Value = proj.Id;
                            cmdInsertReleaseProject.ExecuteNonQuery();
                        }
                    }
                }
                var rel = this.GetRelease(newId);

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

        public int Delete(int id)
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            int amount = 0;
            try
            {
                using (conn)
                {
                    conn.Open();

                    // Remove Child phases
                    var cmdChild = new SqlCommand(string.Format("Select * from Phases where ParentId = {0}", id), conn);
                    using (var reader = cmdChild.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            var cmdPhases = new SqlCommand(string.Format("Delete from Phases where Id = {0}", reader["Id"].ToString()), conn);
                            amount += cmdPhases.ExecuteNonQuery();
                        }
                    }

                    // Remove Release
                    var cmdMain = new SqlCommand(string.Format("Delete from Phases where Id = {0}", id), conn);
                    amount += cmdMain.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                throw;
            }
            return amount;
        }

        public ReleaseModels.Release SaveMilestone(MilestoneInputModel obj)
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
                        cmdInserMilestoneDeliverable.Parameters.Add("@HoursRemaining", System.Data.SqlDbType.Int).Value = 0;
                        cmdInserMilestoneDeliverable.Parameters.Add("@InitialEstimate", System.Data.SqlDbType.Int).Value = 0;
                        cmdInserMilestoneDeliverable.Parameters.Add("@Owner", System.Data.SqlDbType.VarChar).Value = string.Empty;
                        cmdInserMilestoneDeliverable.Parameters.Add("@State", System.Data.SqlDbType.VarChar).Value = string.Empty;
                        cmdInserMilestoneDeliverable.CommandType = System.Data.CommandType.StoredProcedure;

                        foreach (var itm in obj.Deliverables)
                        {
                            cmdInserMilestoneDeliverable.Parameters["@DeliverableId"].Value = itm.Id;
                            cmdInserMilestoneDeliverable.Parameters["@HoursRemaining"].Value = itm.HoursRemaining;
                            cmdInserMilestoneDeliverable.Parameters["@InitialEstimate"].Value = itm.InitialHoursEstimate;
                            cmdInserMilestoneDeliverable.Parameters["@Owner"].Value = itm.Owner ?? "";
                            cmdInserMilestoneDeliverable.Parameters["@State"].Value = itm.State ?? "";

                            cmdInserMilestoneDeliverable.ExecuteNonQuery();
                        }
                    }

                }

                var rel = this.GetReleaseSummary(obj.PhaseId);
                this.GenerateStatusRecords(rel);
                return rel;

            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public void GenerateStatusRecords(ReleaseModels.Release rel)
        {
            // create status records when not existing baased on release configuration
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

        public ReleaseModels.Release UnAssignMilestone(MilestoneInputModel obj)
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            try
            {
                using (conn)
                {
                    conn.Open();

                    var cmd = new SqlCommand(string.Format("delete from PhaseMilestones where PhaseId = {0} AND MilestoneId = {1}", obj.PhaseId, obj.Id), conn);
                    var result = cmd.ExecuteNonQuery();

                }

                return this.GetRelease(obj.PhaseId);
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        // Is Milestone an entity of the Release aggregate root?
        protected List<ReleaseModels.Milestone> GetMilestonesForRelease(ReleaseModels.Release release, SqlConnection conn)
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

                    // completely renew the ProjectActivityStatuses for the Milestone Deliverables as set in the client app
                    var cmdDelCross = new SqlCommand(string.Format("DELETE FROM MilestoneStatus WHERE ReleaseId = {0} AND MilestoneId = {1} AND DeliverableId = {2} AND ProjectId = {3}", obj.ReleaseId, obj.MilestoneId, obj.DeliverableId, obj.ProjectId), conn);
                    cmdDelCross.ExecuteNonQuery();

                    foreach (var itm in obj.ActivityStatuses)
                    {
                        //cmd.Parameters["@ProjectId"].Value = itm.ProjectId;
                        cmd.Parameters["@ActivityId"].Value = itm.ActivityId;
                        cmd.Parameters["@HoursRemaining"].Value = itm.HoursRemaining;

                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }
    }
}