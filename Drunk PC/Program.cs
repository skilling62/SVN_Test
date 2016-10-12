using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Threading;
using System.Windows.Forms;
using System.Drawing;


//Key topics - System.Windows.Form namespace and assembly and threads

namespace Drunk_PC
{
    class Program
    {
        //Make this object available throughout the Program Class. Need static aswell to do this. GLOBAL SCOPE
        public static Random _random = new Random();
        /// <summary>
        /// Entry point for prank application
        /// </summary>
        /// <param name="args"></param>
        static void Main(string[] args)
        {
            Console.WriteLine("Drunk PC prank application by me");

            //Create threads that pass in the thread functions
            //Use threads as "seperate programs" that are able to run side by side
            Thread drunkmousethread = new Thread(new ThreadStart(DrunkMouseThread));
            Thread drunkkeyboardthread = new Thread(new ThreadStart(DrunkKeyboardThread));
            Thread drunksoundthread = new Thread(new ThreadStart(DrunkSoundThread));
            Thread drunkpopupthread = new Thread(new ThreadStart(DrunkPopUpThread));

            //start the threads
            drunkmousethread.Start();
            drunkkeyboardthread.Start();
            drunksoundthread.Start();
            drunkpopupthread.Start();

            //Wait for user input
            Console.Read();

            //Abort the threads
            drunkmousethread.Abort();
            drunkkeyboardthread.Abort();
            drunksoundthread.Abort();
            drunkpopupthread.Abort();



        }

        #region Thread functions
        /// <summary>
        /// static - don't have to create another instance of the class. Void - the threads don't return anything
        /// </summary> This thread will randomly effect the mouse movemets apparently 
        public static void DrunkMouseThread()
        {
            Console.WriteLine("DrunkMouseThread started");
            while(true)
            {
                Console.WriteLine(Cursor.Position.ToString());

                Cursor.Position = new Point(Cursor.Position.X - 10, Cursor.Position.Y - 10);
                 
                Thread.Sleep(500);
            }
        }

        /// <summary>
        /// Generate random keyboard output
        /// </summary>
        public static void DrunkKeyboardThread()
        {
            Console.WriteLine("DrunkKeyboardThread started");
            while (true)
            {
                Thread.Sleep(500);
            }
        }

        /// <summary>
        /// This will play random system sounds
        /// </summary>
        public static void DrunkSoundThread()
        {
            Console.WriteLine("DrunkSoundThreadStarted started");
            while (true)
            {
                Thread.Sleep(500);
            }
        }

        /// <summary>
        /// This will make pop ups pop up at random
        /// </summary>
        public static void DrunkPopUpThread()
        {
            Console.WriteLine("DrunkPopUpThread started");
            while (true)
            {
                Thread.Sleep(500);
            }
        }

        #endregion
    }
}
