using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net.Mail;
using System.Diagnostics;

namespace Mnd.Mail
{
    public class EvernoteMailer
    {
        string _evernoteAddress = "mnatte.ee42b16@m.evernote.com";
        MailSender _mailSender = new MailSender();
        EvernoteItemCreator _itemCreator = new EvernoteItemCreator();
        EventLog _log;

        public EvernoteMailer(EventLog log)
        {
            _log = log;
        }

        public void CreateEvernoteItem(string title, DateTime date, string time)
        {
            var msg = _itemCreator.CreateEvernoteMessage(title, date, time);
            _log.WriteEntry(msg.Subject);
            _log.WriteEntry(msg.Body);
            _mailSender.SendMail(_evernoteAddress, msg.Subject, msg.Body);
        }
    }

    public class EvernoteItemCreator
    {
        public string Style = "| Style : Background0, Font0, Size16 |";
        public string Date { get; private set; }
        public Dictionary<int, string> Months = new Dictionary<int, string>();

        public EvernoteItemCreator()
        {
            this.Months.Add(1, "Jan");
            this.Months.Add(2, "Feb");
            this.Months.Add(3, "Mar");
            this.Months.Add(4, "Apr");
            this.Months.Add(5, "May");
            this.Months.Add(6, "Jun");
            this.Months.Add(7, "Jul");
            this.Months.Add(8, "Aug");
            this.Months.Add(9, "Sep");
            this.Months.Add(10, "Oct");
            this.Months.Add(11, "Nov");
            this.Months.Add(12, "Dec");
        }

        public MailMessage CreateEvernoteMessage(string title, DateTime date, string time)
        {
            //var hrs = time.Substring(0, 2);
            //var mins = time.Substring(3, 2);
            var a = time.Split(':');
            var dt = new DateTime(date.Year, date.Month, date.Day, int.Parse(a[0]), int.Parse(a[1]), 0);

            var month = this.Months[date.Month];

            this.Date = string.Format("| To-do : Incomplete | Due date : {0} {1}, {2}, {3} | Alarm: On-Time,1 |", month, date.Day, date.Year, string.Format("{0:t}", dt));
            var msg = new MailMessage { Subject = title, Body = this.Style + "\n" + this.Date };

            return msg;
        }
    }
}
