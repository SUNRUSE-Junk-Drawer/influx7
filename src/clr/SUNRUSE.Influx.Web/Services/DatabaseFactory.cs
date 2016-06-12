using SUNRUSE.Influx.Web.Persistence;
using System;
using System.Collections.Generic;
using System.ComponentModel.Composition;
using System.Linq;
using System.Web;

namespace SUNRUSE.Influx.Web.Services
{
    /// <summary>Provides new database contexts.</summary>
    public interface IDatabaseFactory
    {
        /// <summary>Creates and returns a new <see cref="IContext"/> instance.</summary>
        /// <returns>The created <see cref="IContext"/> instance.</returns>
        IContext Create();
    }

    /// <inheritdoc />
    [Export(typeof(IDatabaseFactory))]
    public sealed class DatabaseFactory : IDatabaseFactory
    {
        /// <inheritdoc />
        public IContext Create()
        {
            return new Context();
        }
    }
}