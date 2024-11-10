package router_test_pkg;

import uvm_pkg :: *;

`include "uvm_macros.svh"

`include "src_xtn.sv"
`include "src_agent_config.sv"
`include "dst_agent_config.sv"
`include "env_config.sv"

`include "src_driver.sv"
`include "src_monitor.sv"
`include "src_sequencer.sv"
`include "src_agent.sv"
`include "src_agt_top.sv"
`include "src_sequences.sv"

`include "dst_xtn.sv"
`include "dst_monitor.sv"
`include "dst_sequencer.sv"
`include "dst_sequences.sv"
`include "dst_driver.sv"
`include "dst_agent.sv"
`include "dst_agt_top.sv"

`include "virtual_sequencer.sv"
`include "virtual_sequences.sv"
`include "scoreboard.sv"

`include "env.sv"

`include "router_test.sv"

endpackage
