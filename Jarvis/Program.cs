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
        static void Main(string[] args)
        {

            //Create a new instance (object) of the SpeechSynthesizer class, called synth
            SpeechSynthesizer synth = new SpeechSynthesizer();
            synth.Speak("Welcome to Jarvis version 1.0");

            #region My Performance Counters

            // Create a new instance of the PerformanceCounter class. Use the % Processor Time counter within the Processor Information Object
            PerformanceCounter perfcpucount = new PerformanceCounter("Processor Information", "% Processor Time", "_Total");

            // Create a new instance of PerformanceCounter. Use the Available MBytes counter within the Memory Object
            PerformanceCounter perfmemcount = new PerformanceCounter("Memory", "Available MBytes");

            // Create a new instance of PerformanceCounter. Use the System Up Time counter within the system object (seconds)
            PerformanceCounter perfuptimecount = new PerformanceCounter("System", "System Up Time");
            #endregion


            //Infinite while loop
            while (true)
            {
                // Get the current CPU Percentage and available memory
                float currentCpuPercentage = perfcpucount.NextValue();
                float currentAvailableMemory = perfmemcount.NextValue();

                //Print CPU usage Percentage and available memory to the console every second. Convert the floats to integers            
                Console.WriteLine("CPU Load: {0}%", (int)currentCpuPercentage);
                Console.WriteLine("Available Memory: {0}MB", (int)currentAvailableMemory);

                //Store the messageas to be spoken to the user as strings
                string cpuLoadVocalMessage = String.Format("The current CPU load is {0} percent", (int) currentCpuPercentage);
                string memAvailableMessage = String.Format("You currently have {0} Mega Bytes of memory available", (int)currentAvailableMemory);

                //Speak the messages with synth.speak
                synth.Speak(cpuLoadVocalMessage);
                synth.Speak(memAvailableMessage);

                //Wait for one second
                Thread.Sleep(1000);
            }



                 
        }
    }

    

}
