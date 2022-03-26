module dfi_jedec_asserts
	#(
	parameter Physical_Rank_No = 1, 
	parameter device_width = 4)
(
// DFI_Interface signals 
input   logic reset_n_i,
input   logic en_i,
input 	logic dfi_clk,
input	logic phycrc_mode_i,
input	logic [1:0] dfi_freq_ratio_i, 
input   logic [13:0] dfi_address_p0, dfi_address_p1,dfi_address_p2,dfi_address_p3,
input   logic [Physical_Rank_No-1:0]dfi_cs_p0,dfi_cs_p1,dfi_cs_p2,dfi_cs_p3,
input   logic dfi_rddata_en_p0,dfi_rddata_en_p1,dfi_rddata_en_p2,dfi_rddata_en_p3,
input	logic dfi_alert_n_a0, dfi_alert_n_a1,dfi_alert_n_a2,dfi_alert_n_a3,
input   logic dfi_rddata_valid_w0,dfi_rddata_valid_w1,dfi_rddata_valid_w2,dfi_rddata_valid_w3,
input   logic [2*device_width-1:0]dfi_rddata_w0,dfi_rddata_w1,dfi_rddata_w2,dfi_rddata_w3
// JEDEC Interface 
input 	logic dfi_phy_clk,
input	logic [0:13] CA_DA_o,
input   logic CS_DA_o,
input   logic CA_VALID_DA_o,
input	logic DQS_AD_i,
input   logic [2*device_width-1:0] DQ_AD_i
);
parameter trddata_en = // specify the needed delay
parameter tphy_rdlat =
parameter tcmd_lat = 

parameter tctrl_delay



// 
property dfi_rddata_en_signal_asserted ;
  @(posedge dfi_clk)
  ((dfi_address_p0[4:0] == 5'b11101) && !(dfi_cs_p0)) |-> ##[0:trddata_en] dfi_rddata_en_p0;
  ((dfi_address_p1[4:0] == 5'b11101) && !(dfi_cs_p1)) |-> ##[0:trddata_en] dfi_rddata_en_p1;
  ((dfi_address_p2[4:0] == 5'b11101) && !(dfi_cs_p2)) |-> ##[0:trddata_en] dfi_rddata_en_p2;
  ((dfi_address_p3[4:0] == 5'b11101) && !(dfi_cs_p3)) |-> ##[0:trddata_en] dfi_rddata_en_p3;

endproperty: dfi_rddata_en_signal_asserted

ERR_dfi_rddata_en_signal_not_asserted: assert property(dfi_rddata_en_signal_asserted);


property dfi_rddata_cs_signal_asserted ;
  @(posedge dfi_clk)
  ((dfi_address_p0[4:0] == 5'b11101) && !(dfi_cs_p0)) |-> ##[0:tphy_rdcslat] dfi_rddata_cs_p0;
  ((dfi_address_p1[4:0] == 5'b11101) && !(dfi_cs_p1)) |-> ##[0:tphy_rdcslat] dfi_rddata_cs_p1;
  ((dfi_address_p2[4:0] == 5'b11101) && !(dfi_cs_p2)) |-> ##[0:tphy_rdcslat] dfi_rddata_cs_p2;
  ((dfi_address_p3[4:0] == 5'b11101) && !(dfi_cs_p3)) |-> ##[0:tphy_rdcslat] dfi_rddata_cs_p3;
endproperty: dfi_rddata_cs_signal_asserted

ERR_dfi_rddata_cs_signal_not_asserted: assert property(dfi_rddata_cs_signal_asserted);


property dfi_rddata_valid_signal_asserted ;
  @(posedge dfi_clk)
  dfi_rddata_en_p0 |-> ##[0:tphy_rdlat] dfi_rddata_valid_w0;
  dfi_rddata_en_p1 |-> ##[0:tphy_rdlat] dfi_rddata_valid_w1;
  dfi_rddata_en_p2 |-> ##[0:tphy_rdlat] dfi_rddata_valid_w2;
  dfi_rddata_en_p3 |-> ##[0:tphy_rdlat] dfi_rddata_valid_w3;

endproperty: dfi_rddata_valid_signal_asserted

ERR_dfi_rddata_valid_signal_not_asserted: assert property(dfi_rddata_valid_signal_asserted);


/*
Matching between 2 sequences with offset
property dfi_rddata_valid_signal_match_dfi_rddata_en ;
  @(posedge dfi_clk)
  dfi_rddata_en[0:];
endproperty: dfi_rddata_en_signal_asserted

*/

property dfi_rddata_signal_valid ;
  @(posedge dfi_clk)
    $onehot(dfi_rddata_valid_w0) |-> !$isunknown(dfi_rddata_w0);
    $onehot(dfi_rddata_valid_w1) |-> !$isunknown(dfi_rddata_w1);
    $onehot(dfi_rddata_valid_w2) |-> !$isunknown(dfi_rddata_w2);
    $onehot(dfi_rddata_valid_w3) |-> !$isunknown(dfi_rddata_w3);
endproperty: dfi_rddata_signal_valid

ERR_dfi_rddata_signal_not_valid: assert property(dfi_rddata_signal_valid);

//  command is driven for at least 1 DFI PHY clock cycle after the CS is active.
// tcmd_lat specifies the number of DFI clocks after the dfi_cs signal is asserted until the associated CA signals are driven.

property dfi_address_valid ;
  @(posedge dfi_clk)
    !dfi_cs_p0 |-> ##[0:tcmd_lat] !$isunknown(dfi_address_p0) [*1:$];
    !dfi_cs_p1 |-> ##[0:tcmd_lat] !$isunknown(dfi_address_p1) [*1:$];
    !dfi_cs_p2 |-> ##[0:tcmd_lat] !$isunknown(dfi_address_p2) [*1:$];
    !dfi_cs_p3 |-> ##[0:tcmd_lat] !$isunknown(dfi_address_p3) [*1:$];
endproperty: dfi_address_valid

ERR_dfi_address_signal_not_valid: assert property(dfi_address_valid);

// Translation delay between DFI and JEDEC

property dfi_address_CA_delay ;
  @(posedge dfi_clk)
	(!$isunknown(dfi_address_p0) or !$isunknown(dfi_address_p1) or !$isunknown(dfi_address_p2) or !$isunknown(dfi_address_p3)) |-> ##[0:tctrl_delay] !$isunknown(CA_DA_o);	
endproperty: dfi_address_CA_delay

ERR_dfi_address_CA_delay_not_match_std: assert property(dfi_address_CA_delay);
	
// 
