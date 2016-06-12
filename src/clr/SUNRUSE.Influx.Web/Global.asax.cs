using System;
using System.Collections.Generic;
using System.ComponentModel.Composition;
using System.ComponentModel.Composition.Hosting;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;
using System.Web.Mvc;
using System.Web.Routing;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity;
using System.Web.Optimization;

namespace SUNRUSE.Influx.Web
{
    /// <inheritdoc />
    public class Global : HttpApplication
    {
        /// <summary>Creates and returns a new <see cref="CompositionContainer"/> to be used by <see langword="this"/>.</summary>
        /// <returns>A new <see cref="CompositionContainer"/> to be used by <see langword="this"/>.</returns>
        public CompositionContainer CreateCompositionContainer()
        {
            var exportProvider = new CatalogExportProvider(new AssemblyCatalog(GetType().Assembly));
            var compositionContainer = new CompositionContainer(CompositionOptions.IsThreadSafe, exportProvider);
            exportProvider.SourceProvider = compositionContainer;
            return compositionContainer;
        }

        private CompositionContainer Container;

        /// <summary>Raised when <see langword="this"/> starts.</summary>
        /// <param name="sender">The <see cref="HttpApplicationFactory"/> which created <see langword="this"/>.</param>
        /// <param name="e">The <see cref="EventArgs"/> used when raising <see cref="Application_Start"/>.</param>
        protected void Application_Start(object sender, EventArgs e)
        {
            Container = CreateCompositionContainer();
            RouteTable.Routes.MapMvcAttributeRoutes();
            BundleTable.Bundles.Add(new StyleBundle("~/bundles/style").Include("~/Styles/*.css"));
        }

        /// <summary>Raised when <see langword="this"/> ends.</summary>
        /// <param name="sender">The <see cref="HttpApplicationFactory"/> which created <see langword="this"/>.</param>
        /// <param name="e">The <see cref="EventArgs"/> used when raising <see cref="Application_End"/>.</param>
        protected void Application_End(object sender, EventArgs e)
        {
            if (Container != null) Container.Dispose();
        }
    }
}