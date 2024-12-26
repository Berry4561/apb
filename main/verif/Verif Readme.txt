APB Driver has 2 tasks, to drive_write and drive read,
At every 2nd posedge of cycle we get a new transaction from sequence and drive it on the interface.
We also maintain IP specific delays to not make the transactiongo out of protocol specification

APB MONITOR-
apb_monitor has 2 analysis ports drv_ap and resp_ap,

drv_ap provides the checker with the information what is being driven to the interface and resp_ap provides the infgrmation whta DUT drives the information on the interface.
Both are fowarded via analysisport to checker. Check the connection part in env file
COverge:
Functional coverage hsd been written in a separate file in apb_env directory and included in apb_checker file. THe coverage is as per the test_plan.
The checker is as per the test_plan.

Filelist.f- This file provides the the directories and files that must be included in order to remove circular dependency duting compiling. 
Please also check this.