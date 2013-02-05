using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mnd.Planner.Domain.Persistence
{
    public class ReleaseProgressReport
    {
        public List<ArtefactActivityProgressReport> ArtefactStatuses { get; set; }
    }

    public class ArtefactActivityProgressReport
    {
        public string Release { get; set; }
        public string Milestone { get; set; }
        public DateTime StatusDate { get; set; }
        public string Artefact { get; set; }
        public int HoursRemaining { get; set; }
    }

}
