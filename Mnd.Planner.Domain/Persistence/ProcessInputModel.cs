using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.DataAccess;

namespace Mnd.Planner.Domain.Persistence
{
    public class ProcessInputModel : IBasicCrudUsable
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string ShortName { get; set; }
    }
}
