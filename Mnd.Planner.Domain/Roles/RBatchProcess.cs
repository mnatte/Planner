using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.Planner.Domain.Models;

namespace Mnd.Planner.Domain.Roles
{
    public interface RBatchProcess
    {
        int Id { get; }
        string Title { get; }
        IList<Activity> Activities { get; }
        IList<Deliverable> Input { get; }
        IList<Deliverable> Output { get; }
    }
}
