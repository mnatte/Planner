using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.Planner.Domain.Roles;
using Mnd.Planner.Domain.Models;

namespace Mnd.Planner.UseCases.Roles
{
    public static class RSharedProcessImplementations
    {
        /// <summary>
        /// Update start and end date
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        public static List<ValueStream> GetValueStreamsUsingThis(this RSharedProcess proc)
        {
            // TODO: retrieve value streams from repository
            return null;
        }
    }
}
