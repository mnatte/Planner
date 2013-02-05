using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.Planner.Domain.Roles;
using Mnd.Domain;

namespace Mnd.Planner.UseCases.Roles
{
    public static class RVisualCueCreatorImplementations
    {
        /// <summary>
        /// creates visual cue in Awesomenote "Work" notebook
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        public static void CreateVisualCue(this RVisualCueCreator creator, CueItem cue)
        {
            creator.UploadItem(cue.Title, cue.Date, cue.Time, cue.Content, "Work");
        }
    }
}
