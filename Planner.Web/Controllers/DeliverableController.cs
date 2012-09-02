﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data.SqlClient;
using MvcApplication1.Models;
using MvcApplication1.DataAccess;

namespace MvcApplication1.Controllers
{
    public class DeliverableController : BaseCrudController<ReleaseModels.Deliverable, DeliverableInputModel>
    {
        public DeliverableController() 
            :base(new DeliverableRepository()) 
        {}
    }
}