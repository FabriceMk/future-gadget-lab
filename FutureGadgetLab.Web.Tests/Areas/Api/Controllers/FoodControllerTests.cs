using System;
using Microsoft.AspNetCore.Mvc;
using FluentAssertions;
using FutureGadgetLab.Web.Areas.Api.Controllers;
using Xunit;

namespace FutureGadgetLab.Web.Tests.Areas.Api.Controllers
{
    public class FoodControllerTests
    {
        [Fact]
        public void Get_ShouldReturnHttp200WithCorrectValue()
        {
            // Arrange
            var controller = new FoodController();

            // Act
            var response = controller.Get();

            // Assert
            response.Should().BeOfType<OkObjectResult>();
            response.As<OkObjectResult>().Value.Should().Be("🍣🍣🍣🍣🍣🍣");
        }
    }
}
