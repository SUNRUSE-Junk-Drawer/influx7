using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SUNRUSE.Influx.Web.Controllers;
using System.Web.Mvc;
using SUNRUSE.Influx.Web.Models;

namespace SUNRUSE.Influx.Web.Unit.ControllersUnit
{
    [TestClass]
    public sealed class EditorControllerUnit : ComposedTestClassBase
    {
        [TestMethod]
        public void NewInstanceCreatedForEachRequest()
        {
            Assert.AreNotSame(GetController<EditorController>(), GetController<EditorController>());
        }

        [TestMethod]
        public void NewOpensBlankEditor()
        {
            var result = GetController<EditorController>().New() as ViewResult;
            Assert.IsNotNull(result);
            Assert.AreEqual("Editor", result.ViewName);
            var model = result.Model as EditorModel;
            Assert.IsNotNull(model);
            Assert.AreEqual("", model.Code);
            Assert.AreEqual("Untitled Program", model.Title);
        }
    }
}
