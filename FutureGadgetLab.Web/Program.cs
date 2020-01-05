using System;
using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;

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
            CreateWebHostBuilder(args).Build().Run();
        }

        /// <summary>
        /// Creates the host for the web application.
        /// </summary>
        /// <param name="args">Application arguments.</param>
        /// <returns>A web host.</returns>
        public static IWebHostBuilder CreateWebHostBuilder(string[] args)
        {
            var hostBuilder = WebHost.CreateDefaultBuilder(args)
                .UseStartup<Startup>()
                .ConfigureKestrel((context, options) =>
                {
                    // Set properties and call methods on options
                });

            // Enable Azure Appservices Integration for logging only when deployed on Azure
            var regionName = Environment.GetEnvironmentVariable("REGION_NAME");
            if (regionName != null)
            {
                hostBuilder.UseAzureAppServices();
            }

            // Enable Azure Application Insights
            hostBuilder.UseApplicationInsights();

            return hostBuilder;
        }
    }
}
