using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MvcApplication1.Controllers;
using MvcApplication1.DataAccess;

namespace MvcApplication1.Models
{
    public class DeliverableInputModel : IBasicCrudUsable
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string Location { get; set; }
        public int OwnerId { get; set; }
        public string Format { get; set; }
        public int InitialHoursEstimate { get; set; }
        public int HoursRemaining { get; set; }
    }
}