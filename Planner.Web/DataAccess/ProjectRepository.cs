using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MvcApplication1.Models;
using System.Data.SqlClient;

namespace MvcApplication1.DataAccess
{
    public class ProjectRepository
    {
        public ReleaseModels.Project GetProject(int id)
        {
            // add MultipleActiveResultSets=true to enable nested datareaders
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            ReleaseModels.Project p = null;

            using (conn)
            {
                conn.Open();

                // Release
                var cmd = new SqlCommand(string.Format("Select * from Projects where Id = {0}", id), conn);
                using (var reader = cmd.ExecuteReader())
                {
                    reader.Read();
                    p = new ReleaseModels.Project { Id = int.Parse(reader["Id"].ToString()), Title = reader["Title"].ToString(), Description = reader["Description"].ToString(), ShortName = reader["ShortName"].ToString(), TfsDevBranch = reader["TfsDevBranch"].ToString(), TfsIterationPath = reader["TfsIterationPath"].ToString() };
                }

                // Backlog
                /*var cmd3 = new SqlCommand(string.Format("Select i.BusinessId, i.ContactPerson, i.WorkRemaining, i.Title, i.State, p.Id AS ProjectId from TfsImport i INNER JOIN Phases r ON i.IterationPath LIKE r.TfsIterationPath + '%' INNER JOIN Projects p on i.IterationPath LIKE p.TfsIterationPath + '%' WHERE r.Id = {0}", id), conn);
                using (var reader = cmd3.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        var feature = new ReleaseModels.Feature { BusinessId = reader["BusinessId"].ToString(), ContactPerson = reader["ContactPerson"].ToString(), RemainingHours = int.Parse(reader["WorkRemaining"].ToString()), Title = reader["Title"].ToString(), Status = reader["State"].ToString() };

                        // find Project for Feature
                        ReleaseModels.Project project;
                        var cmd4 = new SqlCommand(String.Format("Select * from Projects where Id = {0}", reader["ProjectId"].ToString()), conn);
                        using (var reader2 = cmd4.ExecuteReader())
                        {
                            reader2.Read();
                            project = new ReleaseModels.Project { ShortName = reader2["ShortName"].ToString() };

                            // Resources
                            var team = new ReleaseModels.Team();
                            var cmd5 = new SqlCommand(String.Format("Select * from ReleaseResources where ReleaseId = {0} and ProjectId = {1}", id, reader["ProjectId"].ToString()), conn);
                            using (var reader3 = cmd5.ExecuteReader())
                            {
                                while (reader3.Read())
                                {
                                    var cmd6 = new SqlCommand(String.Format("Select * from Persons where Id = {0}", reader3["PersonId"].ToString()), conn);

                                    using (var reader4 = cmd6.ExecuteReader())
                                    {
                                        reader4.Read();
                                        // reader3 is used for FocusFactor since this is stored in ReleaseResources, the rest is from Persons
                                        var teamMember = new ReleaseModels.TeamMember { Initials = reader4["Initials"].ToString(), FocusFactor = double.Parse(reader3["FocusFactor"].ToString()), AvailableHoursPerWeek = int.Parse(reader4["HoursPerWeek"].ToString()) };

                                        var cmd7 = new SqlCommand(String.Format("Select * from Absences where PersonId = {0}", reader3["PersonId"].ToString()), conn);
                                        using (var reader5 = cmd7.ExecuteReader())
                                        {
                                            while (reader5.Read())
                                            {
                                                teamMember.PeriodsAway.Add(new ReleaseModels.Phase { Id = int.Parse(reader5["Id"].ToString()), EndDate = DateTime.Parse(reader5["EndDate"].ToString()), StartDate = DateTime.Parse(reader5["StartDate"].ToString()), Title = reader5["Title"].ToString() });
                                            }
                                        }
                                        team.TeamMembers.Add(teamMember);
                                    }
                                }
                            }
                            project.ProjectTeam = team;
                        }

                        feature.Project = project;
                        release.Backlog.Add(feature);
                    }
                }
                */
                conn.Close();
                return p;
            }
        }
    }
}