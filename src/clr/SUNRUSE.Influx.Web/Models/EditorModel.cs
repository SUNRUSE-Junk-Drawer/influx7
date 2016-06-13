using SUNRUSE.Influx.Web.Controllers;
using SUNRUSE.Influx.Web.Persistence;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SUNRUSE.Influx.Web.Models
{
    /// <summary>An editor shown via <see cref="EditorController"/>.</summary>
    public sealed class EditorModel
    {
        /// <summary>The current <see cref="Iteration"/>'s <see cref="Iteration.Title"/>.</summary>
        public string Title { get; set; }

        /// <summary>The current <see cref="Iteration"/>'s <see cref="Iteration.Code"/>.</summary>
        public string Code { get; set; }
    }
}