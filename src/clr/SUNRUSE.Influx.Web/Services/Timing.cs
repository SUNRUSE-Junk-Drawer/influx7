using System;
using System.Collections.Generic;
using System.ComponentModel.Composition;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SUNRUSE.Influx.Web.Services
{
	/// <summary>Mockable container for nondeterministic methods concerning time.</summary>
	public interface ITiming
	{
		/// <summary><see cref="DateTime.UtcNow"/></summary>
		DateTime Now { get; }
	}

	/// <inheritdoc />
	[Export(typeof(ITiming))]
	public sealed class Timing : ITiming
	{
		/// <inheritdoc />
		public DateTime Now
		{
			get
			{
				return DateTime.UtcNow;
			}
		}
	}
}
