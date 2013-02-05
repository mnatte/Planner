using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Mnd.DataAccess;

namespace Mnd.Planner.Domain.Persistence
{
    public class ActivityInputModel : IBasicCrudUsable
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
    }
}