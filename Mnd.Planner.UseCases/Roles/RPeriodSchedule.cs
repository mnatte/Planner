using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.Planner.Domain.Roles;
using Mnd.Planner.Domain;
using System.Data.SqlClient;
using System.Data;

namespace Mnd.Planner.UseCases.Roles
{
    // TODO: add to repositories
    public static class RPeriodScheduleImplementations
    {
        /// <summary>
        /// Update start and end date
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        public static void Reschedule(this RPeriodSchedule evt, DateTime startDate, DateTime endDate)
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            try
            {
                using (conn)
                {
                    conn.Open();

                    var cmd = new SqlCommand("sp_update_phase_dates", conn);
                    cmd.Parameters.Add("@Id", System.Data.SqlDbType.Int).Value = evt.Id;
                    cmd.Parameters.Add("@StartDate", System.Data.SqlDbType.DateTime).Value = startDate;
                    cmd.Parameters.Add("@EndDate", System.Data.SqlDbType.DateTime).Value = endDate;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.ExecuteNonQuery();
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
        public static Phase Save(this Period evt)
        {
            var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            var newId = 0;
            try
            {
                using (conn)
                {
                    conn.Open();

                    var cmd = new SqlCommand("sp_insert_period", conn);
                    cmd.Parameters.Add("@Title", System.Data.SqlDbType.VarChar).Value = evt.Title;
                    cmd.Parameters.Add("@StartDate", System.Data.SqlDbType.DateTime).Value = evt.StartDate;
                    cmd.Parameters.Add("@EndDate", System.Data.SqlDbType.DateTime).Value = evt.EndDate;
                    cmd.Parameters.Add("@Description", System.Data.SqlDbType.VarChar).Value = "";

                    var returnParameter = new SqlParameter("@NewId", SqlDbType.Int);
                    returnParameter.Direction = ParameterDirection.Output;
                    cmd.Parameters.Add(returnParameter);
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.ExecuteNonQuery();

                    newId = (int)returnParameter.Value;
                }
                return new Phase { Title = evt.Title, EndDate = evt.EndDate, StartDate = evt.StartDate, Id = newId };
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        /// <summary>
        /// Remove the phase from a release
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        public static void RemoveFromPlanning(this RMeetingSchedule evt, Release release)
        {
            //var conn = new SqlConnection("Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true");
            //try
            //{
            //    using (conn)
            //    {
            //        conn.Open();

            //        var cmd = new SqlCommand("sp_delete_meeting_planning", conn);
            //        cmd.Parameters.Add("@Id", System.Data.SqlDbType.Int).Value = evt.Id;
            //        cmd.Parameters.Add("@ReleaseId", System.Data.SqlDbType.DateTime).Value = release.Id;
            //        cmd.CommandType = System.Data.CommandType.StoredProcedure;

            //        cmd.ExecuteNonQuery();
            //    }
            //}
            //catch (Exception ex)
            //{
            //    throw;
            //}
        }
    }
}
