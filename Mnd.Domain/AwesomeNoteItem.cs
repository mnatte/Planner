using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mnd.Domain
{
    public class AwesomeNoteItem
    {
        private static string _style = "| Style : Background0, Font0, Size16 |";
        private static Dictionary<int, string> _months = new Dictionary<int, string>();

        /// <summary>
        /// The entry as displayed in Awesome note
        /// </summary>
        public string Title { get; private set; }

        /// <summary>
        /// The content of the item, including the footer that contains the date, time and alarm information for Awesomenote
        /// </summary>
        public string Content { get; private set; }



        private string _notebook { get; set; }
        /// <summary>
        /// The name of the Awesomenote notebook this item belongs to, e.g. 'Work' or 'Personal'
        /// </summary>
        public string Notebook 
        {
            get { return "[aNote] " + _notebook; }
        }

        static AwesomeNoteItem()
        {
            _months.Add(1, "Jan");
            _months.Add(2, "Feb");
            _months.Add(3, "Mar");
            _months.Add(4, "Apr");
            _months.Add(5, "May");
            _months.Add(6, "Jun");
            _months.Add(7, "Jul");
            _months.Add(8, "Aug");
            _months.Add(9, "Sep");
            _months.Add(10, "Oct");
            _months.Add(11, "Nov");
            _months.Add(12, "Dec");
        }

        public static AwesomeNoteItem Create(string title, DateTime date, string time, string content, string notebookName)
        {
            var a = time.Split(':');
            var dt = new DateTime(date.Year, date.Month, date.Day, int.Parse(a[0]), int.Parse(a[1]), 0);

            var month = _months[date.Month];

            var itemdate = string.Format("| To-do : Incomplete | Due date : {0} {1}, {2}, {3} | Alarm: On-Time,1 |", month, date.Day, date.Year, string.Format("{0:t}", dt));

            return new AwesomeNoteItem { Title = title, Content = content + "\n\n" + _style + "\n" + itemdate, _notebook = notebookName };
        }

        /// <summary>
        /// Creates an item intended for default notebook
        /// </summary>
        /// <param name="title"></param>
        /// <param name="date"></param>
        /// <param name="time"></param>
        /// <returns></returns>
        public static AwesomeNoteItem Create(string title, DateTime date, string time)
        {
            return Create(title, date, time, string.Empty, string.Empty);
        }

        public static AwesomeNoteItem Create(string title, DateTime date, string time, string notebookName)
        {
            return Create(title, date, time, string.Empty, notebookName);
        }
    }
}
