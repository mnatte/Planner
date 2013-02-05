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
        EventLog _log;

        public EvernoteMailer(EventLog log)
        {
            _log = log;
        }

        public void CreateEvernoteItem(string subject, string body, string notebook)
        {
            _log.WriteEntry(subject);
            _log.WriteEntry(body);
            var subj = subject;
            if (!String.IsNullOrEmpty(notebook))
                subj += " @" + notebook;
            _mailSender.SendMail(_evernoteAddress, subj, body);
        }

        public void CreateEvernoteItem(string subject, string body)
        {
            this.CreateEvernoteItem(subject, body, null);
        }

        public void UploadAwesomeNoteItem(AwesomeNoteItem item)
        {
            this.CreateEvernoteItem(item.Title, item.Content, item.Notebook);
        }
    }
}
