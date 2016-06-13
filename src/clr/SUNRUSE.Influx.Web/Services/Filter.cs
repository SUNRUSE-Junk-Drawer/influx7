using SUNRUSE.Influx.Web.Persistence;
using System;
using System.Collections.Generic;
using System.ComponentModel.Composition;
using System.Linq;
using System.Web;

namespace SUNRUSE.Influx.Web.Services
{
    /// <summary>Abstracts over commonly used queries.</summary>
    public interface IFilter
    {
        /// <summary>Filters a <see cref="IQueryable{TEntity}"/> by its <see cref="IdentifiableBase.Id"/>.</summary>
        /// <typeparam name="TEntity">The <see cref="IdentifiableBase"/> <see cref="Type"/> in use.</typeparam>
        /// <param name="entities">The set of <typeparamref name="TEntity"/>s to filter.</param>
        /// <param name="id">The <see cref="IdentifiableBase.Id"/> to filter <paramref name="entities"/> by.</param>
        /// <returns>The items in <paramref name="entities"/> with a <see cref="IdentifiableBase.Id"/> matching <paramref name="id"/>.</returns>
        IQueryable<TEntity> Id<TEntity>(IQueryable<TEntity> entities, Guid id) where TEntity : IdentifiableBase;
    }

    /// <inheritdoc />
    [Export(typeof(IFilter))]
    public sealed class Filter : IFilter
    {
        /// <inheritdoc />
        public IQueryable<TEntity> Id<TEntity>(IQueryable<TEntity> entities, Guid id) where TEntity : IdentifiableBase
        {
            return entities.Where(e => e.Id == id);
        }
    }
}