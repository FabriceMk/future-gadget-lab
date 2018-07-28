using System;
using Microsoft.AspNetCore.Mvc;
using FluentAssertions;
using FutureGadgetLab.Web.Areas.Api.Controllers;
using Xunit;

namespace FutureGadgetLab.Web.Tests.Areas.Api.Controllers
{
    public class HealthControllerTests
    {
        [Fact]
        public void Check_ShouldReturnHttp200()
        {
            // Arrange
            var controller = new HealthController();

            // Act
            var response = controller.Check();

            // Assert
            response.Should().BeOfType<OkResult>();
        }
    }
}