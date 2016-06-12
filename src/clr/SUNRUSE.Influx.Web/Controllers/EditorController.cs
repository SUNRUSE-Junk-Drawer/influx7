using SUNRUSE.Influx.Web.Models;
using SUNRUSE.Influx.Web.Persistence;
using System.ComponentModel.Composition;
using System.Web.Mvc;

namespace SUNRUSE.Influx.Web.Controllers
{
    /// <summary>The actual IDE.  One <see cref="Program"/> is being edited at a time.</summary>
    [Export("EditorController", typeof(IController))]
    [PartCreationPolicy(CreationPolicy.NonShared)]
    public sealed class EditorController : Controller
    {
        /// <summary>Opens a new, blank <see cref="Program"/>.</summary>
        [HttpGet]
        [Route("")]
        public ActionResult New()
        {
            return View("Editor", new EditorModel { Code = "" });
        }
    }
}