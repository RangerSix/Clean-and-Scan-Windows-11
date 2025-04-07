This is a PowerShell script that runs the Windows Disk Cleanup (using the preset cleanup configuration) and then starts a Windows Defender quick scan. This script includes logging. the log file will be stored at C:\Logs\. 
Before using this script for automation, please ensure that you have already configured the Disk Cleanup options by running the following command once manually:

cleanmgr.exe /sageset:1

This opens a dialog where you select what files to clean up. Once configured, you can use the automated script.

Explanation
- Disk Cleanup:
The script calls cleanmgr.exe with the /sagerun:1 argument. This command uses the configuration saved via a previous cleanmgr.exe /sageset:1 run to delete temporary files, cached files, and other unwanted data. This ensures the cleanup proceeds automatically without user intervention.
- Antivirus Scan:
The script then pauses for a couple of seconds before invoking the Windows Defender quick scan using the Start-MpScan cmdlet (which is built into Windows Defender on Windows 11). A check is also provided to verify that the cmdlet exists, and an error message is printed if it isn’t available. This makes sure your script handles unexpected conditions gracefully.
- Administrative Privileges:
Both disk cleanup operations and antivirus scans typically require elevated permissions. Make sure to run this script as an administrator.


Additional Tips
- Scheduling Automation:
To automate this script on a regular basis, consider scheduling it using Windows Task Scheduler. Create a new task with the highest privileges, and configure the trigger (daily, weekly, etc.) as needed.
- Customizing the Scan:
If you’d like to run a full scan instead of a quick scan, change the -ScanType parameter in the Start-MpScan cmdlet from QuickScan to FullScan. Note that a full scan may take significantly longer.

