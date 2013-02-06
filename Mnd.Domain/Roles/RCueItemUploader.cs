using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mnd.Domain.Roles
{
    // keep name basic since it is used on low-level classes. role implementation methods can have high-level names
    /// <summary>
    /// Uploads cue items
    /// </summary>
    public interface RCueItemUploader
    {
        void UploadCueItem(CueItem item, string location);
    }
}
