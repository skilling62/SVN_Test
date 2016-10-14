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

        /// <summary>
        /// When the button is clicked, this will be executed
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void button1_Click(object sender, EventArgs e)
        {
            //richtextbox means you can put in better text. remember richTextBox1 is an instance of richtextBox 
            richTextBox1.AppendText("A button was clicked\r\n");
        }

        /// <summary>
        /// This function will run when the mouse enters the vicinity of button1 (event)
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void button1_MouseEnter(object sender, EventArgs e)
        {
            richTextBox1.AppendText("The mouse has entered the button area\r\n");
        }

        /// <summary>
        /// When the mouse leaves button 1, enter text into the text box
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void button1_MouseLeave(object sender, EventArgs e)
        {
            richTextBox1.AppendText("The mouse has left the button area\r\n");
        }
    }
}
