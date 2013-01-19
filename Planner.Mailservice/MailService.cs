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
            
            _timer_Elapsed(null, null);
            _timer.Elapsed += new ElapsedEventHandler(_timer_Elapsed);
            // milliseconds
            _timer.Interval = _servicePollInterval;
            _timer.AutoReset = true;
            _timer.Enabled = true;
            _timer.Start();
        }

        void _timer_Elapsed(object sender, ElapsedEventArgs e)
        {
            try
            {
                // DO THE WORK
                throw new Exception("FOUT!");
            }
            catch (Exception ex)
            {
                eventLog1.WriteEntry(ex.Message);
            }
        }

        protected override void OnStop()
        {
            eventLog1.WriteEntry("MND MailService stopped");
            _timer.Stop();
        }
    }
}
