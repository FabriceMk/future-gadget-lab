using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace FutureGadgetLab.Web.Areas.Api.Controllers
{
    /// <summary>
    /// Controller for Food as a Service (FaaS).
    /// </summary>
    [Route("api/food")]
    public class FoodController : BaseApiController
    {
        /// <summary>
        /// Serves a Sushi. Sushi as a Service (SaaS).
        /// </summary>
        /// <returns>An HTTP result.</returns>
        /// <response code="200">Returns a sushi.</response>
        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public IActionResult Get()
        {
            var result = "🍣🍣🍣🍣🍣🍣";

            return Ok(result);
        }

        /// <summary>
        /// Serves the ordered food item.
        /// </summary>
        /// <param name="id">The id of the food item to serve.</param>
        /// <returns>An HTTP result.</returns>
        /// <response code="200">Returns the ordered food item.</response>
        /// <response code="404">If the food item doesn't exist.</response>
        [HttpGet("{id}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public IActionResult Get(string id)
        {
            string result = string.Empty;

            switch (id)
            {
                case "sushi":
                    result = "🍣🍣🍣🍣🍣🍣"; break;
                case "hamburger":
                    result = "🍔🍔🍔🍔🍔🍔"; break;
            }

            if (string.IsNullOrEmpty(result))
            {
                return NotFound();
            }

            return Ok(result);
        }
    }
}
