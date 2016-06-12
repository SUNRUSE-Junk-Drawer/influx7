using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SUNRUSE.Influx.Web.Controllers;
using System.Web.SessionState;
using Rhino.Mocks;
using System.Web.Mvc;

namespace SUNRUSE.Influx.Web.Unit
{
    [TestClass]
    public sealed class MefControllerFactoryUnit : ComposedTestClassBase
    {
        [TestMethod]
        public void CreateControllerCreatesAndReturnsAnInstanceOfTheRequestedController()
        {
            var instance = new MefControllerFactory { Container = Container }.CreateController(null, "EditorController");
            Assert.IsNotNull(instance);
            Assert.IsInstanceOfType(instance, typeof(EditorController));
        }

        [TestMethod]
        public void CreateControllerReturnsNullWhenNotAController()
        {
            var instance = new MefControllerFactory { Container = Container }.CreateController(null, "IDatabaseFactory");
            Assert.IsNull(instance);
        }

        [TestMethod]
        public void CreateControllerReturnsNullWhenNoInstanceExists()
        {
            var instance = new MefControllerFactory { Container = Container }.CreateController(null, "NonexistentController");
            Assert.IsNull(instance);
        }

        [TestMethod]
        public void CreateControllerCreatesAndReturnsANewInstanceEachRequest()
        {
            var factory = new MefControllerFactory { Container = Container };
            Assert.AreNotSame(factory.CreateController(null, "EditorController"), factory.CreateController(null, "EditorController"));
        }

        [TestMethod]
        public void GetControllerSessionBehaviorReturnsDefault()
        {
            Assert.AreEqual(SessionStateBehavior.Default, new MefControllerFactory { Container = Container }.GetControllerSessionBehavior(null, "EditorController"));
        }

        [TestMethod]
        public void ReleaseControllerDoesNothing()
        {
            var mocks = new MockRepository();

            var instance = mocks.StrictMock<IController>();

            using (mocks.Record()) { }

            using (mocks.Playback())
            {
                new MefControllerFactory { Container = Container }.ReleaseController(instance);
            }
        }
    }
}
