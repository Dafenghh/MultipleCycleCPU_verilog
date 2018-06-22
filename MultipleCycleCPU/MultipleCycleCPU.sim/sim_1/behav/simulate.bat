@echo off
set xv_path=D:\\Xilinx\\Vivado\\2015.3\\bin
call %xv_path%/xsim TestSingleCycleCpu_behav -key {Behavioral:sim_1:Functional:TestSingleCycleCpu} -tclbatch TestSingleCycleCpu.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
