using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MvcApplication1.Models
{
    public class PeriodInputModel
    {
        public string Title { get; set; }
        public string Descr { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
    }
}