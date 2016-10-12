using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Diagnostics;
using System.Threading;
using System.Speech.Synthesis;

//^^ Pulling in extra namespaces for use in this application. System.Speech was pulled in by adding it as a reference
// Before revisiting this, open up the performance monitor

namespace Jarvis
{
    class Program
    {
        //Create a new instance (object) of the SpeechSynthesizer class, called synth. Make it static so new instances don't have to be created elsewhere
       private static SpeechSynthesizer synth = new SpeechSynthesizer();

        static void Main(string[] args)
        {
            //Create a List of string objects
            List<string> cpumaxedoutmessages = new List<string>();
            cpumaxedoutmessages.Add("Warning your CPU is getting in a bizzle m8");


        
            Speak("Welcome to Jarvis version 1.0");

            #region My Performance Counters

            // Create a new instance of the PerformanceCounter class. Use the % Processor Time counter within the Processor Information Object
            PerformanceCounter perfcpucount = new PerformanceCounter("Processor Information", "% Processor Time", "_Total");

            //Initialise perfcpucount
            perfcpucount.NextValue();

            // Create a new instance of PerformanceCounter. Use the Available MBytes counter within the Memory Object
            PerformanceCounter perfmemcount = new PerformanceCounter("Memory", "Available MBytes");
            perfmemcount.NextValue();

            // Create a new instance of PerformanceCounter. Use the System Up Time counter within the system object (seconds)
            PerformanceCounter perfuptimecount = new PerformanceCounter("System", "System Up Time");
            perfuptimecount.NextValue();
                
            #endregion

            // Call for the next value - returns the number of seconds of System Up Time. Convert to timespan object, which allows conversion to days, hours etc
            TimeSpan uptimespan = TimeSpan.FromSeconds(perfuptimecount.NextValue());

            //Create a new instance of string called systemuptimemessage 
            string systemuptimemessage = string.Format("The current system up time is {0} days {1} hours {2} minutes {3} seconds",
                (int)uptimespan.TotalDays,
                (int)uptimespan.Hours,
                (int)uptimespan.Minutes,
                (int)uptimespan.Seconds
                );

            //Tell the user what the system uptime is
            Speak(systemuptimemessage);

            //Create a variable called speechspeed
            int speechspeed = 1;

            //Infinite while loop
            while (true)
            {
                // Get the current CPU Percentage and available memory
                float currentCpuPercentage = perfcpucount.NextValue();
                float currentAvailableMemory = perfmemcount.NextValue();

                //Print CPU usage Percentage and available memory to the console every second. Convert the floats to integers            
                Console.WriteLine("CPU Load: {0}%", (int)currentCpuPercentage);
                Console.WriteLine("Available Memory: {0}MB", (int)currentAvailableMemory);

                //Alert the user with speech if cpu percentage is greater than 80%, and warn if it reaches 100%
                if (currentCpuPercentage > 80)
                {
                    if (currentCpuPercentage == 100)
                    {
                        string cpuLoadVocalMessage = String.Format("Warning your CPU is getting in a bizzle m8");

                        if (speechspeed <=5)
                        {
                            speechspeed++;
                        }
                        //Calling the Speak funciton with message and incremented speechspeed, if apllicable
                        Speak(cpuLoadVocalMessage, speechspeed);
                    }
                    else
                    {
                        //Note cpuLoadVocalMessage is created twice, but since it is locally scoped inside each if/else statement it is not ambiguous
                        string cpuLoadVocalMessage = String.Format("The current CPU load is {0} percent", (int)currentCpuPercentage);
                        Speak(cpuLoadVocalMessage);
                    }

                }

                //Alert the user with speech if the memory is less than 1GB
                if (currentAvailableMemory < 1024)
                {
                    string memAvailableMessage = String.Format("You currently have {0} Mega Bytes of memory available", (int)currentAvailableMemory);
                    Speak(memAvailableMessage);
                }
                
                //Wait for one second
                Thread.Sleep(1000);
            }        
        }

        /// <summary>
        /// Function called speak that speaks the string that is passed into it
        /// </summary>
        /// <param name="message"></param>
         public static void Speak(string message)
        {
            synth.Speak(message);
        }

        /// <summary>
        /// Speak with selected voice at selected speed. This is an overloaded function (funciton in a function)
        /// </summary>
        /// <param name="message"></param>
        /// <param name="rate"></param>
        public static void Speak(string message, int rate)
        {
            synth.Rate = rate;
            Speak(message);
        }

        


    }

}
