using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net.Mail;
using System.Net;

namespace Mnd.Mail
{
    public class MailSender
    {
        MailAddress _fromAddress;
        //MailAddress _toAddress;
        MailAddress _ccAddress;
        string _passWord;
        SmtpClient _smtpClient;

        public MailSender()
        {
            _fromAddress = new MailAddress("mnatte@gmail.com", "MND Planner");
            //_toAddress = new MailAddress("martijn.natte@consultant.vfsco.com", "Martijn Natté");
            _ccAddress = new MailAddress("mnatte@gmail.com", "Martijn Natté");
            _passWord = "yczronaitzlhooxr";
            _smtpClient =  new SmtpClient
                {
                    Host = "smtp.gmail.com",
                    Port = 587,
                    EnableSsl = true,
                    DeliveryMethod = SmtpDeliveryMethod.Network,
                    // ORDER IS CRUCIAL HERE! Credentials after UseDefaultCredentials
                    UseDefaultCredentials = false,
                    Credentials = new NetworkCredential(_fromAddress.Address, _passWord),
                    Timeout = 300000
                };
        }

        public void SendMail(string toAddress, string subject, string body, string[] extraRecipients)
        {
            using (var msg = new MailMessage(_fromAddress, new MailAddress(toAddress)) { Subject = subject, Body = body })
            {
                msg.CC.Add(_ccAddress);

                foreach(var address in extraRecipients)
                {
                    msg.To.Add(new MailAddress(address));
                }
                _smtpClient.Send(msg);
            }
        }

        public void SendMail(string toAddress, string subject, string body)
        {
           this.SendMail(toAddress, subject, body, new string[0]);
        }
    }
}
