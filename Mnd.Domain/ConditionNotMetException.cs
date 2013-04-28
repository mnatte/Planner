using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace Mnd.Domain
{
    [Serializable]
    public class ConditionNotMetException : System.Exception
    {
        public ConditionNotMetException(string errorMessage)
            : base(errorMessage)
        {

        }


        public ConditionNotMetException(string errorMessage, System.Exception innerExc)
            : base(errorMessage, innerExc)
        {

        }

        protected ConditionNotMetException(SerializationInfo si, StreamingContext sc)
            : base(si, sc)
        {

        }

        public ConditionNotMetException()
            : base()
        {
        }
    }
}
