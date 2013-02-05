using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mnd.DataAccess
{
    public interface IBasicCrudUsable
    {
        /// <summary>
        /// Identifier used which maps to Id field in database table
        /// </summary>
        int Id { get; set; }
    }
}
