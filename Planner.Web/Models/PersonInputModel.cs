using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MvcApplication1.Controllers;

namespace MvcApplication1.Models
{
    public class PersonInputModel : IBasicCrudUsable
    {
        public int Id { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastName { get; set; }
        public string Initials { get; set; }
        public string Email { get; set; }
        public string PhoneNumber { get; set; }
        public int HoursPerWeek { get; set; }
        public int FunctionId { get; set; }
        public int CompanyId { get; set; }
    }
}