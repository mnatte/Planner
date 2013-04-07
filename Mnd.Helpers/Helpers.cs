using System;
using System.Collections.Generic;
using System.Linq;

namespace Mnd.Helpers
{
    public class XYPoint
    {
        public int X;
        public double Y;
    }

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

    public static class MathHelpers
    {
        public static List<XYPoint> GenerateLinearBestFit(List<XYPoint> points, out double a, out double b)
        {
            int numPoints = points.Count;
            double meanX = points.Average(point => point.X);
            double meanY = points.Average(point => point.Y);

            double sumXSquared = points.Sum(point => point.X * point.X);
            double sumXY = points.Sum(point => point.X * point.Y);

            a = (sumXY / numPoints - meanX * meanY) / (sumXSquared / numPoints - meanX * meanX);
            b = (a * meanX - meanY);

            double a1 = a;
            double b1 = b;

            return points.Select(point => new XYPoint() { X = point.X, Y = a1 * point.X - b1 }).ToList();
        }
    }
}