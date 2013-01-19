using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Mnd.Planner.Data.DataAccess;

namespace Mnd.Planner.Data.Models
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

    public class AbsenceInputModel
    {
        public int Id { get; set; }
        public int PersonId { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public string Title { get; set; }
    }
}