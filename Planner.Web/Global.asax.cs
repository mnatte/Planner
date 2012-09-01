using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using Microsoft.Web.Mvc;

namespace MvcApplication1
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
                "Default", // Route name
                "{controller}/{action}/{id}", // URL with parameters
                new { controller = "Home", action = "Index", id = UrlParameter.Optional } // Parameter defaults
            );
            routes.MapRoute(
                "ResourceAssignments", // Route name
                "ResourceAssignment/Assignments/{phaseId}/{projectId}", // URL with parameters
                new { controller = "ResourceAssignment", action = "GetAssignmentsByPhaseIdAndProjectId", param1 = UrlParameter.Optional, param2 = UrlParameter.Optional } // Parameter defaults
            );
        }

        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            RegisterRoutes(RouteTable.Routes);
            ValueProviderFactories.Factories.Add(new JsonValueProviderFactory());
        }
    }
}