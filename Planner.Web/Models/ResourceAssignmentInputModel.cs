﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MvcApplication1.Controllers;

namespace MvcApplication1.Models
{
    public class ResourceAssignmentInputModel : IBasicCrudUsable
    {
        public int Id { get; set ; }
        public int ResourceId { get; set; }
        public int ProjectId { get; set; }
        public int PhaseId { get; set; }
        public double FocusFactor { get; set; }
    }
}