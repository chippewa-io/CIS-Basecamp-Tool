#!/bin/sh
###########################################################################
# 
#                       CIS_Daily_v1.0
#                       Author: Chris Cohoon
#							                                                                             
#  Copyright (C) Thursday, March 2, 2023, Chippewa Limited Liability Co.                                       
#                                                                             
#  This script is the property of Chippewa Limited Liability Co. and is intended for internal     
#  use only. This script may not be distributed, reproduced, or used in any    
#  manner without the expressed written consent of Chippewa Limited Liability Co..                
#                                                                             
#  This script is provided "AS IS" and WITHOUT WARRANTY OF ANY KIND,           
#  EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED     
#  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.         
#       
###########################################################################
#Pruning#######################################################################
###############################################################################
# Set the directory where you've stored the audit files
dir="/Library/Application Support/Security Audit/"

# Get the number of days from the command line argument, or default to 365
days=${1:-365}

# Calculate the threshold time in seconds
threshold=$(date -v-${days}d +%s)

# Loop through all .csv files in the directory
for file in "$dir"/*.csv; do
    # Get the file's modification time in seconds since Unix epoch
    modtime=$(stat -f "%m" "$file")

    # If the file is older than the threshold, delete it
    if [[ $modtime -lt $threshold ]]; then
        rm "$file"
        echo "Deleted $file"
    fi
done

# Print a message when the script is done
echo "Done!"
###############################################################################
#Audit the computer############################################################
###############################################################################
#Script Location
auditScript="/Library/Application Support/Security Audit/CIS_Audit_v1.17.sh"
#Ensure our script has not been tampered with
expected_md5="a5650e7d856ae8f6740af6ad8441c451" #This will need to be updated with each iteration of the script
actual_md5=$(md5 -q "$auditScript")

if [[ "$actual_md5" == "$expected_md5" ]]; then
	echo "Script is authentic and has not been tampered with"
else
	echo "Audit Script has been tampered with!"
	exit 1
fi
#Execute the audit script
sudo sh "$auditScript"

if [  $? == 0 ]; then
	echo "Audit complete!"
else
	echo "Audit failed to execute successfully!"
fi