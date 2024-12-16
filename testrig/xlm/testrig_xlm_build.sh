#!/bin/sh

export PRJ_DIR=$(realpath ../../)

xrun \
 -64bit \
 -sv \
 -q \
 -f ../tb_files.f \
 -licqueue \
 -elaborate \
 -l build.log \
 -access rwc \
 -debug_opts verisium_pp \
 -uvmhome CDNS-1.2 \
 +define+XCELIUM
#vcs \
# -full64 \
# -f ./dv/hyperram/hyperram_dv.f \
# -sverilog \
# -l build.log \
# -timescale=1ns/10ps \
# -licqueue
