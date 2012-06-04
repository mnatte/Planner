using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace MvcApplication1.Controllers
{
    public interface IBasicCrudUsable
    {
        /// <summary>
        /// Identifier used which maps to Id field in database table
        /// </summary>
        int Id { get; set; }
    }
}
