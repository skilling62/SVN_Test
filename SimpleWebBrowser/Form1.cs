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

            NavigateToPage();
        }

        /// <summary>
        /// This is our new navigation function
        /// </summary>
        private void NavigateToPage()
        {
            statusStrip1.Text = ("Navigation has started");
            //disable the go button and search bar when navigating
            GO.Enabled = false;
            searchbar1.Enabled = false;

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
                NavigateToPage();
            }
        }

        private void webBrowser1_DocumentCompleted(object sender, WebBrowserDocumentCompletedEventArgs e)
        {
            GO.Enabled = true;
            searchbar1.Enabled = true;
            statusStrip1.Text = ("Navigation has started");


        }

        /// <summary>
        /// Function to display the current progress of the webbrowser1 as a %
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void webBrowser1_ProgressChanged(object sender, WebBrowserProgressChangedEventArgs e)
        {
            //Avoid a divide by 0 error
            if (e.CurrentProgress > 0 & e.MaximumProgress > 0)
            {
                //toolstripprogressbar object value must be an integer. Event argument, e, has a number of characteristics, ie max progress
                toolStripProgressBar1.ProgressBar.Value = (int)(e.CurrentProgress * 100 / e.MaximumProgress);
            }
        }

        private void toolStripStatusLabel1_Click(object sender, EventArgs e)
        {

        }
    }
}
