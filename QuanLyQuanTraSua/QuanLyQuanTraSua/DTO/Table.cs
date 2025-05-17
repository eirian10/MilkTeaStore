using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuanLyQuanTraSua.DTO
{
   public class Table
    {
        private int iD;
        private string name;
        private string status;

        public Table(int iD, string name, string status)
        {
            this.ID = iD;
            this.Name = name;
            this.Status = status;
        }
        // Xử lý để chuyển từng row thành list
        public Table(DataRow row)
        {
            this.ID = (int)row["id"];
            this.Name = row["name"].ToString();
            this.Status = row["status"].ToString();
        }
        public string Status 
        { get { return status; }
            set { status = value; } }

        public string Name 
        { get { return name; }
            set { name = value; } }

        public int ID 
        { get { return iD; }
            set { iD = value; } 
        }
    }
}
