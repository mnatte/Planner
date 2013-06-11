using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.DataAccess;

namespace Mnd.Planner.Domain.Persistence
{
    public class EnvironmentInputModel : IBasicCrudUsable
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string Location { get; set; }
        public string ShortName { get; set; }
    }
}
