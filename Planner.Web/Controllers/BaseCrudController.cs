using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data.SqlClient;

namespace MvcApplication1.Controllers
{
    public abstract class BaseCrudController<T, TInputModel> : Controller where TInputModel : IBasicCrudUsable
    {
        protected abstract string ConnectionString { get; }
        protected abstract void ConfigureUpsertCommand(TInputModel model, SqlCommand cmd);
        protected abstract void ConfigureSelectAllCommand(SqlCommand cmd);
        protected abstract void ConfigureSelectItemCommand(SqlCommand cmd, int id);
        protected abstract void ConfigureDeleteCommand(SqlCommand cmd, int id);

        protected abstract T CreateItemByDbRow(SqlDataReader reader);

        public JsonResult GetItems()
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
            return this.Json(items, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetItemById(int id)
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

            return this.Json(item, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult Save(TInputModel obj)
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

                }

                return GetItemById(newId);
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        // DELETE: /Project/Delete/5
        [HttpDelete]
        public JsonResult Delete(int id)
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
            return this.Json(string.Format("{0} rows deleted", amount), JsonRequestBehavior.AllowGet);
        }

    }
}
