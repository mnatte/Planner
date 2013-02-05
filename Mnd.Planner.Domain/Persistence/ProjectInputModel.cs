﻿using System;
using System.Collections.Generic;
using System.Linq;

namespace Mnd.Planner.Domain.Persistence
{
    public class ProjectInputModel
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Descr { get; set; }
        public string TfsDevBranch { get; set; }
        public string TfsIterationPath { get; set; }
        public string ShortName { get; set; }
        public int ContactPersonId { get; set; }
    }
}