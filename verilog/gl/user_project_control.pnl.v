module user_project_control (clk,
    dig_ena,
    enable,
    power_3v3_ena,
    power_5v0_ena,
    proj_3v3_ena,
    proj_5v0_ena,
    proj_clk,
    proj_ena,
    proj_reset,
    proj_vbias_ena,
    reset,
    vbias_ena,
    vddd,
    vssd,
    analog_ena,
    dig_in,
    dig_out,
    dig_out_relay,
    ibias_ena,
    proj_addr,
    proj_analog_ena,
    proj_dig_in,
    proj_dig_out,
    proj_ibias_ena,
    proj_sel);
 input clk;
 input dig_ena;
 input enable;
 input power_3v3_ena;
 input power_5v0_ena;
 output proj_3v3_ena;
 output proj_5v0_ena;
 output proj_clk;
 output proj_ena;
 output proj_reset;
 output proj_vbias_ena;
 input reset;
 input vbias_ena;
 inout vddd;
 inout vssd;
 input [3:0] analog_ena;
 input [23:0] dig_in;
 output [11:0] dig_out;
 input [11:0] dig_out_relay;
 input [1:0] ibias_ena;
 input [4:0] proj_addr;
 output [3:0] proj_analog_ena;
 output [23:0] proj_dig_in;
 input [11:0] proj_dig_out;
 output [1:0] proj_ibias_ena;
 input [4:0] proj_sel;

 wire _00_;
 wire _01_;
 wire _02_;
 wire _03_;
 wire _04_;
 wire _05_;
 wire _06_;
 wire _07_;
 wire _08_;
 wire _09_;
 wire _10_;
 wire _11_;
 wire _12_;
 wire net6;
 wire clk_regs;
 wire \control_base.dig_out[0] ;
 wire \control_base.dig_out[10] ;
 wire \control_base.dig_out[11] ;
 wire \control_base.dig_out[1] ;
 wire \control_base.dig_out[2] ;
 wire \control_base.dig_out[3] ;
 wire \control_base.dig_out[4] ;
 wire \control_base.dig_out[5] ;
 wire \control_base.dig_out[6] ;
 wire \control_base.dig_out[7] ;
 wire \control_base.dig_out[8] ;
 wire \control_base.dig_out[9] ;
 wire \control_base.proj_3v3_ena ;
 wire \control_base.proj_5v0_ena ;
 wire \control_base.proj_analog_ena[0] ;
 wire \control_base.proj_analog_ena[1] ;
 wire \control_base.proj_analog_ena[2] ;
 wire \control_base.proj_analog_ena[3] ;
 wire \control_base.proj_ena ;
 wire \control_base.proj_ibias_ena[0] ;
 wire \control_base.proj_ibias_ena[1] ;
 wire \control_base.proj_reset ;
 wire \control_base.proj_vbias_ena ;
 wire \control_base.reset_sync[0] ;
 wire \control_base.select ;
 wire dig_ena_sel;
 wire proj_clk_gate;
 wire proj_clk_unbuf;
 wire \proj_dig_in_unbuf[0] ;
 wire \proj_dig_in_unbuf[10] ;
 wire \proj_dig_in_unbuf[11] ;
 wire \proj_dig_in_unbuf[12] ;
 wire \proj_dig_in_unbuf[13] ;
 wire \proj_dig_in_unbuf[14] ;
 wire \proj_dig_in_unbuf[15] ;
 wire \proj_dig_in_unbuf[16] ;
 wire \proj_dig_in_unbuf[17] ;
 wire \proj_dig_in_unbuf[18] ;
 wire \proj_dig_in_unbuf[19] ;
 wire \proj_dig_in_unbuf[1] ;
 wire \proj_dig_in_unbuf[20] ;
 wire \proj_dig_in_unbuf[21] ;
 wire \proj_dig_in_unbuf[22] ;
 wire \proj_dig_in_unbuf[23] ;
 wire \proj_dig_in_unbuf[2] ;
 wire \proj_dig_in_unbuf[3] ;
 wire \proj_dig_in_unbuf[4] ;
 wire \proj_dig_in_unbuf[5] ;
 wire \proj_dig_in_unbuf[6] ;
 wire \proj_dig_in_unbuf[7] ;
 wire \proj_dig_in_unbuf[8] ;
 wire \proj_dig_in_unbuf[9] ;
 wire net1;
 wire net2;
 wire net3;
 wire net4;
 wire net5;
 wire net;
 wire clknet_0_clk;
 wire clknet_1_0__leaf_clk;
 wire clknet_1_1__leaf_clk;
 wire clknet_0_clk_regs;
 wire clknet_1_0__leaf_clk_regs;
 wire clknet_1_1__leaf_clk_regs;
 wire net7;

 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__15__A (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(proj_sel[2]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__16__A (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(proj_addr[3]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__17__A (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(proj_sel[1]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__18__A (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(proj_sel[1]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__18__B (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(proj_addr[1]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__19__A (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(proj_addr[0]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__19__B (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(proj_sel[0]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__20__A (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(proj_addr[3]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__20__B (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(proj_sel[3]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__21__A (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(proj_sel[2]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__21__B (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(proj_addr[2]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__22__A (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(proj_sel[0]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__22__B (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(proj_addr[0]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__23__A (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(proj_addr[2]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__23__C (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(proj_addr[1]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__24__A (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(proj_addr[4]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__24__B (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(proj_sel[4]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__25__B (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(proj_sel[3]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__28__A (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(ibias_ena[1]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__29__A (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(analog_ena[0]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__30__A (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(analog_ena[1]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__31__A (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(analog_ena[2]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__32__A (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(analog_ena[3]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__33__A (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(power_3v3_ena));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__34__A (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(power_5v0_ena));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__35__A (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(enable));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__36__A (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(reset));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__37__A (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(dig_ena));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__38__A (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(vbias_ena));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__39__A (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(ibias_ena[0]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__40__A (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(dig_out_relay[0]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__40__B (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(proj_dig_out[0]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__41__A (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(dig_out_relay[1]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__41__B (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(proj_dig_out[1]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__42__A (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(dig_out_relay[2]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__42__B (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(proj_dig_out[2]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__43__A (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(dig_out_relay[3]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__43__B (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(proj_dig_out[3]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__44__A (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(dig_out_relay[4]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__44__B (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(proj_dig_out[4]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__45__A (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(dig_out_relay[5]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__45__B (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(proj_dig_out[5]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__46__A (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(dig_out_relay[6]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__46__B (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(proj_dig_out[6]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__47__A (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(dig_out_relay[7]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__47__B (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(proj_dig_out[7]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__48__A (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(dig_out_relay[8]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__48__B (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(proj_dig_out[8]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__49__A (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(dig_out_relay[9]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__49__B (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(proj_dig_out[9]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__50__A (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(dig_out_relay[10]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__50__B (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(proj_dig_out[10]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__51__A (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(dig_out_relay[11]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__51__B (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(proj_dig_out[11]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__52__RN (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(enable));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA__53__RN (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(enable));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA_clkbuf_0_clk_A (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(clk));
 gf180mcu_as_sc_mcu7t3v3__diode_2 ANTENNA_clkbuf_regs_0_clk_A (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(clk));
 gf180mcu_as_sc_mcu7t3v3__diode_2 \ANTENNA_dig_in_gen[0].dig_in_latch_D  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(dig_in[0]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 \ANTENNA_dig_in_gen[10].dig_in_latch_D  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(dig_in[10]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 \ANTENNA_dig_in_gen[11].dig_in_latch_D  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(dig_in[11]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 \ANTENNA_dig_in_gen[12].dig_in_latch_D  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(dig_in[12]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 \ANTENNA_dig_in_gen[13].dig_in_latch_D  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(dig_in[13]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 \ANTENNA_dig_in_gen[14].dig_in_latch_D  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(dig_in[14]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 \ANTENNA_dig_in_gen[15].dig_in_latch_D  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(dig_in[15]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 \ANTENNA_dig_in_gen[16].dig_in_latch_D  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(dig_in[16]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 \ANTENNA_dig_in_gen[17].dig_in_latch_D  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(dig_in[17]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 \ANTENNA_dig_in_gen[18].dig_in_latch_D  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(dig_in[18]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 \ANTENNA_dig_in_gen[19].dig_in_latch_D  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(dig_in[19]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 \ANTENNA_dig_in_gen[1].dig_in_latch_D  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(dig_in[1]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 \ANTENNA_dig_in_gen[20].dig_in_latch_D  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(dig_in[20]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 \ANTENNA_dig_in_gen[21].dig_in_latch_D  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(dig_in[21]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 \ANTENNA_dig_in_gen[22].dig_in_latch_D  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(dig_in[22]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 \ANTENNA_dig_in_gen[23].dig_in_latch_D  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(dig_in[23]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 \ANTENNA_dig_in_gen[2].dig_in_latch_D  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(dig_in[2]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 \ANTENNA_dig_in_gen[3].dig_in_latch_D  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(dig_in[3]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 \ANTENNA_dig_in_gen[4].dig_in_latch_D  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(dig_in[4]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 \ANTENNA_dig_in_gen[5].dig_in_latch_D  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(dig_in[5]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 \ANTENNA_dig_in_gen[6].dig_in_latch_D  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(dig_in[6]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 \ANTENNA_dig_in_gen[7].dig_in_latch_D  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(dig_in[7]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 \ANTENNA_dig_in_gen[8].dig_in_latch_D  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(dig_in[8]));
 gf180mcu_as_sc_mcu7t3v3__diode_2 \ANTENNA_dig_in_gen[9].dig_in_latch_D  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .DIODE(dig_in[9]));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_0_106 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_0_116 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_0_120 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_16 FILLER_0_142 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_0_158 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_0_166 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_16 FILLER_0_172 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_0_188 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_0_196 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_0_33 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_0_67 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_0_72 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_0_80 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_0_82 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_16 FILLER_10_109 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_16 FILLER_10_125 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_10_141 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_10_149 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_10_153 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_10_170 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_10_174 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_10_177 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_10_179 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_10_189 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_10_197 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_10_199 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_10_39 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_10_41 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_10_60 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_10_83 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_10_85 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_11_116 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_11_120 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_11_144 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_11_152 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_11_172 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_11_189 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_11_197 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_11_199 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_11_2 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_11_27 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_11_29 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_11_48 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_11_50 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_11_6 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_11_74 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_11_78 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_12_107 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_12_115 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_12_119 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_12_121 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_12_174 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_12_177 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_12_179 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_12_189 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_12_197 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_12_199 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_12_2 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_12_27 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_12_46 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_12_50 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_12_6 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_12_72 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_12_8 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_12_80 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_12_84 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_12_86 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_13_118 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_13_144 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_13_152 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_13_156 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_16 FILLER_13_162 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_16 FILLER_13_178 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_13_194 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_13_198 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_16 FILLER_13_2 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_13_43 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_13_47 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_13_69 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_13_72 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_13_76 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_13_95 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_13_97 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_14_10 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_14_125 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_14_14 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_14_16 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_14_162 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_14_170 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_14_174 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_16 FILLER_14_177 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_14_193 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_14_197 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_14_199 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_14_2 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_14_37 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_14_45 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_14_83 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_16 FILLER_15_104 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_16 FILLER_15_120 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_16 FILLER_15_138 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_16 FILLER_15_154 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_16 FILLER_15_172 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_15_188 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_15_196 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_15_2 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_15_27 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_15_31 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_15_33 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_15_36 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_15_44 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_15_48 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_15_6 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_15_72 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_15_8 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_15_80 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_1_135 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_16 FILLER_1_154 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_1_170 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_1_178 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_1_189 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_1_197 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_1_199 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_1_72 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_1_79 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_1_83 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_1_85 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_1_88 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_1_92 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_1_94 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_2_109 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_2_113 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_16 FILLER_2_157 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_2_173 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_2_177 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_2_179 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_2_189 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_2_197 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_2_199 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_2_2 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_2_64 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_2_66 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_16 FILLER_3_154 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_3_170 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_3_178 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_3_189 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_3_197 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_3_199 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_3_2 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_3_64 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_3_68 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_3_93 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_4_127 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_4_131 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_4_133 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_16 FILLER_4_150 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_4_166 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_4_174 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_4_177 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_4_179 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_4_189 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_4_197 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_4_199 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_4_2 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_4_59 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_16 FILLER_5_158 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_5_174 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_5_178 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_5_189 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_5_197 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_5_199 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_5_52 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_5_61 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_5_69 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_5_72 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_5_76 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_5_78 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_6_103 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_6_128 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_6_136 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_6_165 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_16 FILLER_6_177 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_6_193 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_6_197 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_6_199 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_16 FILLER_6_59 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_16 FILLER_6_75 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_6_91 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_6_99 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_7_102 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_16 FILLER_7_121 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_7_137 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_7_139 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_7_142 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_7_144 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_16 FILLER_7_161 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_7_177 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_7_179 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_7_189 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_7_197 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_7_199 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_7_49 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_7_64 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_7_68 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_7_72 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_7_98 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_8_102 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_8_104 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_8_107 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_8_164 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_8_172 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_8_174 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_8_177 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_8_187 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_8_195 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_8_199 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_8_34 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_8_37 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_16 FILLER_8_56 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_8_72 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_8_94 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_16 FILLER_9_103 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_16 FILLER_9_119 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_9_135 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_9_139 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_9_142 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_9_146 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_9_150 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_9_167 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_9_175 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_9_179 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_9_189 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_9_197 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_9_199 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_16 FILLER_9_45 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_9_61 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_9_69 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_9_72 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_9_80 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_0_Left_16 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_0_Right_0 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_10_Left_26 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_10_Right_10 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_11_Left_27 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_11_Right_11 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_12_Left_28 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_12_Right_12 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_13_Left_29 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_13_Right_13 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_14_Left_30 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_14_Right_14 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_15_Left_31 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_15_Right_15 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_1_Left_17 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_1_Right_1 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_2_Left_18 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_2_Right_2 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_3_Left_19 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_3_Right_3 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_4_Left_20 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_4_Right_4 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_5_Left_21 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_5_Right_5 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_6_Left_22 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_6_Right_6 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_7_Left_23 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_7_Right_7 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_8_Left_24 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_8_Right_8 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_9_Left_25 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_9_Right_9 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_0_32 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_0_33 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_0_34 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_0_35 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_0_36 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_10_59 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_10_60 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_10_61 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_11_62 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_11_63 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_12_64 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_12_65 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_12_66 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_13_67 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_13_68 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_14_69 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_14_70 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_14_71 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_15_72 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_15_73 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_15_74 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_15_75 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_15_76 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_1_37 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_1_38 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_2_39 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_2_40 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_2_41 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_3_42 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_3_43 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_4_44 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_4_45 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_4_46 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_5_47 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_5_48 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_6_49 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_6_50 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_6_51 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_7_52 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_7_53 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_8_54 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_8_55 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_8_56 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_9_57 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_9_58 (.VDD(vddd),
    .VSS(vssd));
 gf180mcu_as_sc_mcu7t3v3__inv_2 _15_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .Y(_01_),
    .A(proj_sel[2]));
 gf180mcu_as_sc_mcu7t3v3__inv_2 _16_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .Y(_02_),
    .A(proj_addr[3]));
 gf180mcu_as_sc_mcu7t3v3__inv_2 _17_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .Y(_03_),
    .A(proj_sel[1]));
 gf180mcu_as_sc_mcu7t3v3__nand2b_2 _18_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .Y(_04_),
    .B(proj_addr[1]),
    .A(proj_sel[1]));
 gf180mcu_as_sc_mcu7t3v3__nand2b_2 _19_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .Y(_05_),
    .B(proj_sel[0]),
    .A(proj_addr[0]));
 gf180mcu_as_sc_mcu7t3v3__nand2b_2 _20_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .Y(_06_),
    .B(proj_sel[3]),
    .A(proj_addr[3]));
 gf180mcu_as_sc_mcu7t3v3__nand2b_2 _21_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .Y(_07_),
    .B(proj_addr[2]),
    .A(proj_sel[2]));
 gf180mcu_as_sc_mcu7t3v3__nand2b_2 _22_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .Y(_08_),
    .B(proj_addr[0]),
    .A(proj_sel[0]));
 gf180mcu_as_sc_mcu7t3v3__oa22_2 _23_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .C(proj_addr[1]),
    .D(_03_),
    .B(_01_),
    .A(proj_addr[2]),
    .Y(_09_));
 gf180mcu_as_sc_mcu7t3v3__xnor2_2 _24_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .B(proj_sel[4]),
    .A(proj_addr[4]),
    .Y(_10_));
 gf180mcu_as_sc_mcu7t3v3__oa211_2 _25_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(_02_),
    .B(proj_sel[3]),
    .C(_05_),
    .D(_10_),
    .Y(_11_));
 gf180mcu_as_sc_mcu7t3v3__and4_2 _26_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(_04_),
    .C(_07_),
    .B(_06_),
    .D(_08_),
    .Y(_12_));
 gf180mcu_as_sc_mcu7t3v3__and3_2 _27_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .Y(\control_base.select ),
    .C(_12_),
    .B(_11_),
    .A(_09_));
 gf180mcu_as_sc_mcu7t3v3__and2_2 _28_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .B(net5),
    .A(ibias_ena[1]),
    .Y(\control_base.proj_ibias_ena[1] ));
 gf180mcu_as_sc_mcu7t3v3__and2_2 _29_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .B(net5),
    .A(analog_ena[0]),
    .Y(\control_base.proj_analog_ena[0] ));
 gf180mcu_as_sc_mcu7t3v3__and2_2 _30_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .B(net5),
    .A(analog_ena[1]),
    .Y(\control_base.proj_analog_ena[1] ));
 gf180mcu_as_sc_mcu7t3v3__and2_2 _31_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .B(net5),
    .A(analog_ena[2]),
    .Y(\control_base.proj_analog_ena[2] ));
 gf180mcu_as_sc_mcu7t3v3__and2_2 _32_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .B(net5),
    .A(analog_ena[3]),
    .Y(\control_base.proj_analog_ena[3] ));
 gf180mcu_as_sc_mcu7t3v3__and2_2 _33_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .B(net5),
    .A(power_3v3_ena),
    .Y(\control_base.proj_3v3_ena ));
 gf180mcu_as_sc_mcu7t3v3__and2_2 _34_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .B(net5),
    .A(power_5v0_ena),
    .Y(\control_base.proj_5v0_ena ));
 gf180mcu_as_sc_mcu7t3v3__and2_2 _35_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .B(net5),
    .A(enable),
    .Y(\control_base.proj_ena ));
 gf180mcu_as_sc_mcu7t3v3__and2_2 _36_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .B(net5),
    .A(reset),
    .Y(_00_));
 gf180mcu_as_sc_mcu7t3v3__and4_2 _37_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(dig_ena),
    .C(_11_),
    .B(_09_),
    .D(_12_),
    .Y(dig_ena_sel));
 gf180mcu_as_sc_mcu7t3v3__and2_2 _38_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .B(\control_base.select ),
    .A(vbias_ena),
    .Y(\control_base.proj_vbias_ena ));
 gf180mcu_as_sc_mcu7t3v3__and2_2 _39_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .B(\control_base.select ),
    .A(ibias_ena[0]),
    .Y(\control_base.proj_ibias_ena[0] ));
 gf180mcu_as_sc_mcu7t3v3__mux2_2 _40_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .S(net3),
    .B(proj_dig_out[0]),
    .A(dig_out_relay[0]),
    .Y(\control_base.dig_out[0] ));
 gf180mcu_as_sc_mcu7t3v3__mux2_2 _41_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .S(net4),
    .B(proj_dig_out[1]),
    .A(dig_out_relay[1]),
    .Y(\control_base.dig_out[1] ));
 gf180mcu_as_sc_mcu7t3v3__mux2_2 _42_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .S(net4),
    .B(proj_dig_out[2]),
    .A(dig_out_relay[2]),
    .Y(\control_base.dig_out[2] ));
 gf180mcu_as_sc_mcu7t3v3__mux2_2 _43_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .S(net4),
    .B(proj_dig_out[3]),
    .A(dig_out_relay[3]),
    .Y(\control_base.dig_out[3] ));
 gf180mcu_as_sc_mcu7t3v3__mux2_2 _44_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .S(net4),
    .B(proj_dig_out[4]),
    .A(dig_out_relay[4]),
    .Y(\control_base.dig_out[4] ));
 gf180mcu_as_sc_mcu7t3v3__mux2_2 _45_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .S(net4),
    .B(proj_dig_out[5]),
    .A(dig_out_relay[5]),
    .Y(\control_base.dig_out[5] ));
 gf180mcu_as_sc_mcu7t3v3__mux2_2 _46_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .S(net3),
    .B(proj_dig_out[6]),
    .A(dig_out_relay[6]),
    .Y(\control_base.dig_out[6] ));
 gf180mcu_as_sc_mcu7t3v3__mux2_2 _47_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .S(net3),
    .B(proj_dig_out[7]),
    .A(dig_out_relay[7]),
    .Y(\control_base.dig_out[7] ));
 gf180mcu_as_sc_mcu7t3v3__mux2_2 _48_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .S(net3),
    .B(proj_dig_out[8]),
    .A(dig_out_relay[8]),
    .Y(\control_base.dig_out[8] ));
 gf180mcu_as_sc_mcu7t3v3__mux2_2 _49_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .S(net3),
    .B(proj_dig_out[9]),
    .A(dig_out_relay[9]),
    .Y(\control_base.dig_out[9] ));
 gf180mcu_as_sc_mcu7t3v3__mux2_2 _50_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .S(net3),
    .B(proj_dig_out[10]),
    .A(dig_out_relay[10]),
    .Y(\control_base.dig_out[10] ));
 gf180mcu_as_sc_mcu7t3v3__mux2_2 _51_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .S(net3),
    .B(proj_dig_out[11]),
    .A(dig_out_relay[11]),
    .Y(\control_base.dig_out[11] ));
 gf180mcu_as_sc_mcu7t3v3__dfsrtp_2 _52_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .CLK(clknet_1_0__leaf_clk_regs),
    .Q(\control_base.reset_sync[0] ),
    .RN(enable),
    .SN(net6),
    .D(_00_));
 gf180mcu_as_sc_mcu7t3v3__tieh_4 _52__7 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .ONE(net6));
 gf180mcu_as_sc_mcu7t3v3__dfsrtp_2 _53_ (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .CLK(clknet_1_1__leaf_clk_regs),
    .Q(\control_base.proj_reset ),
    .RN(enable),
    .SN(net),
    .D(net7));
 gf180mcu_as_sc_mcu7t3v3__tieh_4 _53__6 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .ONE(net));
 gf180mcu_as_sc_mcu7t3v3__clkbuff_12 clkbuf_0_clk (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(clk),
    .Y(clknet_0_clk));
 gf180mcu_as_sc_mcu7t3v3__clkbuff_12 clkbuf_0_clk_regs (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(clk_regs),
    .Y(clknet_0_clk_regs));
 gf180mcu_as_sc_mcu7t3v3__clkbuff_12 clkbuf_1_0__f_clk (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(clknet_0_clk),
    .Y(clknet_1_0__leaf_clk));
 gf180mcu_as_sc_mcu7t3v3__clkbuff_12 clkbuf_1_0__f_clk_regs (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(clknet_0_clk_regs),
    .Y(clknet_1_0__leaf_clk_regs));
 gf180mcu_as_sc_mcu7t3v3__clkbuff_12 clkbuf_1_1__f_clk (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(clknet_0_clk),
    .Y(clknet_1_1__leaf_clk));
 gf180mcu_as_sc_mcu7t3v3__clkbuff_12 clkbuf_1_1__f_clk_regs (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(clknet_0_clk_regs),
    .Y(clknet_1_1__leaf_clk_regs));
 gf180mcu_as_sc_mcu7t3v3__clkbuff_12 clkbuf_regs_0_clk (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(clk),
    .Y(clk_regs));
 gf180mcu_as_sc_mcu7t3v3__clkbuff_4 clkload0 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(clknet_1_0__leaf_clk));
 gf180mcu_as_sc_mcu7t3v3__and2_2 clockgate_and (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .B(proj_clk_gate),
    .A(clknet_1_1__leaf_clk),
    .Y(proj_clk_unbuf));
 gf180mcu_as_sc_mcu7t3v3__dlxtn_2 clockgate_latch (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .ENA(clknet_1_0__leaf_clk),
    .D(net5),
    .Q(proj_clk_gate));
 gf180mcu_as_sc_mcu7t3v3__dlxtp_2 \dig_in_gen[0].dig_in_latch  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .ENA(net4),
    .D(dig_in[0]),
    .Q(\proj_dig_in_unbuf[0] ));
 gf180mcu_as_sc_mcu7t3v3__dlxtp_2 \dig_in_gen[10].dig_in_latch  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .ENA(net1),
    .D(dig_in[10]),
    .Q(\proj_dig_in_unbuf[10] ));
 gf180mcu_as_sc_mcu7t3v3__dlxtp_2 \dig_in_gen[11].dig_in_latch  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .ENA(net1),
    .D(dig_in[11]),
    .Q(\proj_dig_in_unbuf[11] ));
 gf180mcu_as_sc_mcu7t3v3__dlxtp_2 \dig_in_gen[12].dig_in_latch  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .ENA(net1),
    .D(dig_in[12]),
    .Q(\proj_dig_in_unbuf[12] ));
 gf180mcu_as_sc_mcu7t3v3__dlxtp_2 \dig_in_gen[13].dig_in_latch  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .ENA(net1),
    .D(dig_in[13]),
    .Q(\proj_dig_in_unbuf[13] ));
 gf180mcu_as_sc_mcu7t3v3__dlxtp_2 \dig_in_gen[14].dig_in_latch  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .ENA(net2),
    .D(dig_in[14]),
    .Q(\proj_dig_in_unbuf[14] ));
 gf180mcu_as_sc_mcu7t3v3__dlxtp_2 \dig_in_gen[15].dig_in_latch  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .ENA(net2),
    .D(dig_in[15]),
    .Q(\proj_dig_in_unbuf[15] ));
 gf180mcu_as_sc_mcu7t3v3__dlxtp_2 \dig_in_gen[16].dig_in_latch  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .ENA(net2),
    .D(dig_in[16]),
    .Q(\proj_dig_in_unbuf[16] ));
 gf180mcu_as_sc_mcu7t3v3__dlxtp_2 \dig_in_gen[17].dig_in_latch  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .ENA(net1),
    .D(dig_in[17]),
    .Q(\proj_dig_in_unbuf[17] ));
 gf180mcu_as_sc_mcu7t3v3__dlxtp_2 \dig_in_gen[18].dig_in_latch  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .ENA(net1),
    .D(dig_in[18]),
    .Q(\proj_dig_in_unbuf[18] ));
 gf180mcu_as_sc_mcu7t3v3__dlxtp_2 \dig_in_gen[19].dig_in_latch  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .ENA(net2),
    .D(dig_in[19]),
    .Q(\proj_dig_in_unbuf[19] ));
 gf180mcu_as_sc_mcu7t3v3__dlxtp_2 \dig_in_gen[1].dig_in_latch  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .ENA(net4),
    .D(dig_in[1]),
    .Q(\proj_dig_in_unbuf[1] ));
 gf180mcu_as_sc_mcu7t3v3__dlxtp_2 \dig_in_gen[20].dig_in_latch  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .ENA(net2),
    .D(dig_in[20]),
    .Q(\proj_dig_in_unbuf[20] ));
 gf180mcu_as_sc_mcu7t3v3__dlxtp_2 \dig_in_gen[21].dig_in_latch  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .ENA(net2),
    .D(dig_in[21]),
    .Q(\proj_dig_in_unbuf[21] ));
 gf180mcu_as_sc_mcu7t3v3__dlxtp_2 \dig_in_gen[22].dig_in_latch  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .ENA(net2),
    .D(dig_in[22]),
    .Q(\proj_dig_in_unbuf[22] ));
 gf180mcu_as_sc_mcu7t3v3__dlxtp_2 \dig_in_gen[23].dig_in_latch  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .ENA(net2),
    .D(dig_in[23]),
    .Q(\proj_dig_in_unbuf[23] ));
 gf180mcu_as_sc_mcu7t3v3__dlxtp_2 \dig_in_gen[2].dig_in_latch  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .ENA(net4),
    .D(dig_in[2]),
    .Q(\proj_dig_in_unbuf[2] ));
 gf180mcu_as_sc_mcu7t3v3__dlxtp_2 \dig_in_gen[3].dig_in_latch  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .ENA(net3),
    .D(dig_in[3]),
    .Q(\proj_dig_in_unbuf[3] ));
 gf180mcu_as_sc_mcu7t3v3__dlxtp_2 \dig_in_gen[4].dig_in_latch  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .ENA(net3),
    .D(dig_in[4]),
    .Q(\proj_dig_in_unbuf[4] ));
 gf180mcu_as_sc_mcu7t3v3__dlxtp_2 \dig_in_gen[5].dig_in_latch  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .ENA(net3),
    .D(dig_in[5]),
    .Q(\proj_dig_in_unbuf[5] ));
 gf180mcu_as_sc_mcu7t3v3__dlxtp_2 \dig_in_gen[6].dig_in_latch  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .ENA(net1),
    .D(dig_in[6]),
    .Q(\proj_dig_in_unbuf[6] ));
 gf180mcu_as_sc_mcu7t3v3__dlxtp_2 \dig_in_gen[7].dig_in_latch  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .ENA(net1),
    .D(dig_in[7]),
    .Q(\proj_dig_in_unbuf[7] ));
 gf180mcu_as_sc_mcu7t3v3__dlxtp_2 \dig_in_gen[8].dig_in_latch  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .ENA(net1),
    .D(dig_in[8]),
    .Q(\proj_dig_in_unbuf[8] ));
 gf180mcu_as_sc_mcu7t3v3__dlxtp_2 \dig_in_gen[9].dig_in_latch  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .ENA(net1),
    .D(dig_in[9]),
    .Q(\proj_dig_in_unbuf[9] ));
 gf180mcu_as_sc_mcu7t3v3__buff_2 fanout1 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(dig_ena_sel),
    .Y(net1));
 gf180mcu_as_sc_mcu7t3v3__buff_2 fanout2 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(dig_ena_sel),
    .Y(net2));
 gf180mcu_as_sc_mcu7t3v3__buff_2 fanout3 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(dig_ena_sel),
    .Y(net3));
 gf180mcu_as_sc_mcu7t3v3__buff_2 fanout4 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(dig_ena_sel),
    .Y(net4));
 gf180mcu_as_sc_mcu7t3v3__buff_2 fanout5 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\control_base.select ),
    .Y(net5));
 gf180mcu_as_sc_mcu7t3v3__dlybuff_2 hold8 (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .Y(net7),
    .A(\control_base.reset_sync[0] ));
 gf180mcu_as_sc_mcu7t3v3__buff_4 \outbuffers[0]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\control_base.dig_out[0] ),
    .Y(dig_out[0]));
 gf180mcu_as_sc_mcu7t3v3__buff_4 \outbuffers[10]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\control_base.dig_out[10] ),
    .Y(dig_out[10]));
 gf180mcu_as_sc_mcu7t3v3__buff_4 \outbuffers[11]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\control_base.dig_out[11] ),
    .Y(dig_out[11]));
 gf180mcu_as_sc_mcu7t3v3__buff_4 \outbuffers[1]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\control_base.dig_out[1] ),
    .Y(dig_out[1]));
 gf180mcu_as_sc_mcu7t3v3__buff_4 \outbuffers[2]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\control_base.dig_out[2] ),
    .Y(dig_out[2]));
 gf180mcu_as_sc_mcu7t3v3__buff_4 \outbuffers[3]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\control_base.dig_out[3] ),
    .Y(dig_out[3]));
 gf180mcu_as_sc_mcu7t3v3__buff_4 \outbuffers[4]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\control_base.dig_out[4] ),
    .Y(dig_out[4]));
 gf180mcu_as_sc_mcu7t3v3__buff_4 \outbuffers[5]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\control_base.dig_out[5] ),
    .Y(dig_out[5]));
 gf180mcu_as_sc_mcu7t3v3__buff_4 \outbuffers[6]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\control_base.dig_out[6] ),
    .Y(dig_out[6]));
 gf180mcu_as_sc_mcu7t3v3__buff_4 \outbuffers[7]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\control_base.dig_out[7] ),
    .Y(dig_out[7]));
 gf180mcu_as_sc_mcu7t3v3__buff_4 \outbuffers[8]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\control_base.dig_out[8] ),
    .Y(dig_out[8]));
 gf180mcu_as_sc_mcu7t3v3__buff_4 \outbuffers[9]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\control_base.dig_out[9] ),
    .Y(dig_out[9]));
 gf180mcu_as_sc_mcu7t3v3__buff_4 \switchbuffers[0]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\control_base.proj_vbias_ena ),
    .Y(proj_vbias_ena));
 gf180mcu_as_sc_mcu7t3v3__buff_4 \switchbuffers[1]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\control_base.proj_ibias_ena[0] ),
    .Y(proj_ibias_ena[0]));
 gf180mcu_as_sc_mcu7t3v3__buff_4 \switchbuffers[2]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\control_base.proj_ibias_ena[1] ),
    .Y(proj_ibias_ena[1]));
 gf180mcu_as_sc_mcu7t3v3__buff_4 \switchbuffers[3]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\control_base.proj_analog_ena[0] ),
    .Y(proj_analog_ena[0]));
 gf180mcu_as_sc_mcu7t3v3__buff_4 \switchbuffers[4]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\control_base.proj_analog_ena[1] ),
    .Y(proj_analog_ena[1]));
 gf180mcu_as_sc_mcu7t3v3__buff_4 \switchbuffers[5]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\control_base.proj_analog_ena[2] ),
    .Y(proj_analog_ena[2]));
 gf180mcu_as_sc_mcu7t3v3__buff_4 \switchbuffers[6]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\control_base.proj_analog_ena[3] ),
    .Y(proj_analog_ena[3]));
 gf180mcu_as_sc_mcu7t3v3__buff_4 \switchbuffers[7]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\control_base.proj_3v3_ena ),
    .Y(proj_3v3_ena));
 gf180mcu_as_sc_mcu7t3v3__buff_4 \switchbuffers[8]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\control_base.proj_5v0_ena ),
    .Y(proj_5v0_ena));
 gf180mcu_as_sc_mcu7t3v3__buff_8 \userbuffers[0]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\proj_dig_in_unbuf[0] ),
    .Y(proj_dig_in[0]));
 gf180mcu_as_sc_mcu7t3v3__buff_8 \userbuffers[10]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\proj_dig_in_unbuf[10] ),
    .Y(proj_dig_in[10]));
 gf180mcu_as_sc_mcu7t3v3__buff_8 \userbuffers[11]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\proj_dig_in_unbuf[11] ),
    .Y(proj_dig_in[11]));
 gf180mcu_as_sc_mcu7t3v3__buff_8 \userbuffers[12]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\proj_dig_in_unbuf[12] ),
    .Y(proj_dig_in[12]));
 gf180mcu_as_sc_mcu7t3v3__buff_8 \userbuffers[13]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\proj_dig_in_unbuf[13] ),
    .Y(proj_dig_in[13]));
 gf180mcu_as_sc_mcu7t3v3__buff_8 \userbuffers[14]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\proj_dig_in_unbuf[14] ),
    .Y(proj_dig_in[14]));
 gf180mcu_as_sc_mcu7t3v3__buff_8 \userbuffers[15]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\proj_dig_in_unbuf[15] ),
    .Y(proj_dig_in[15]));
 gf180mcu_as_sc_mcu7t3v3__buff_8 \userbuffers[16]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\proj_dig_in_unbuf[16] ),
    .Y(proj_dig_in[16]));
 gf180mcu_as_sc_mcu7t3v3__buff_8 \userbuffers[17]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\proj_dig_in_unbuf[17] ),
    .Y(proj_dig_in[17]));
 gf180mcu_as_sc_mcu7t3v3__buff_8 \userbuffers[18]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\proj_dig_in_unbuf[18] ),
    .Y(proj_dig_in[18]));
 gf180mcu_as_sc_mcu7t3v3__buff_8 \userbuffers[19]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\proj_dig_in_unbuf[19] ),
    .Y(proj_dig_in[19]));
 gf180mcu_as_sc_mcu7t3v3__buff_8 \userbuffers[1]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\proj_dig_in_unbuf[1] ),
    .Y(proj_dig_in[1]));
 gf180mcu_as_sc_mcu7t3v3__buff_8 \userbuffers[20]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\proj_dig_in_unbuf[20] ),
    .Y(proj_dig_in[20]));
 gf180mcu_as_sc_mcu7t3v3__buff_8 \userbuffers[21]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\proj_dig_in_unbuf[21] ),
    .Y(proj_dig_in[21]));
 gf180mcu_as_sc_mcu7t3v3__buff_8 \userbuffers[22]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\proj_dig_in_unbuf[22] ),
    .Y(proj_dig_in[22]));
 gf180mcu_as_sc_mcu7t3v3__buff_8 \userbuffers[23]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\proj_dig_in_unbuf[23] ),
    .Y(proj_dig_in[23]));
 gf180mcu_as_sc_mcu7t3v3__buff_8 \userbuffers[24]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\control_base.proj_reset ),
    .Y(proj_reset));
 gf180mcu_as_sc_mcu7t3v3__buff_8 \userbuffers[25]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\control_base.proj_ena ),
    .Y(proj_ena));
 gf180mcu_as_sc_mcu7t3v3__buff_8 \userbuffers[26]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(proj_clk_unbuf),
    .Y(proj_clk));
 gf180mcu_as_sc_mcu7t3v3__buff_8 \userbuffers[2]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\proj_dig_in_unbuf[2] ),
    .Y(proj_dig_in[2]));
 gf180mcu_as_sc_mcu7t3v3__buff_8 \userbuffers[3]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\proj_dig_in_unbuf[3] ),
    .Y(proj_dig_in[3]));
 gf180mcu_as_sc_mcu7t3v3__buff_8 \userbuffers[4]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\proj_dig_in_unbuf[4] ),
    .Y(proj_dig_in[4]));
 gf180mcu_as_sc_mcu7t3v3__buff_8 \userbuffers[5]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\proj_dig_in_unbuf[5] ),
    .Y(proj_dig_in[5]));
 gf180mcu_as_sc_mcu7t3v3__buff_8 \userbuffers[6]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\proj_dig_in_unbuf[6] ),
    .Y(proj_dig_in[6]));
 gf180mcu_as_sc_mcu7t3v3__buff_8 \userbuffers[7]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\proj_dig_in_unbuf[7] ),
    .Y(proj_dig_in[7]));
 gf180mcu_as_sc_mcu7t3v3__buff_8 \userbuffers[8]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\proj_dig_in_unbuf[8] ),
    .Y(proj_dig_in[8]));
 gf180mcu_as_sc_mcu7t3v3__buff_8 \userbuffers[9]  (.VDD(vddd),
    .VNW(vddd),
    .VPW(vssd),
    .VSS(vssd),
    .A(\proj_dig_in_unbuf[9] ),
    .Y(proj_dig_in[9]));
endmodule
