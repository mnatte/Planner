using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MvcApplication1.Controllers;
using MvcApplication1.DataAccess;

namespace MvcApplication1.Models
{
    public class ResourceAssignmentInputModel : IBasicCrudUsable
    {
        public int Id { get; set ; }
        public int ResourceId { get; set; }
        public int ProjectId { get; set; }
        public int PhaseId { get; set; }
        public double FocusFactor { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public string Activity { get; set; }
    }
}