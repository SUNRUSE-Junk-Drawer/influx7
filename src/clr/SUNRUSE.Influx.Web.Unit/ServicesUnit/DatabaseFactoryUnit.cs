using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SUNRUSE.Influx.Web.Services;
using SUNRUSE.Influx.Web.Persistence;

namespace SUNRUSE.Influx.Web.Unit.ServicesUnit
{
	[TestClass]
	public sealed class DatabaseFactoryUnit : ComposedTestClassBase
	{
		[TestMethod]
		public void CreatesAndReturnsAnInstance()
		{
			var instance = Container.GetExportedValue<IDatabaseFactory>().Create();
			Assert.IsNotNull(instance);
			Assert.IsInstanceOfType(instance, typeof(Context));
		}

		[TestMethod]
		public void EachCallCreatesANewInstance()
		{
			var factory = Container.GetExportedValue<IDatabaseFactory>();
			Assert.AreNotSame(factory.Create(), factory.Create());
		}
	}
}
