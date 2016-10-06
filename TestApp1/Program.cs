using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

//This is a namespace - a way of grouping things together
namespace TestApp1
{
    //This is a class - contains functions and variables, things that we want to run. aka a structure with built in functions
    //for example, students would be an example of a class. Student a would be an object of the class
    class Program
    {
        //This is a funciton
        static void Main(string[] args)
        {
            //This is where the program starts. Console is a class (contains functionality)
            Console.WriteLine("Type a number, any number");
            ConsoleKeyInfo keyinfo = Console.ReadKey();

            if (keyinfo.KeyChar == 'a') //keyinfo is our variable, containing the user input. KeyChar means we are just interested in the characters
            {
                Console.WriteLine(" Hey man thats not a number");
            }
            else
            {
                Console.WriteLine(" Did you type {0}?", keyinfo.KeyChar.ToString()); // The 0 placeholder is replaced by the first argument after the comma
            }

            printfootoscreen10();             //this is a function that we have created later, but it is called within Main
        }

        /// <summary>
        /// The function Printfootoscreen prints foo to the screen. Static void is used  to declare a new function?
        /// </summary>
        static void Printfootoscreen()
        {
            Console.WriteLine("Foo");
        }

        /// <summary>
        /// function to print foot to screen 100 times using a for loop. It calls printfootoscreen, which was created earlier
        /// </summary>
        static void printfootoscreen10()
        {
            for (int counter = 0; counter <= 9; counter++)  // to use a different increment, use counter = counter + 2
            { Printfootoscreen();                           // use braces in the body of a for loop

            }
        }
    }
}

// to finish up, go to bin/debug and the program is the Application file