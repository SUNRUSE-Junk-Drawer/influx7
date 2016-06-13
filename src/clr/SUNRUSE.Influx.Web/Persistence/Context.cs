using System;
using System.Collections.Generic;
using System.ComponentModel.Composition;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;
using System.Web;

namespace SUNRUSE.Influx.Web.Persistence
{
    /// <summary>Mockable abstraction of <see cref="DbContext"/>.</summary>
    public interface IContext : IDisposable
    {
        /// <summary><see cref="DbContext.SaveChangesAsync()"/>.</summary>
        Task<int> SaveChangesAsync();

        /// <summary><see cref="DbContext.Set()"/>.</summary>
        IDbSet<TEntity> Set<TEntity>() where TEntity : class;
    }

    /// <inheritdoc />
    public class Context : DbContext, IContext
    {
        /// <summary>The <see cref="Program"/>s in the <see cref="Context"/>.</summary>
        /// <remarks>A starting point for Entity Framework.</remarks>
        public virtual DbSet<Program> Programs { get; set; }

        /// <inheritdoc />
        IDbSet<TEntity> IContext.Set<TEntity>()
        {
            return Set<TEntity>();
        }
    }

    /// <summary>Base class for records with an unique <see cref="Id"/>.</summary>
    public abstract class IdentifiableBase
    {
        /// <summary>The unique identifier of <see langword="this"/>.</summary>
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public Guid Id { get; set; } = Guid.NewGuid();
    }
}