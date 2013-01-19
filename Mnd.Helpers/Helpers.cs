using System;
using System.Collections.Generic;
using System.Linq;

namespace Mnd.Helpers
{
    public static class DateTimeHelpers
    {
        /// <summary>
        /// input: dd/mm/yyyy
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        public static DateTime ToDateTimeFromDutchString(this string str)
        {
            var splitString = str.Split('/');
            return new DateTime(int.Parse(splitString[2]), int.Parse(splitString[1]), int.Parse(splitString[0]));
        }

        /// <summary>
        /// output: dd/mm/yyyy
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        public static string ToDutchString(this DateTime date)
        {
            return string.Format("{0}/{1}/{2}", date.Day, date.Month, date.Year);
        }
    }
}