using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;

namespace Mnd.DataAccess
{
    public abstract class SimpleCrudRepository<T, TInputModel> : BaseCrudRepository<T, TInputModel> where TInputModel : IBasicCrudUsable
    {
        protected abstract string TableName { get; }
        protected abstract string UpsertStoredProcedureName { get; }
        protected abstract void AddUpsertCommandParameters(TInputModel model, SqlCommand cmd);

        protected override void ConfigureUpsertCommand(TInputModel model, SqlCommand cmd)
        {
            cmd.CommandText = this.UpsertStoredProcedureName;
            this.AddUpsertCommandParameters(model, cmd);
        }

        protected override void ConfigureSelectAllCommand(SqlCommand cmd)
        {
            cmd.CommandText = string.Format("Select * from {0}", this.TableName);
        }

        protected override void ConfigureSelectItemCommand(SqlCommand cmd, int id)
        {
            cmd.CommandText = string.Format("Select * from {0} where Id = {1}", this.TableName, id);
        }

        protected override void ConfigureDeleteCommand(SqlCommand cmd, int id)
        {
            cmd.CommandText = string.Format("Delete from {0} where Id = {1}", this.TableName, id);
        }
    }
}