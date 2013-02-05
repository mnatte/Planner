using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mnd.Planner.Domain
{
    public class ResourceSnapshot
    {
        public int Id { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastName { get; set; }
        public string Initials { get; set; }
        public string Email { get; set; }
        public string PhoneNumber { get; set; }
        public string DisplayName { get { return string.Format("{0} {1} {2}", this.FirstName, this.MiddleName ?? "", this.LastName); } }
    }
}
