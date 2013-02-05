using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mnd.Planner.Domain.Roles
{
    public interface RVisualCueCreator
    {
        void UploadItem(string title, DateTime date, string time, string content, string notebook);
    }
}
