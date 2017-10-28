using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace FutureGadgetLab.Web
{
    /// <summary>
    /// Bootstrap class.
    /// </summary>
    public class Program
    {
        /// <summary>
        /// Entry point of the application.
        /// </summary>
        /// <param name="args">Application arguments.</param>
        public static void Main(string[] args)
        {
            BuildWebHost(args).Run();
        }

        /// <summary>
        /// Creates the host for the web application.
        /// </summary>
        /// <param name="args">Application arguments.</param>
        public static IWebHost BuildWebHost(string[] args) {
            var hostBuilder = WebHost
                .CreateDefaultBuilder(args)
                .UseStartup<Startup>();

            // Enable Application Insights and Azure Appservices only when deployed
            var regionName = Environment.GetEnvironmentVariable("REGION_NAME");
            if (regionName != null)
            {
                hostBuilder.UseAzureAppServices();
                hostBuilder.UseApplicationInsights();
            }

            return hostBuilder.Build();
        }
    }
}
