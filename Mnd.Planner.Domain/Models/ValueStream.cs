using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mnd.Planner.Domain.Models
{
    public class ValueStream
    {
        public int Id { get; set; }
        public Product Product { get; set; }
        public int CustomerDemand { get; set; }
        public int AvailableTime { get; set; }
        public TimeCurrencyEnum TimeCurrency { get; set; }

        private List<Process> _processes;
        public IList<Process> Processes
        {
            get
            {
                if (_processes == null)
                    _processes = new List<Process>();
                return _processes;
            }
        }
    }
}
