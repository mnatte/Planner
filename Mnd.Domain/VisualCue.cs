using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mnd.Domain
{
    public class CueItem
    {
        public readonly string Title;
        public readonly DateTime Date;
        public readonly string Time;
        public readonly string Content;

        public CueItem(string title, DateTime date, string time, string content)
        {
            this.Title = title;
            this.Date = date;
            this.Time = time;
            this.Content = content;
        }
    }
}
