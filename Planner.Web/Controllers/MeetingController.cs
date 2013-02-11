using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Mnd.Mvc.Rest;
using Mnd.Planner.Domain.Models;
using Mnd.Planner.Domain.Persistence;
using Mnd.Planner.Domain.Repositories;

namespace Mnd.Planner.Web.Controllers
{
    public class MeetingController : BaseCrudController<Meeting, MeetingInputModel>
    {
        //
        // GET: /Meeting/

        public MeetingController() 
            :base(new MeetingRepository()) 
        {
        }

    }
}
