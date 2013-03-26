using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace Mnd.Domain
{
    [Serializable]
    public class ProcessException : System.Exception
    {
        public ProcessException(string errorMessage)
            : base(errorMessage)
        {

        }


        public ProcessException(string errorMessage, System.Exception innerExc)
            : base(errorMessage, innerExc)
        {

        }

        protected ProcessException(SerializationInfo si, StreamingContext sc)
            : base(si, sc)
        {

        }

        public ProcessException()
            : base()
        {
        }
    }
}
