using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SUNRUSE.Influx.Web.Persistence;
using SUNRUSE.Influx.Web.Services;
using System.Linq;

namespace SUNRUSE.Influx.Web.Unit.ServicesUnit
{
    [TestClass]
    public sealed class FilterUnit : ComposedTestClassBase
    {
        public sealed class MockEntity : IdentifiableBase { }

        [TestMethod]
        public void ReturnsMatchingEntities()
        {
            var a = new MockEntity();
            var b = new MockEntity();
            var c = new MockEntity();
            var d = new MockEntity();

            CollectionAssert.AreEquivalent(new[] { b }, Container.GetExportedValue<IFilter>().Id(new AsyncEnumerableQuery<MockEntity>(new[] { a, b, c, d }), b.Id).ToArray());
        }
    }
}
