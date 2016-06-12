using Microsoft.VisualStudio.TestTools.UnitTesting;
using SUNRUSE.Influx.Web.Services;
using SUNRUSE.Influx.Web.Persistence;

namespace SUNRUSE.Influx.Web.Unit.ServicesUnit
{
    [TestClass]
	public sealed class ContextUnit : ComposedTestClassBase
	{
		[TestMethod]
		public void SetRetrievesSpecifiedSet()
		{
            var instance = Container.GetExportedValue<IDatabaseFactory>().Create();
            var concrete = instance as Context;
			Assert.AreSame(concrete.Programs, instance.Set<Program>());
		}
	}
}
