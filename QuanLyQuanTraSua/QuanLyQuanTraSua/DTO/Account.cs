using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

namespace QuanLyQuanTraSua.DTO
{
    public class Account
    {
        private string userName;
        private string displayName;
        private int type;
        private string passWord;

        public Account(string userName, string displayName, int type, string passWord = null)
        {
            this.UserName = userName;
            this.DisplayName = displayName;
            this.Type = type;
            this.PassWord = passWord;
        }

        public string DisplayName
        {
            get { return displayName; }
            set { displayName = value; }
        }

        public string UserName { get => userName; set => userName = value; }
        public int Type { get => type; set => type = value; }
        public string PassWord { get => passWord; set => passWord = value; }

        public Account(DataRow row)
        {
            this.UserName = row["userName"].ToString();
            this.DisplayName = row["displayName"].ToString();
            this.Type = (int)row["type"];
            this.PassWord = row["passWord"].ToString();
        }
    }
}
