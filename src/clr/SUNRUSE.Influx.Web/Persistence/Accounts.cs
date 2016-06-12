using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SUNRUSE.Influx.Web.Persistence
{
    /// <summary>A user of the website.</summary>
    public class Account : IdentifiableBase
    {
        /// <summary>The <see cref="Program"/>s created by <see langword="this"/>.</summary>
        public virtual List<Program> Programs{ get;set;}
    }
}