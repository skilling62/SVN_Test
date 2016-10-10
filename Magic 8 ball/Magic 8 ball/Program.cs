using System;                              //System is a namespace
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Threading;

namespace Magic_8_ball
{
    //class Sam                            commented this out as it doesn't need to be run
    //{
    //    static string name = "Sam";    //this characteristic is specific to the Sam class. Static is used so you don't have to create instances of Sam in the Program class
    //    public static int age = 21;    //this characteristic can be seen by other classes . Public is an access modifier

    //}

    /// <summary>
    /// Entry point for Magic 8 Ball program
    /// </summary>
    class Program
    {
        static void Main(string[] args) 
        {
            // Change console text colour
            
            //Preserve current console colour
            ConsoleColor oldColour = Console.ForegroundColor;             // create a new object, oldColour, and assign it the current console colour

            WhatProg();                                                  //Calling a function declared below

            Random randomobject = new Random();                         //Creating the variable randomobject, before the while loop is executed
            Console.WriteLine("{0}", randomobject.Next(10));            //generates a random number between 0 and 9

            while (true)
            {
                string questionstring = getquestion();

                int numberofsecondstosleep = randomobject.Next(5) + 1;
                Console.WriteLine("Wait a second m8");
                Thread.Sleep(numberofsecondstosleep * 1000);
                

                if(questionstring.Length == 0)                          //== is a comparator. 
                    {
                    Console.WriteLine("You need to ask a question");
                    continue;                                           //Continue skips over the rest of the loop, taking you back to the start
                    }

                //Break out of the while loop if the user types quit

                if(questionstring.ToLower() == "quit")
                {
                    break; 
                }

                //Get a random number
                int randomNumber = randomobject.Next(4);

                Console.ForegroundColor = (ConsoleColor)randomNumber;   //consolecolor is like an enumeration i think

                switch (randomNumber)
                {
                    case 0:
                        {
                            Console.WriteLine("Yes");
                            break;                                      //break - jumps out of the switch statement once a criteria is met
                        }
                    case 1:
                        {
                            Console.WriteLine("Yes!");
                            break;
                        }
                    case 2:
                        {
                            Console.WriteLine("That is incredible m8");
                            break;
                        }
                    case 3:
                        {
                            Console.WriteLine("Turrible");
                            break;
                        }
                       
                }

                
            }
           
            
            //Cleaning Up
            Console.ForegroundColor = oldColour;    //Resotring the console to the old colour
        }

        /// <summary>
        /// Create a new function to print the name of the program and who wrote it
        /// </summary>
        static void WhatProg ()                     //Use static so that you don't have to create an instance program (the class)
        {
            //Change the console colour
            Console.ForegroundColor = ConsoleColor.Green;  //ForegorundColor is a characteristic of the class Console
            Console.Write("M");                             //Write is a function of Console. It doesn't go to the next line, like writeline does
            Console.ForegroundColor = ConsoleColor.Magenta;
            Console.WriteLine("agic 8 ball written by me"); //Console is a class. Console.writline means Class.Characteristic or functionality

        }

        /// <summary>
        /// Create a new function that returns the text the user types
        /// </summary>
        /// <returns></returns>
        static string getquestion()
        {
            Console.ForegroundColor = ConsoleColor.White;
            Console.Write("Ask a question?: ");
            Console.ForegroundColor = ConsoleColor.Gray;
            string questionstring = Console.ReadLine();

            return questionstring;
        }
    }
}
