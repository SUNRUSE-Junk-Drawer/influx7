using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace SUNRUSE.Influx.Web.Persistence
{
    /// <summary>A <see cref="Program"/> created by an <see cref="Account"/>.</summary>
    public class Program : IdentifiableBase
    {
        /// <summary>The <see cref="Account"/> which created <see langword="this"/>.</summary>
        [Required]
        public virtual Account Creator { get; set; }

        /// <summary>The <see cref="Iteration"/>s of <see langword="this"/>.</summary>
        public virtual List<Iteration> Iterations { get; set; }
    }

    /// <summary>An <see langword="Iteration"/> of a <see langword="Program"/>.</summary>
    public class Iteration : IdentifiableBase
    {
        /// <summary>The <see cref="Program"/> <see langword="this"/> is an <see cref="Iteration"/> of.</summary>
        [Required]
        public virtual Program Program { get; set; }
    }
}