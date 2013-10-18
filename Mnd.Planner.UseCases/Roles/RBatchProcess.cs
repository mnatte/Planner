using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.Planner.Domain.Roles;
using Mnd.Planner.Domain.Models;

namespace Mnd.Planner.UseCases.Roles
{
    public static class RBatchProcessImplementations
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="proc"></param>
        /// <returns></returns>
        public static int BatchSize(this RBatchProcess proc)
        {
            // TODO: retrieve value streams from repository
            return 1;
        }
    }
}
