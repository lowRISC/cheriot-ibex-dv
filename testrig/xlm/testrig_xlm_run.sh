#!/bin/bash
set -x

verbosity_arg="+UVM_VERBOSITY=UVM_LOW"
wave_arg=""

while getopts "vw" opt; do
  case $opt in
      v) verbosity_arg="+UVM_VERBOSITY=UVM_HIGH" ;;
      w) wave_arg="-input waves.tcl" ;;
   esac
done

xrun \
	-64bit \
	-R \
	-l run.log \
  +UVM_TESTNAME=core_ibex_testrig_test \
  $wave_arg \
  $verbosity_arg
