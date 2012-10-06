﻿using System;
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
        public List<ProjectInputModel> Projects { get; set; }
    }

    /* serialized graph:
		# {"id":130,"startDate":"06/10/2012","endDate":"06/10/2012","title":"Test","tfsIterationPath":""
		#	,"phases":[
		#		{"id":130,"startDate":"06/10/2012","endDate":"06/10/2012","title":"Test 1","tfsIterationPath":"","parentId":130},
		#		{"id":131,"startDate":"06/10/2012","endDate":"06/10/2012","title":"Test 2","tfsIterationPath":"kh","parentId":130}]
		#	,"projects":[
		#		{"id":4,"title":"TR Deployment","shortName":"TR","descr":"Rollout of Turkish market","tfsIterationPath":"NLBEESD-VFS-PM\\Release 9.3\\EU\\TR","tfsDevBranch":"Dev-2"}
		#	]
		#	,"milestones":[
		#		{"id":35,"time":"0:00","title":"New Milestone 1","description":"","phaseId":130,
		#			"deliverables":[
		#				{"id":2},{"id":3}
		#			]
		#		},{"id":36,"time":"0:00","title":"New Milestone 2","description":"","phaseId":130,
		#			"deliverables":[
		#				{"id":1},{"id":4},{"id":5}
		#			]
		#		}
		#	]
		#}
     */
     
    public class ReleaseConfigurationInputModel
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Descr { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public string TfsIterationPath { get; set; }
        public List<PhaseConfigurationInputModel> Phases { get; set; }
        public List<int> Projects { get; set; }
        public List<MilestoneConfigurationInputModel> Milestones { get; set; }
    }

    public class PhaseConfigurationInputModel
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Descr { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public string TfsIterationPath { get; set; }
    }

    public class ProjectConfigurationInputModel
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Descr { get; set; }
        public string ShortName { get; set; }
        public string TfsDevBranch { get; set; }
        public string TfsIterationPath { get; set; }
    }

    public class MilestoneConfigurationInputModel
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Descr { get; set; }
        public string Time { get; set; }
        public string Date { get; set; }
        public List<int> Deliverables { get; set; }
    }
}