using System;
using Microsoft.AspNetCore.Mvc;

namespace FutureGadgetLab.Web.Areas.Api.Controllers
{
    /// <summary>
    /// Controller for heartbeat checks.
    /// </summary>
    [Area("api")]
    [Route("api/health")]
    public class HealthController : Controller
    {
        /// <summary>
        /// Heartbeat endpoint.
        /// </summary>
        /// <returns>An HTTP result.</returns>
        /// <response code="200">Returns a standard HTTP 200 result.</response>
        [HttpGet]
        public IActionResult Check()
        {
            return Ok();
        }
    }
}