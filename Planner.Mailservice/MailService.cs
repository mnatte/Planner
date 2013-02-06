using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.ServiceProcess;
using System.Text;
using System.Timers;
using Mnd.Mail;
using Mnd.Helpers;
using Mnd.Planner.Domain.Persistence;
using Mnd.Planner.Domain.Repositories;
using Mnd.Planner.UseCases;
using Mnd.Planner.Domain;
using Mnd.Domain;

namespace Mnd.Planner.Mailservice
{
    public partial class MailService : ServiceBase
    {
        private Timer _timer = new Timer();
        private double _servicePollInterval;
        private MailSender _mailer = new MailSender();

        public MailService()
        {
            InitializeComponent();
            _servicePollInterval = 10000;

            eventLog1.Source = "MND MailService";
            eventLog1.Log = "MND";
        }

        protected override void OnStart(string[] args)
        {
            //_mailer.SendMail("mnatte@gmail.com", "MailService started", "");
            try
            {
                eventLog1.WriteEntry("MND MailService started");
            }
            catch (Exception ex1)
            {
                _mailer.SendMail("mnatte@gmail.com", "Exception in write to eventlog", ex1.Message);
            }
            
            _timer.Elapsed += new ElapsedEventHandler(_timer_Elapsed);
            // milliseconds
            _timer.Interval = _servicePollInterval;
            _timer.AutoReset = true;
            _timer.Enabled = true;
            _timer.Start();
        }

        void _timer_Elapsed(object sender, ElapsedEventArgs e)
        {
            this.CreateAgendaItems();
            this.SendStatusMail();
        }

        void SendStatusMail()
        {
            try
            {
                var uc = new EmailMilestoneStatuses("martijn.natte@consultant.vfsco.com", 30);
                uc.Execute();
            }
            catch (Exception ex)
            {
                eventLog1.WriteEntry(ex.Message, EventLogEntryType.Error);
            }
        }

        void CreateAgendaItems()
        {
            try
            {
                var uc = new CreateVisualCuesForGates(30, new AwesomeNoteWriter());
                uc.Execute();
            }
            catch (Exception ex)
            {
                eventLog1.WriteEntry(ex.Message, EventLogEntryType.Error);
            }
        }

        protected override void OnStop()
        {
            eventLog1.WriteEntry("MND MailService stopped");
            _timer.Stop();
        }
    }
}
