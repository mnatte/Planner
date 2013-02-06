using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mnd.Roles.Planner
{
    public interface RVisualCueCreator
    {
        void UploadCueItem(CueItem item, string location);
    }
}
