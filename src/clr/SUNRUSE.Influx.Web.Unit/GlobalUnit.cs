using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Threading.Tasks;
using SUNRUSE.Influx.Web.Controllers;
using System.Collections.Generic;
using System.Linq;

namespace SUNRUSE.Influx.Web.Unit
{
    [TestClass]
    public sealed class GlobalUnit : ComposedTestClassBase
    {
        [TestMethod]
        public void GetContainerReturnsThreadSafeInstance()
        {
            Assert.AreEqual(1000, ParallelEnumerable.Range(0, 1000).Select(x => GetController<EditorController>()).Distinct().Count());
        }
    }
}