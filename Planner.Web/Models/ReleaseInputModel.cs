using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MvcApplication1.Models
{
    public class ReleaseInputModel
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Descr { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public string TfsIterationPath { get; set; }
        public int ParentId { get; set; }
        public List<ReleaseInputModel> Phases { get; set; }
    }
}