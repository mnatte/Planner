using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.Mail;
using Mnd.Domain.Roles;

namespace Mnd.Domain
{
    public class AwesomeNoteWriter : RCueItemUploader
    {
        EvernoteMailer _evernoteMailer;

        public AwesomeNoteWriter()
        {
            _evernoteMailer = new EvernoteMailer();
        }

        public void UploadCueItem(CueItem item, string location)
        {
            var itm = AwesomeNoteItem.Create(item.Title, item.Date, item.Time, item.Content, location);
            _evernoteMailer.CreateEvernoteItem(itm.Title, itm.Content, itm.Notebook);
        }
    }
}
