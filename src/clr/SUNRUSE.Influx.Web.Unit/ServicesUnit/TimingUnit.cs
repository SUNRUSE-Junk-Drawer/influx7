using System;
using System.Text;
using System.Collections.Generic;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SUNRUSE.Influx.Web.Services;

namespace SUNRUSE.Influx.Web.Unit.ServicesUnit
{
	[TestClass]
	public sealed class TimingUnit : ComposedTestClassBase
	{
		[TestMethod]
		public void NowReturnsCurrentDateTimeInUTC()
		{
			var now = Container.GetExportedValue<ITiming>().Now;
			Assert.AreEqual(DateTimeKind.Utc, now.Kind);
			Assert.IsTrue(now > DateTime.Now.ToUniversalTime().AddSeconds(-10));
			Assert.IsTrue(now < DateTime.Now.ToUniversalTime().AddSeconds(10));
		}
	}
}
