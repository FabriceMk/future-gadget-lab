using System;
using Microsoft.AspNetCore.Mvc;

namespace FutureGadgetLab.Web.Areas.Api.Controllers
{
    /// <summary>
    /// Controller for heartbeat checks.
    /// </summary>
    [Area("api")]
    [Route("api/[controller]")]
    public class HealthController : Controller
    {
        /// <summary>
        /// Heartbeat endpoint.
        /// </summary>
        /// <returns>An HTTP result.</returns>
        /// <response code="200">Returns the ordered food item.</response>
        [HttpGet]
        public IActionResult Check()
        {
            return Ok();
        }
    }
}