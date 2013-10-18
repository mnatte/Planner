using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.Planner.Domain.Roles;
using Mnd.Planner.Domain.Models;

namespace Mnd.Planner.UseCases.Roles
{
    public static class RParallelContainerProcessImplementations
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="proc"></param>
        /// <returns></returns>
        public static List<Process> GetChildProcesses(this RParallelContainerProcess proc)
        {
            // TODO: retrieve child proceses from repository
            return null;
        }
    }
}
