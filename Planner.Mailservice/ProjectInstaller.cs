using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration.Install;
using System.Linq;
using System.Diagnostics;
using Mnd.Mail;
using System.Security.Permissions;


namespace Mnd.Planner.Mailservice
{
    [RunInstaller(true)]
    public partial class ProjectInstaller : System.Configuration.Install.Installer
    {
        private string _eventSource = "MND MailService";
        private string _eventLog = "MND";
        private MailSender _mailer = new MailSender();

        public ProjectInstaller()
        {
            InitializeComponent();
            //_mailer.SendMail("mnatte@gmail.com", "Test EventLog", "ProjectInstaller ctor");
        }

        [SecurityPermission(SecurityAction.Demand)]
        public override void Install(IDictionary stateSaver)
        {
            base.Install(stateSaver);

            if (!EventLog.SourceExists(_eventSource))
            {
                //_mailer.SendMail("mnatte@gmail.com", "Test EventLog", "MailServiceMnd does not exist");
                try
                {
                    EventLog.CreateEventSource(_eventSource, _eventLog);
                }
                catch (Exception ex)
                {
                    _mailer.SendMail("mnatte@gmail.com", "Test EventLog", ex.Message);
                }
            }
        }

        [SecurityPermission(SecurityAction.Demand)]
        public override void Uninstall(IDictionary savedState)
        {
            if (EventLog.SourceExists(_eventSource))
            {
                EventLog.DeleteEventSource(_eventSource);
                EventLog.Delete(_eventLog);
            }
            base.Uninstall(savedState);
        }
    }
}
