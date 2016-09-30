using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

//This is a namespace - a way of grouping things together
namespace TestApp1
{
    //This is a class - contains functions and variables, things that we want to run
    class Program
    {
        //This is a funciton
        static void Main(string[] args)
        {
            //This is where the program starts. Console is a class (contains functionality)
            Console.WriteLine("Type a number, any number");
            ConsoleKeyInfo keyinfo = Console.ReadKey();
            Console.WriteLine("Did you type {o}", keyinfo.KeyChar.ToString());
        }
    }
}
