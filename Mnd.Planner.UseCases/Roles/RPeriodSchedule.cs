using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.Planner.Domain.Roles;
using Mnd.Planner.Domain;
using System.Data.SqlClient;
using System.Data;
using Mnd.Planner.Domain.Repositories;

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
        public static Phase Reschedule(this RPeriodSchedule evt, DateTime startDate, DateTime endDate)
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
