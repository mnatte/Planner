using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.Domain;
using Mnd.Domain.Roles;

namespace Mnd.Planner.UseCases.Roles
{
    public static class RCueItemUploaderImplementations
    {
        /// <summary>
        /// creates visual cue in Awesomenote "Work" notebook
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        public static void CreateVisualCue(this RCueItemUploader creator, CueItem itemToCue)
        {
            creator.UploadCueItem(itemToCue, "Work");
        }
    }
}
