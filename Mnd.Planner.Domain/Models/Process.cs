using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.Planner.Domain.Roles;

namespace Mnd.Planner.Domain.Models
{
    public class Process : RSharedProcess
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string ShortName { get; set; }
        public string Description { get; set; }
        public string Type { get; set; }

        public bool IsShared { get; set; }
        public bool IsBatch { get; set; }
        public bool IsParallelContainer { get; set; }
        public bool IsParallelIdentical { get; set; }

        private List<Activity> _activities;
        public IList<Activity> Activities
        {
            get
            {
                if (_activities == null)
                    _activities = new List<Activity>();
                return _activities;
            }
        }

        private List<Deliverable> _input;
        public IList<Deliverable> Input
        {
            get
            {
                if (_input == null)
                    _input = new List<Deliverable>();
                return _input;
            }
        }

        private List<Deliverable> _output;
        public IList<Deliverable> Output
        {
            get
            {
                if (_output == null)
                    _output = new List<Deliverable>();
                return _output;
            }
        }
    }
}
