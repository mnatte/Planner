using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data.SqlClient;

namespace MvcApplication1.DataAccess
{
    public abstract class BaseCrudRepository<T, TInputModel> where TInputModel : IBasicCrudUsable
    {
        protected virtual string ConnectionString 
        { 
            get { return "Data Source=localhost\\SQLENTERPRISE;Initial Catalog=Planner;Integrated Security=SSPI;MultipleActiveResultSets=true"; }
        }
        protected abstract void ConfigureUpsertCommand(TInputModel model, SqlCommand cmd);
        protected abstract void ConfigureSelectAllCommand(SqlCommand cmd);
        protected abstract void ConfigureSelectItemCommand(SqlCommand cmd, int id);
        protected abstract void ConfigureDeleteCommand(SqlCommand cmd, int id);

        protected abstract T CreateItemByDbRow(SqlDataReader reader);

        public List<T> GetItems()
        {
            var conn = new SqlConnection(this.ConnectionString);
            var items = new List<T>();

            using (conn)
            {
                conn.Open();

                // Prepare command
                var cmd = new SqlCommand();
                cmd.Connection = conn;
                this.ConfigureSelectAllCommand(cmd);

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        var itm = this.CreateItemByDbRow(reader);
                        items.Add(itm);
                    }
                }
            }
            return items;// this.Json(items, JsonRequestBehavior.AllowGet);
        }

        public T GetItemById(int id)
        {
            var conn = new SqlConnection(this.ConnectionString);
            T item = default(T);

            using (conn)
            {
                conn.Open();

                // Release
                var cmd = new SqlCommand();
                cmd.Connection = conn;
                this.ConfigureSelectItemCommand(cmd, id);

                using (var reader = cmd.ExecuteReader())
                {
                    reader.Read();
                    item = this.CreateItemByDbRow(reader);
                }
                conn.Close();
            }

            return item; // this.Json(item, JsonRequestBehavior.AllowGet);
        }

        public T Save(TInputModel obj)
        {
            var conn = new SqlConnection(this.ConnectionString);
            int newId = 0;
            try
            {
                using (conn)
                {
                    conn.Open();

                    var cmd = new SqlCommand();
                    cmd.Connection = conn;
                    this.ConfigureUpsertCommand(obj, cmd);

                    using (cmd)
                    {
                        var result = cmd.ExecuteScalar().ToString();

                        if (result == string.Empty)
                        // it's an update
                        {
                            newId = obj.Id;
                        }
                        else if (result != string.Empty)
                        // it's an insert
                        {
                            newId = int.Parse(result);
                        }
                    }
                    this.AddChildCollection(obj);

                }

                return GetItemById(newId);
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public string Delete(int id)
        {
            var conn = new SqlConnection(this.ConnectionString);
            int amount = 0;
            try
            {
                using (conn)
                {
                    conn.Open();

                    // Remove Project
                    var cmdMain = new SqlCommand();
                    cmdMain.Connection = conn;
                    this.ConfigureDeleteCommand(cmdMain, id);
                    
                    amount += cmdMain.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                throw;
            }
            return string.Format("{0} rows deleted", amount);
        }

        /// <summary>
        /// override when addition of child objects is needed
        /// </summary>
        /// <param name="obj"></param>
        /// <param name="cmd"></param>
        protected virtual void AddChildCollection(TInputModel obj)
        { }

    }
}
