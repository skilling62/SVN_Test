using System;                              //System is a namespace
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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
            ConsoleColor oldColour = Console.ForegroundColor; // create a new object, oldColour, and assign it the current console colour

            WhatProg();                                          //Calling a function declared below

            Console.ForegroundColor = ConsoleColor.White;
            Console.Write("Ask a question?: ");
            Console.ForegroundColor = ConsoleColor.Gray;
            string questionstring = Console.ReadLine();
           
            
            
          
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
    }
}
