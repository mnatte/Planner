﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MvcApplication1
{
    public static class Helpers
    {
        /// <summary>
        /// input: dd-mm-yyyy
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        public static DateTime ToDateTimeFromDutchString(this string str)
        {
            var splitString = str.Split('/');
            return new DateTime(int.Parse(splitString[2]), int.Parse(splitString[1]), int.Parse(splitString[0]));
        }
    }
}