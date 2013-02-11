using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Mnd.DataAccess;

namespace Mnd.Planner.Domain.Persistence
{
    public class MeetingInputModel : IBasicCrudUsable
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Descr { get; set; }
        public string Objective { get; set; }
        
        // TODO: refactor to configuration role, enabling automatic creation of releases
        public string Moment { get; set; }

        // TODO: refactor to planning role, enabling customization and planning of releases
        public DateTime Date { get; set; }
        public string Time { get; set; }
    }
}