using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mnd.Domain;

namespace Mnd.Planner.UseCases
{
    public class EmailComingAbsences : AbstractUseCase
    {
        int _amtDays;

        public EmailComingAbsences(int amtDays)
        {
            _amtDays = amtDays;
        }

        public override void Execute()
        {
            throw new NotImplementedException();
        }
    }
}
