using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SUNRUSE.Influx.Web.Persistence;

namespace SUNRUSE.Influx.Web.Unit.PersistenceUnit
{
    [TestClass]
    public sealed class IdentifiableBaseUnit : ComposedTestClassBase
    {
        public sealed class MockEntity : IdentifiableBase { }

        [TestMethod]
        public void CreatesAnUniqueIdentifierForEach()
        {
            Assert.AreNotEqual(new MockEntity().Id, new MockEntity().Id);
        }
    }
}
