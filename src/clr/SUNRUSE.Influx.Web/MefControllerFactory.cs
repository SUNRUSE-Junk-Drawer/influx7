using System;
using System.Collections.Generic;
using System.ComponentModel.Composition.Hosting;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using System.Web.SessionState;

namespace SUNRUSE.Influx.Web
{
    /// <inheritdoc />
    public sealed class MefControllerFactory : IControllerFactory
    {
        /// <summary>The <see cref="CompositionContainer"/> to use to create <see cref="Container"/> instances.</summary>
        public CompositionContainer Container;

        /// <inheritdoc />
        public IController CreateController(RequestContext requestContext, string controllerName)
        {
            return Container.GetExportedValues<IController>(controllerName).SingleOrDefault();
        }

        /// <inheritdoc />
        public SessionStateBehavior GetControllerSessionBehavior(RequestContext requestContext, string controllerName)
        {
            return SessionStateBehavior.Default;
        }

        /// <inheritdoc />
        public void ReleaseController(IController controller) { }
    }
}