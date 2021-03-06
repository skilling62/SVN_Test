﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Threading;
using System.Windows.Forms;
using System.Drawing;
using System.Media;


//Key topics - System.Windows.Form namespace and assembly and threads

namespace Drunk_PC
{
    class Program
    {
        //Make this object available throughout the Program Class. Need static aswell to do this. GLOBAL SCOPE
        public static Random _random = new Random();

        //Initialise the delay and application finishing time variables
        public static int _startupdelayseconds = 10;
        public static int _totaldurationseconds = 10;
        /// <summary>
        /// Entry point for prank application
        /// </summary>
        /// <param name="args"></param>
        static void Main(string[] args)
        {
            Console.WriteLine("Drunk PC prank application by me");

            //Logic based on an input from the command line. Located in bin\debug. Shouldn't have put any spaces in the name!
            if (args.Length >= 2)
            {
                _startupdelayseconds = Convert.ToInt32(args[0]);
                _totaldurationseconds = Convert.ToInt32(args[1]);
            }

            #region create and run threads
            //Create threads that pass in the thread functions
            //Use threads as "seperate programs" that are able to run side by side
            Thread drunkmousethread = new Thread(new ThreadStart(DrunkMouseThread));
            Thread drunkkeyboardthread = new Thread(new ThreadStart(DrunkKeyboardThread));
            Thread drunksoundthread = new Thread(new ThreadStart(DrunkSoundThread));
            Thread drunkpopupthread = new Thread(new ThreadStart(DrunkPopUpThread));

            //Wait 10 seconds before starting the threads
            DateTime Future = DateTime.Now.AddSeconds(_startupdelayseconds);
            Console.WriteLine("Waiting 10 seconds before starting threads");
            while (Future > DateTime.Now)
            {
                Thread.Sleep(1000);
            }

            //start the threads
            drunkmousethread.Start();
            drunkkeyboardthread.Start();
            drunksoundthread.Start();
            drunkpopupthread.Start();

            //Terminate the app after 10 seconds
            Future = DateTime.Now.AddSeconds(_totaldurationseconds);
            while (Future>DateTime.Now)
            {
                Thread.Sleep(1000);
            }

            Console.WriteLine("Terminating all threads");
            //Abort the threads
            drunkmousethread.Abort();
            drunkkeyboardthread.Abort();
            drunksoundthread.Abort();
            drunkpopupthread.Abort();
            #endregion

        }

        #region Thread functions
        /// <summary>
        /// static - don't have to create another instance of the class. Void - the threads don't return anything
        /// </summary> This thread will randomly effect the mouse movemets apparently 
        public static void DrunkMouseThread()
        {

            //create move x and move y variables. Make variables outside the loop!!

            int moveX = 0;
            int moveY = 0;

            Console.WriteLine("DrunkMouseThread started");
            while(true)
            {
                //Console.WriteLine(Cursor.Position.ToString());

                //Assign move x and y a random number 0-19 and subtract 10 from that
                moveX = _random.Next(20)-10;
                moveY = _random.Next(20)-10;

                //Cursor.position is in System.Windows.Forms namespace;
                Cursor.Position = new Point(
                    Cursor.Position.X + moveX, 
                    Cursor.Position.Y + moveY);
                 
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
                //Converting a random number (between 0-24 then add 65) to a character. ASCII table
                char key = (char)(_random.Next(25)+65);

                if (_random.Next(2)==1)
                {
                    key = char.ToLower(key);
                }

                //Sendkeys.Sendwait is in System.Windows.Forms namespace
                SendKeys.SendWait(key.ToString());
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
                if (_random.Next(101) > 70)
                {
                    switch (_random.Next(4))
                    {
                        case 0:
                            SystemSounds.Asterisk.Play();
                            break;
                        case 1:
                            SystemSounds.Beep.Play();
                            break;
                        case 2:
                            SystemSounds.Exclamation.Play();
                            break;
                        case 3:
                            SystemSounds.Hand.Play();
                            break;
                        case 4:
                            SystemSounds.Question.Play();
                            break;
                    }

                 }

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
                if (_random.Next(101) > 50)
                {
                    //Deterimine which message to show
                    switch (_random.Next(2))
                    {
                        case 0:
                            MessageBox.Show(
                                "Internet explorer has gone off one one",
                                "Internet Explorer",
                                MessageBoxButtons.OK,
                                MessageBoxIcon.Error);
                            break;
                        case 1:
                            MessageBox.Show(
                              "hahahaha",
                              "Microsoft Windows",
                              MessageBoxButtons.OK,
                              MessageBoxIcon.Warning);
                            break;

                    }
                }


                Thread.Sleep(10000);
            }
        }

        #endregion
    }
}
