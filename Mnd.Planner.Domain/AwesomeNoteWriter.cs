using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.Planner.Domain.Roles;
using Mnd.Mail;
using Mnd.Domain;

namespace Mnd.Planner.Domain
{
    public class AwesomeNoteWriter : RVisualCueCreator
    {
        EvernoteMailer _evernoteMailer;

        public AwesomeNoteWriter()
        {
            _evernoteMailer = new EvernoteMailer();
        }

        public void UploadItem(string title, DateTime date, string time, string content, string notebook)
        {
            var item = AwesomeNoteItem.Create(title, date, time, content, notebook);
            _evernoteMailer.UploadAwesomeNoteItem(item);
        }
    }
}
