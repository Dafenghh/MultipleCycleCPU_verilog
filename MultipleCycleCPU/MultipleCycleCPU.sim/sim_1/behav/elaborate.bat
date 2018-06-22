@echo off
set xv_path=D:\\Xilinx\\Vivado\\2015.3\\bin
call %xv_path%/xelab  -wto d3f97d1b2c2e4ee088a3f45cb417a26d -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot TestSingleCycleCpu_behav xil_defaultlib.TestSingleCycleCpu xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
