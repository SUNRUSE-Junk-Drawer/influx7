using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.ComponentModel.Composition.Hosting;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;

namespace SUNRUSE.Influx.Web.Unit
{
    public abstract class ComposedTestClassBase
    {
        protected CompositionContainer Container { get; private set; }

        protected T GetController<T>() where T : class
        {
            return Container.GetExportedValue<IController>(typeof(T).Name) as T;
        }

        [TestInitialize]
        public void Initialize()
        {
            Container = new Global().CreateCompositionContainer();
        }

        [TestCleanup]
        public void Cleanup()
        {
            if (Container != null) Container.Dispose();
        }
    }
}
