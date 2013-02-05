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
        }

        void SendStatusMail()
        {
            try
            {
                // TODO: use sp_get_milestones_for_nextdays and retrieve deliverablestatuses to mail
                //throw new Exception("FOUT!");
                var repository = new MilestoneRepository();
                var milestones = repository.GetMilestonesForComingDays(30);
                var builder = new StringBuilder();
                //var projRep = new ProjectRepository();

                foreach (var ms in milestones)
                {
                    //var projects = projRep.GetConfiguredProjectsForRelease(ms.Release.Id);
                    builder.Append("\n***********************************************");
                    builder.Append(string.Format("\n{0} - {1} - {2} {3}:", ms.Release.Title, ms.Title, ms.Date.ToDutchString(), ms.Time));
                    var statuses = repository.GetActivityStatusForMilestones(ms);
                    builder.Append("\n----------------------------------------------");
                    foreach (var state in statuses)
                    {

                        builder.Append(string.Format("\n{0}: {1}", "Project", state.Project.Title));
                        builder.Append(string.Format("\n{0} - {1} - {2} hrs remaining", state.Deliverable.Title, state.Activity.Title, state.HoursRemaining));
                        builder.Append("\n----------------------------------------------");
                    }

                    builder.Append("\n***********************************************");
                    builder.Append("\n\n");

                }
                var content = builder.ToString();
                _mailer.SendMail("martijn.natte@consultant.vfsco.com", "Milestones coming up", content);

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
