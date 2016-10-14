using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace SimpleWebBrowser
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void fileToolStripMenuItem_Click(object sender, EventArgs e)
        {

        }

        private void fIleToolStripMenuItem_Click_1(object sender, EventArgs e)
        {

        }

        /// <summary>
        /// This function is called when the about menu is clicked
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void aToolStripMenuItem_Click(object sender, EventArgs e)
        {
            //Messagebox is a way of "accessing" forms (object oriented)
            MessageBox.Show("This program was made by me","Who made this",MessageBoxButtons.OKCancel);
        }

        /// <summary>
        /// This function is called when the exit menu is clicked
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void exitToolStripMenuItem_Click(object sender, EventArgs e)
        {
            //this exit function acts on the instance of Form1
            this.Close();
        }

        /// <summary>
        /// This function is called when the Go button is clicked
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void GO_Click(object sender, EventArgs e)
        {
            //Object Oriented stuff - WebBrowser 1 is an instance of Webbrowser object. We can interface with this 
            //object through the navigate function
            webBrowser1.Navigate(searchbar1.Text);
        }

        /// <summary>
        /// This function will execute every time a key is pressed and released
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void searchbar1_KeyPress(object sender, KeyPressEventArgs e)
        {
            //console keys data type is enum, but we need to convert it to a character
            if (e.KeyChar == (char)ConsoleKey.Enter)
            {
                webBrowser1.Navigate(searchbar1.Text);
            }
        }
    }
}
