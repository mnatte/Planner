﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using Microsoft.Web.Mvc;

namespace Mnd.Planner.Web
{
    // Note: For instructions on enabling IIS6 or IIS7 classic mode, 
    // visit http://go.microsoft.com/?LinkId=9394801

    public class MvcApplication : System.Web.HttpApplication
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            // TODO: have clearer way of accessing of single resource assignments
            routes.MapRoute(
                "ResourceAssignmentsByResource", // Route name
                "ResourceAssignment/Assignments/{resourceId}", // URL with parameters
                new { controller = "ResourceAssignment", action = "GetAssignmentsByResourceId", param1 = UrlParameter.Optional } // Parameter defaults
            );
            routes.MapRoute(
                "SaveResourceAssignment", // Route name
                "Resource/Assignments/Save", // URL with parameters
                new { controller = "ResourceAssignment", action = "SaveAssignment", param1 = UrlParameter.Optional } // Parameter defaults
            );
            routes.MapRoute(
                "ScheduleMilestone", // Route name
                "Release/Milestone/Schedule", // URL with parameters
                new { controller = "Release", action = "ScheduleMilestone", param1 = UrlParameter.Optional } // Parameter defaults
            );
            routes.MapRoute(
                "ReleaseProgress", // Route name
                "Release/Progress/Milestone/{phaseId}/{milestoneId}", // URL with parameters
                new { controller = "Release", action = "GetReleaseProgress", param1 = UrlParameter.Optional } // Parameter defaults
            );
            routes.MapRoute(
                "SchedulePhase", // Route name
                "Release/Phase/Schedule", // URL with parameters
                new { controller = "Release", action = "SchedulePhase", param1 = UrlParameter.Optional } // Parameter defaults
            );
            routes.MapRoute(
               "ReleasePerformance", // Route name
               "Release/Performance/{releaseId}", // URL with parameters
               new { controller = "Release", action = "GetProcessPerformance", param1 = UrlParameter.Optional } // Parameter defaults
           );
            routes.MapRoute(
               "VisualCuesGates", // Route name
               "Release/Process/{amountDays}", // URL with parameters
               new { controller = "Release", action = "CreateVisualCuesForGates", param1 = UrlParameter.Optional } // Parameter defaults
           );
            routes.MapRoute(
               "VisualCuesAbsences", // Route name
               "Resource/Absences/ComingDays/{amountDays}", // URL with parameters
               new { controller = "Resource", action = "CreateVisualCuesForAbsences", param1 = UrlParameter.Optional } // Parameter defaults
           );
            routes.MapRoute(
                "RemoveAssignmentReturnRelease", // Route name
                "Resource/Release/UnAssign", // URL with parameters
                new { controller = "Resource", action = "UnAssignAndReturnRelease", param1 = UrlParameter.Optional } // Parameter defaults
            );
            routes.MapRoute(
                "PlanAssignmentReturnRelease", // Route name
                "Resource/Release/Plan", // URL with parameters
                new { controller = "Resource", action = "PlanAndReturnRelease", param1 = UrlParameter.Optional } // Parameter defaults
            );
            routes.MapRoute(
               "PlanMultipleResourcesReturnRelease", // Route name
               "Resource/Release/PlanMultiple", // URL with parameters
               new { controller = "Resource", action = "PlanMultipleAndReturnRelease", param1 = UrlParameter.Optional } // Parameter defaults
           );
            routes.MapRoute(
               "PlanContinuingProcessAssignment", // Route name
               "Resource/Process/Plan", // URL with parameters
               new { controller = "Resource", action = "PlanContinuingProcessAssignmentAndReturnResource", param1 = UrlParameter.Optional } // Parameter defaults
           );
            routes.MapRoute(
                "MailPlanning", // Route name
                "Resource/Assignments/Mail", // URL with parameters
                new { controller = "Resource", action = "MailPlanning", param1 = UrlParameter.Optional } // Parameter defaults
            );
            routes.MapRoute(
                "ResourceAssignments", // Route name
                "ResourceAssignment/Assignments/{phaseId}/{projectId}", // URL with parameters
                new { controller = "ResourceAssignment", action = "GetAssignmentsByPhaseIdAndProjectId", param1 = UrlParameter.Optional, param2 = UrlParameter.Optional } // Parameter defaults
            );
            routes.MapRoute(
                "ResourceAssignmentsForDeliverable", // Route name
                "ResourceAssignment/Assignments/{phaseId}/{projectId}/{milestoneId}/{deliverableId}", // URL with parameters
                new { controller = "ResourceAssignment", action = "GetAssignmentsByPhaseIdAndProjectIdAndMilestoneIdAndDeliverableId", param1 = UrlParameter.Optional, param2 = UrlParameter.Optional, param3 = UrlParameter.Optional, param4 = UrlParameter.Optional } // Parameter defaults
            );
            routes.MapRoute(
                "ResourceAssignmentsForRelease", // Route name
                "ResourceAssignment/Assignments/Release/{phaseId}", // URL with parameters
                new { controller = "ResourceAssignment", action = "GetAssignmentsByPhaseId", param1 = UrlParameter.Optional } // Parameter defaults
            );
            routes.MapRoute(
                "EnvironmentsPlanning", // Route name
                "Environment/Planning", // URL with parameters
                new { controller = "Environment", action = "GetEnvironmentsWithPlanning", param1 = UrlParameter.Optional } // Parameter defaults
            );
             routes.MapRoute(
                "Versions", // Route name
                "Environment/Versions", // URL with parameters
                new { controller = "Environment", action = "GetAllVersions", param1 = UrlParameter.Optional } // Parameter defaults
            );
             routes.MapRoute(
                 "Environments", // Route name
                 "Environment/All", // URL with parameters
                 new { controller = "Environment", action = "GetItems", param1 = UrlParameter.Optional } // Parameter defaults
             );
             routes.MapRoute(
                 "PlanEnvironment", // Route name
                 "Environment/Plan", // URL with parameters
                 new { controller = "Environment", action = "AddAssignment", param1 = UrlParameter.Optional } // Parameter defaults
             );
             routes.MapRoute(
                  "UnAssignEnvironment", // Route name
                  "Environment/Plan/UnAssign", // URL with parameters
                  new { controller = "Environment", action = "RemoveAssignment", param1 = UrlParameter.Optional } // Parameter defaults
              );
             routes.MapRoute(
                   "GetProcesses", // Route name
                   "Process", // URL with parameters
                   new { controller = "Process", action = "GetItems", param1 = UrlParameter.Optional } // Parameter defaults
               );
             routes.MapRoute(
                    "SaveProcess", // Route name
                    "Process/Save", // URL with parameters
                    new { controller = "Process", action = "Save", param1 = UrlParameter.Optional } // Parameter defaults
                );
             routes.MapRoute(
                    "DeleteProcess", // Route name
                    "Process/Delete/{id}", // URL with parameters
                    new { controller = "Process", action = "Delete", param1 = UrlParameter.Optional } // Parameter defaults
                );
            routes.MapRoute(
                "Default", // Route name
                "{controller}/{action}/{id}", // URL with parameters
                new { controller = "Home", action = "Index", id = UrlParameter.Optional } // Parameter defaults
            );
        }

        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            RegisterRoutes(RouteTable.Routes);
            ValueProviderFactories.Factories.Add(new JsonValueProviderFactory());

            //find the default JsonVAlueProviderFactory
            JsonValueProviderFactory jsonValueProviderFactory = null;

            foreach (var factory in ValueProviderFactories.Factories)
            {
                if (factory is JsonValueProviderFactory)
                {
                    jsonValueProviderFactory = factory as JsonValueProviderFactory;
                }
            }

            //remove the default JsonVAlueProviderFactory
            if (jsonValueProviderFactory != null) ValueProviderFactories.Factories.Remove(jsonValueProviderFactory);

            //add the custom one
            ValueProviderFactories.Factories.Add(new CustomJsonValueProviderFactory());
        }
    }
}