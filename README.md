# Battery-Text
Program that uses iMessage to inform you, on your iPhone, that your mac's battery is low. 

Problem being solved:

This program removes the worry of forgetting to charge your mac. If you've ever had an event or activity planned for which your mac is required, only to find that your mac is out of battery, this program is for you

Intended use-cases: 

* When mac is not in use e.g. while travelling

* When your mac is not with you

Features:

* Support for two battery threshold levels

* Check for wifi connection to ensure message is sent

* Check for conditions where program should not run (charging and idle time)

* Display is slept to conserve battery

* Mac sleeps after reaching second threshold to conserve battery

INSTRUCTIONS:

Step 1: In BatteryText.sh, look for code that marked by comments with a capitalized letter (A-C) in the following functions: "wifi", "main" and "exitSet"

Step 2: Edit the code as instructed in the comment

Step 3: In autotext1.scpt and autotext2.scpt, edit them with your iMessage email

Step 4: Change directories in terminal to the folder containing all the files

Step 5: Make the Bash file excecutable by entering the following in terminal: sudo chmod +x BatteryText.sh

Step 6: Run the file like so: ./BatteryText.sh


Optional: Use the Platypus tool to make the program into a .app

Optional: Schedule for the program to run automatically by using a .plist file


* By default the program will:
	- exit if your mac is being charged
	- sleep for 30 minutes if your idle time is <= 1 minute
	- attempt to connect to a preferred wifi network of yours, if it isn't already
	- only send a maximum of 2 texts total, one at each predetermined battery percentage threshold (20% & 15%)
	- once the first threshold has been reached and the text sent, sleep for 30 minutes before checking for the second threshold
	- on start, instruct your mac's sleep to be set to never to ensure the running of the program
	- on start, instruct your mac's display to sleep to conserve battery
	- on exit, instruct your mac to revert its sleep to your preferred setting
	- on exit, instruct your mac to sleep unless the idle time is <= 1 minute
*


All of the above may be modified to suit your preferences