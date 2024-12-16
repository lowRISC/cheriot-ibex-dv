# Overview

A standalone testbench providing a UVM environment for CHERIoT Ibex for use as a
[TestRIG](https://github.com/CTSRD-CHERI/TestRIG) implementation to enable it to
be compared against other implementations (e.g. the Sail model).  The testbench
enables initial TestRIG support and is not yet complete with various features
missing (e.g. interrupt support). It has been developed and tested against the
[cheriot branch of the lowRISC TestRIG fork](https://github.com/lowRISC/TestRIG/tree/cheriot).

## Running

First clone the [cheriot branch of the lowRISC TestRIG fork](https://github.com/lowRISC/TestRIG/tree/cheriot)
and set it up following the instructions in the [README](https://github.com/lowRISC/TestRIG/blob/cheriot/README.md).

Then build the simulator itself. This is done with the
`testrig/xlm/testrig_xlm_build.sh` shell script

```shell
cd testrig/xlm
./testrig_xlm_build.sh
```

Then run the simulator (remaining in the `testrig/xlm` directory)

```shell
./testrig_xlm_run.sh
```

Wait until the simulation has begun listening on port 6000, you should see the
following:

```
UVM_INFO @ 0: reporter [RNTST] Running test core_ibex_testrig_test...
---- allocated socket for RVFI_DII
---- RVFI_DII_PORT environment variable not defined, using default port 6000 instead
---- RVFI_DII socket listening on port 6000
UVM_INFO /home/greg/work/cheriot-ibex-dv/agents/ibex_testrig_agent/ibex_testrig_agent.sv(79) @ 2021: uvm_test_top.testrig_env.testrig_agent [ibex_testrig_agent_pkg::ibex_testrig_agent.watch_for_reset] Watching for next reset
UVM_INFO /home/greg/work/cheriot-ibex-dv/agents/ibex_testrig_agent/ibex_testrig_dii_driver.sv(66) @ 2036: uvm_test_top.testrig_env.testrig_agent.dii_driver [ibex_testrig_agent_pkg::ibex_testrig_dii_driver.run_phase] Waiting for next DII packet
```

In another shell run TestRIG:

```shell
utils/scripts/runTestRIG.py -a manual --implementation-A-port 6000 -b sail -r rv32ecZifencei_Xcheriot --test-include-regex '^arith$' --no-shrink --continue-on-fail
```

This will run just the arithmetic tests, which should all pass.

The simulation will terminate on a fatal timeout error as it stops receiving DII
packets from TestRIG. The final few UVM log files should look like this:

```
UVM_INFO /home/greg/work/cheriot-ibex-dv/agents/ibex_testrig_agent/ibex_testrig_agent.sv(141) @ 186821: uvm_test_top.testrig_env.testrig_agent [ibex_testrig_agent_pkg::ibex_testrig_agent.process_rvfi]         413 rvfi seen         412 limit
UVM_INFO /home/greg/work/cheriot-ibex-dv/agents/ibex_testrig_agent/ibex_testrig_agent.sv(150) @ 186821: uvm_test_top.testrig_env.testrig_agent [ibex_testrig_agent_pkg::ibex_testrig_agent.process_rvfi] At send limit, skipping send to testrig
UVM_INFO /home/greg/work/cheriot-ibex-dv/agents/ibex_testrig_agent/ibex_testrig_dii_driver.sv(111) @ 186836: uvm_test_top.testrig_env.testrig_agent.dii_driver [ibex_testrig_agent_pkg::ibex_testrig_dii_driver.run_phase] Performing reset
UVM_INFO /home/greg/work/cheriot-ibex-dv/agents/ibex_testrig_agent/ibex_testrig_agent.sv(91) @ 186838: uvm_test_top.testrig_env.testrig_agent [ibex_testrig_agent_pkg::ibex_testrig_agent.watch_for_reset] Seen reset, sending RVFI halt
UVM_INFO /home/greg/work/cheriot-ibex-dv/agents/ibex_testrig_agent/ibex_testrig_agent.sv(93) @ 186838: uvm_test_top.testrig_env.testrig_agent [ibex_testrig_agent_pkg::ibex_testrig_agent.watch_for_reset]         413 total RVFI seen,         412 RVFI send limit
UVM_INFO /home/greg/work/cheriot-ibex-dv/agents/ibex_testrig_agent/ibex_testrig_agent.sv(79) @ 186838: uvm_test_top.testrig_env.testrig_agent [ibex_testrig_agent_pkg::ibex_testrig_agent.watch_for_reset] Watching for next reset
UVM_INFO /home/greg/work/cheriot-ibex-dv/agents/ibex_testrig_agent/ibex_testrig_dii_driver.sv(66) @ 186876: uvm_test_top.testrig_env.testrig_agent.dii_driver [ibex_testrig_agent_pkg::ibex_testrig_dii_driver.run_phase] Waiting for next DII packet
UVM_FATAL /home/greg/work/cheriot-ibex-dv/agents/ibex_testrig_agent/ibex_testrig_dii_driver.sv(78) @ 186876: uvm_test_top.testrig_env.testrig_agent.dii_driver [ibex_testrig_agent_pkg::ibex_testrig_dii_driver.run_phase] Timeout waiting for next DII packet
```

To get a wave dump add the `-w` option to the run script, to get verbose UVM
logging (switch from UVM_LOW to UVM_HIGH verbosity) add the `-v` option to the
run script, i.e.

```shell
./testrig_xlm_run.sh -v -w
```

Would give you verbose logging and waves.

Waves are written to `waves.db` for post-processing debug with verisium.

```shell
verisium -lwd ./xcelium.d/ -db ./waves.db/
```

Will open a verisium post process debugging session.

The `run.log` file contains the log from the simulation run and
`trace_core_00000000.log` contains a log of instruction retirement from the
core.

## Dependencies

This repository has dependencies on external repositories. First there is there
cheriot-ibex repository. This is handled as a git submodule (under the
`cheriot-ibex-rtl/` directory). It should strictly be used for *RTL only*.
Specifically the set of RTL being tested by the testbench. Any other components
should either be vendored in (under the `vendor/` directory) or included in the
repository itself as appropriate. Note the CHERIoT Ibex repository submodule
contains various DV related files. These are all ignored. This is to allow
change to anything DV related to occur without needing changes to the submodule.
It also allows switching the submodule to test different versions of the RTL
without needing to update the repository containing that RTL with DV changes.

## Sources

The initial contents of this repository were drawn from the
[testrig_intr branch of the lowRISC CHERIoT Ibex fork](https://github.com/lowRISC/cheriot-ibex/tree/testrig_intr).
