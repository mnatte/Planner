using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mnd.Domain
{
    public static class GraphHelpers
    {
        public static List<XYPoint> GenerateLinearBestFit(List<XYPoint> points, out double a, out double b)
        {
            int numPoints = points.Count;
            double meanX = points.Average(point => point.X);
            double meanY = points.Average(point => point.Y);

            double sumXSquared = points.Sum(point => point.X * point.X);
            double sumXY = points.Sum(point => point.X * point.Y);

            // divide SUM( (x - avgX) * (y - avgY) ) by SUM( (x - avgX) * (x - avgX) )
            a = (sumXY / numPoints - meanX * meanY) / (sumXSquared / numPoints - meanX * meanX);
            // determine intercept: avgY = (slope * avgX) + intercept -> intercept = -((slope * avgX) - avgY)
            b = (a * meanX - meanY);

            double a1 = a;
            double b1 = b;

            // formula best fitted line: amtHours = slope * amtDays + intercept
            return points.Select(point => new XYPoint() { X = point.X, Y = Math.Round(a1 * point.X - b1, 2) }).ToList();
        }

        public static List<XYPoint> GenerateNegativeLinearBestFit(List<XYPoint> points, out double a, out double b)
        {
            int numPoints = points.Count;
            double meanX = points.Average(point => point.X);
            double meanY = points.Average(point => point.Y);

            double sumXSquared = points.Sum(point => point.X * point.X);
            double sumXY = points.Sum(point => point.X * point.Y);

            // divide SUM( (x - avgX) * (y - avgY) ) by SUM( (x - avgX) * (x - avgX) )
            a = (sumXY / numPoints - meanX * meanY) / (sumXSquared / numPoints - meanX * meanX);
            // determine intercept: avgY = (slope * avgX) + intercept -> intercept = -((slope * avgX) - avgY)
            b = -((-a * meanX) - meanY);

            double a1 = -a;
            double b1 = b;

            // formula best fitted line: amtHours = slope * amtDays + intercept
            return points.Select(point => new XYPoint() { X = point.X, Y = Math.Round((a1 * point.X) + b1, 2) }).ToList();
        }
    }
}
