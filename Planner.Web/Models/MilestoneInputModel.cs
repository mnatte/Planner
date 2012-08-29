using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MvcApplication1.DataAccess;

namespace MvcApplication1.Models
{
    public class MilestoneInputModel : IBasicCrudUsable
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string Time { get; set; }
        public string Date { get; set; }
        public int PhaseId { get; set; }
        public List<MvcApplication1.Models.ReleaseModels.Deliverable> Deliverables { get; set; }
    }
}