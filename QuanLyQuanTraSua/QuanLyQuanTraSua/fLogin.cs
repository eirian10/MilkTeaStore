﻿using QuanLyQuanTraSua.DAO;
using QuanLyQuanTraSua.DTO;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QuanLyQuanTraSua
{
    public partial class fLogin: Form
    {
        public fLogin()
        {
            InitializeComponent();
        }
        private void btnLogin_Click(object sender, EventArgs e)
        {
            string userName = txbUserName.Text;
            string passWord = txbPassWord.Text;
            if (Login(userName, passWord))
             {
                Account loginAccount = AccountDAO.Instance.GetAccountByUserName(userName);
            fTableManager f = new fTableManager(loginAccount);
            this.Hide();
            f.ShowDialog(); //Xu ly top truoc(dialog)
            this.Show();
            }
            else
            {
              MessageBox.Show("Sai tên tài khoản hoặc mật khẩu");
             }
        }
        bool Login(string userName, string passWord)
        {
            return AccountDAO.Instance.Login(userName, passWord); 
        }
        private void btnExit_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void fLogin_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (MessageBox.Show("Bạn chắc chắn muốn thoát chứ ?","Thông báo", MessageBoxButtons.OKCancel) != System.Windows.Forms.DialogResult.OK)
            {
                e.Cancel = true;
            }
        }


    }
}
