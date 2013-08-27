using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Mnd.Mvc.Rest;
using Mnd.Planner.Domain.Models;
using Mnd.Planner.Domain.Persistence;
using Mnd.Planner.Domain.Repositories;
using Mnd.Planner.UseCases;
using Mnd.Planner.Domain;
using Mnd.Helpers;

namespace Mnd.Planner.Web.Controllers
{
    public class ProcessController : BaseCrudController<Mnd.Planner.Domain.Models.Process, ProcessInputModel>
    {
        public ProcessController()
            : base(new ProcessRepository())
        { }
        //
        // GET: /Environment/

        public ActionResult Index()
        {
            return View();
        }
    }
}
