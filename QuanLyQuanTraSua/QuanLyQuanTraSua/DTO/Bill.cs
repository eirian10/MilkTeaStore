using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuanLyQuanTraSua.DTO
{
    public class Bill
    {

        //dung ? vi datatime ko cho null, dung ? se cho null
        private int iD;
        private DateTime? dataCheckIn;
        private DateTime? dataCheckOut;
        private int status;

        public Bill(int iD, DateTime? dataCheckIn, DateTime? dataCheckOut, int status)
        {
            this.ID = iD;
            this.DataCheckIn = dataCheckIn;
            this.DataCheckOut = dataCheckOut;
            this.Status = status;
        }
        public Bill(DataRow row)
        {
            this.ID = (int)row["id"];
            this.DataCheckIn = (DateTime?)row["DateCheckIn"];

            var dataCheckOutTemp = row["DataCheckOut"];
            if (dataCheckOutTemp.ToString() != "")
                this.dataCheckOut = (DateTime?)dataCheckOutTemp;
            this.Status = (int)row["status"];
        }
        public int ID
        {
            get { return iD; }
            set { iD = value; }
        }

        public DateTime? DataCheckIn
        {
            get { return dataCheckIn; }
            set { dataCheckIn = value; }
        }

        public DateTime? DataCheckOut
        {
            get { return dataCheckOut; }
            set { dataCheckOut = value; }
        }

        public int Status
        {
            get { return status; }
            set { status = value; }
        }
    }
}
