#!/bin/bash

### BatteryText version 1.0 ###

# By Arsalan Cheema ---- arsalanc.v2@gmail.com

# IMPORTANT: Hashtags with letters (A-D) denote points where stuff has to be changed by you

# echo YOUR_COMPUTER_PASSWORD | sudo -S pmset repeat wake MTWRFSU hh:mm:ss --- TO AUTOMATE THE RUNINNG OF THIS PROGRAM: UNCOMMENT THIS COMMAND, CHANGE THE TIME TO YOUR PREFERRED TIME (in 24H format) AND USE IT WITH A .plist FILE 


###
# WI-FI (needed to send the iMessage)
###

function wifi {

  # B - enter the details of your preferred wi-fi
  wifiOne=YOUR_WIFI_SSID #( No space after '=')
  passOne=YOUR_WIFI_PASSWORD # (No space after '=')

  # Check if it is already connected
  connected=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}')

  if [ "$connected" != "$wifiOne" ] # Not currently connected to the preferred wifi
  then
    # Attempt primary wi-fi
    connectOne=$(networksetup -setairportnetwork en0 $wifiOne $passOne)
    if [ "$connectOne" != "" ] # Primary wi-fi unsuccessful
    then
      sleep 600 # Wifi attempt unsuccessful, try again in 10 minutes
      continue
    fi
  fi

}

###
# CHECK FOR CONDITIONS - where program is to be delayed or exited
### 

function noRun {
  
  # Check mac's idle time	
  using=$(/usr/sbin/ioreg -c IOHIDSystem | /usr/bin/awk '/HIDIdleTime/ {print int($NF/1000000000); exit}')
  # Check if mac is charging
  charging=$(system_profiler SPPowerDataType | grep "Connected" | awk '{ print substr( $0, length($0) - 2, length($0) ) }') # Getting 0th element and printing last 3 characters
  
  if [ "$charging" == "Yes" ] 
  then
  	break # Stop program if mac is charging. Needs to be manually run again (if wanted)

  elif [ "$using" -le 60 ] # Idle time threshold is set to one minute
  then 
  	sleep 1800 # Sleep program and check again in 30 minutes if mac was used <= a minute ago
    continue 	
  fi

}

###
# PROGRAM LOGIC
###

function text {

  # Printing out battery percentage as an integer and storing it in a variable. 
  battPercentage=$(ioreg -l | grep -i capacity | tr '\n' ' | ' | awk '{printf("%.0f", $10/$5 * 100)}')

  # Threshold 1 for battery percentage value
  value1=20
  # Threshold 2 for battery percentage value 
  value2=15

  # Stop program once 2 texts have been sent, 1 when battery reaches value1 and the other when battery reaches value2
  if [ $count -ge 2 ] 
  then
  	break

  # Execution for when battery percentage is >value2 and <=value1. Executes only once.
  elif [ "$battPercentage" -le $value1 ] && [ $count -lt 1 ]
  then 
    osascript autotext1.scpt # Apple script is run to send text
    count=$((count+1)) # Variable is incremented to prevent continuous texts
    sleep 1800 # Minimum 30 minutes delay before next text (And only if battery has reached value2)

  # Execution for when battery percentage is <=value2. Executes only once. 
  elif [ "$battPercentage" -le $value2 ] && [ $count -ge 1 ]
  then
    osascript autotext2.scpt # Apple script is run to send text
    count=$((count+1)) # Variable is incremented to prevent continuous texts
    break # Exit while loop to end program once second battery threshold has been reached
    
  else
    sleep 900 # Runs loop after 15 minutes to check again if battery has reached value1/value2 %
  fi

}

###
# PROGRAM EXECUTION
###

function main {

  # A Your password is necessary to change the sleep setting to ensure that this program keeps running
  echo YOUR_COMPUTER_PASSWORD | sudo -S systemsetup -setcomputersleep Never

  # Sleep just the display, to conserve battery
  pmset displaysleepnow

  # variable to keep track of number of times program is run
  count=0

  while [ true ]; do
    
    noRun

    wifi

    text

  done

  # C - At the end: Remove the exclamation marks and replace the text with a number. Your password is necessary to revert to your preferred sleep setting.
  echo YOUR_COMPUTER_PASSWORD | sudo -S systemsetup -setcomputersleep !!!SET_TO_YOUR_PREFERRED_NUMBER_IN_MINUTES(example: 10)!!!

  killall Messages

  # Put system to sleep to conserve battery
  pmset sleepnow

  exit

}

main






