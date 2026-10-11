// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.2 (win64) Build 6299465 Fri Nov 14 19:35:11 GMT 2025
// Date        : Mon Oct 12 00:10:34 2026
// Host        : Eathes running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ bram_weights_rom_sim_netlist.v
// Design      : bram_weights_rom
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "bram_weights_rom,blk_mem_gen_v8_4_12,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_12,Vivado 2025.2" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (clka,
    addra,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_mode = "slave BRAM_PORTA" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [7:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [31:0]douta;

  wire [7:0]addra;
  wire clka;
  wire [31:0]douta;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [31:0]NLW_U0_doutb_UNCONNECTED;
  wire [7:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [7:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "8" *) 
  (* C_ADDRB_WIDTH = "8" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "1" *) 
  (* C_COUNT_36K_BRAM = "0" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     3.375199 mW" *) 
  (* C_FAMILY = "artix7" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "0" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "1" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "bram_weights_rom.mem" *) 
  (* C_INIT_FILE_NAME = "bram_weights_rom.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "3" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "256" *) 
  (* C_READ_DEPTH_B = "256" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "32" *) 
  (* C_READ_WIDTH_B = "32" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "256" *) 
  (* C_WRITE_DEPTH_B = "256" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "32" *) 
  (* C_WRITE_WIDTH_B = "32" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_12 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[31:0]),
        .eccpipece(1'b0),
        .ena(1'b0),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[7:0]),
        .regcea(1'b1),
        .regceb(1'b1),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[7:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[31:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(1'b0),
        .web(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2025.2"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
YqH9kwIC39+qbZg4PSfFsXuB9k9wnuxNryS/CfnEri6Ci9fSC6fsrQ/T/hnt3u/yolbJ8DJa1Qu6
Qnm24A9jLbA+fu3Nsmm6/rM6a4vU6OfVl/gTFd/CiWDutv6Dhn6Lim4uUNPahoOR/A2Yc4Zo2tdI
kMLO9gn9WlH2l3O2oXs=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
XJYO2VHd/cnMxQd3i7/2qRhl57dl+doEKuhAunQyv3vpGRG/jlNxj8PqrgLoF0HMdqE3qJUVE/oq
kBSapqjVjLDMOrNGQ+Tc6VGsKMZH8FE/TXHQJ/IM5Iuiu2eozEwwVUomF+7cfqn+9OsVsqCONQ1M
g0oRlangiqasJDhhMfnlGGqwAwmgWRGQA6dmhTuua1s8zdvIv540zY6p5au8cAKVhqyyKK7wbxEE
SGuFqX+NYoyRV+rfWCcWM+hJEmnWS8LNAKkd13YE2+17sPYzUdZ23DmTxXK6KlAxKFW27CBySUfg
qdNXp2DSs2KAQYih27pBNMuHfGbM/ATFPWFvxg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
lYoEi/e8HsDTz6N11EDe/B/iitERmeYndlCklmCluwgb0N4W80JUGVlkd7NlRZHRNhxaNBJPkcjC
n61nO0tb17NwsMwjbY5TF8JWRYTNw1JXCFacvQYrdKv4/7QNQEtwVGiCLxFhOA8aHlWMZIrc2fri
VRMVWaEBcPwCGorlVIM=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
QEw9fEsWFbdX0OQLvYs/gl+zyEOW3ak9TdQVaq+0AXXOT3LIqF7wDxJ6ZBnlf9mNbdsUVH5tAz1o
H8u7ihJl1L3THEvugW+TS8hkvVbEA9rKO2vV15KAj4Lla7UdFT/xDfe79RFarlLI7yGrubjgdoRi
QWy//UKsffG7IWNwmoSuppWiWB4ZHJtkunNyIkm70JPGyZF62VxJg1MTT+5LUbZG5vZjjuHZud9w
xJaKv1tFP/x8RVqLU5gPOqGqTW7/nKO2S+450Vo4D9vAmBVVcXpaL1EbSmCvQ+qJmcQKtf9qYFRV
Zko08hbpHjPxstqvTDro01jRzB8592m4xU2TWA==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
TC7q853CWBPPJgbRfgDV1lmjUwSAtliljShAyNFg8sfRfwDzchthzoSPH1UCHV++E2JXacEKq1lB
UWsNP92U4Xh0/Gu+6esOI0pJb8I+TRTxyBN1I4cRQEfQHcwfhbSdeH3yX9OV3opLEqYmT37hWU+J
zCawYnxVESI0FtRzEXve9gdEWlrKKckrT/hp4mvxxOjvOkOSQBvy0elgUOqh6mEOZl+JnUbsR+Wm
CoZLE1eefMZy3FnVmyDNPv3JPXi88aLXMyimal0MYFkTiS4XJiGT3eAIMIbksehXY+eYi/KFpZWQ
GHpX+lG3UmiWWLwyPakFwKEHbrBc70AlJ2eV9g==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2025.1-2029.x", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
j9nmCKgjPWNChPbpSW6EWLrMA6oCG2JGPoum8px09v0PEAh0DRXZi0J8HPzXUsZgOEMcKpA7X54u
YFcDDCLAQ+urha/eSPbQYHQh4yGCursxAQ1C6LEyNQ2wJ0eLlO2bJeAl/gof06zqsYVM2lLJVNv5
wao1k2bmgPdfpfY3c9vPD0fSMuZPS41EoRS0cQhO5GTZnKdjxm6tEUL3GnTjB8ynSCIbCJUsMtAX
4FRHNa52gudx5B5fagR+lXgFhE7e++rWTJELr7SYB+r5Es8qZLTpCH8TrQxEkV0rY/+e4sAjNE2D
gHw8GD7VcUtc15B8y1BbVmh29qc8Nd3V2i/miA==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
UkCD6I/Vye4qNoNoa3hIexBXG3xyKUJPAHAjIo7UcNVCDXpMQiYEtPDqExZMfiPlJn2nswCYIfIJ
FYWqMCloKSQyyI/7yZ2EtbyWEklb/P5IyZyvGi6hhFUo/JFTb12b4bK0gZPr+bCDdlVQKTx5GVHz
wptdUJO2omSj8axVMPbLRRtVzlJIZ29dTJ2ATXVXAcBxPnFfHRAMnYYKLeeLExX61vQvpqrkLQHm
XG7hpVzJi56gYKAzxa2BLq072OCVpVS70bfWlhlSTVcSlCrUf+EcarEk4FD8+Ih2NCvrqremG6yn
TtcBn8Xr8M/6zhOYvLi6AD6eArDMKA8n+Ccv8A==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
A5y5QVZU8yjPexRVPioSiAGohCHD5DX5FVobuMyhcgQRExLUhPvnnS8HOtxTj/2IapEcz68gFMGG
Hpi+m725u85/om/Vze9pGIW9Mn328Kz2FIg3W5EvGstfGwY+48LiAGAmTR269JS4lJGVYWYOz7Xk
S8cEsFd2m7j8iyKtARJzD90+UdXq/cIIh725jC9i8nbgxB364zddvm1Z/DF3JRw1qFp6GGcuRai1
KNcJ1j8c9wtIgktpsteU3e5+bxHEw8NT3gWXUFYjm00NDq97Jals8Jjktmum2nQxoF7ivPacfEey
gnSF6jRMkTsZObzc30hAhs0CEtc33hZLhPLHSn8pQ0WyvKJLHdd5s2yckgTZtqxC1Sbwe7WEgNXe
ZMX3pIkz+aoXsAL7GBLyVBMVQcyMoF0w8QGAaTe8sqatABwPqXidYRqNROTf62IYcMpV89XYgaTv
EwIn/oni9KOFd2BFVxRZbFGGC4IjvigsTBUijI+Dk6kVnDh240clGcc4

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Omtp+lCaqUx7Z4qdFj2zrN8LpCkit2eX4hlMtig+ielGm/x4FSZkpjoFmiqdKFPi2eg0pg09MSai
XyGH68UzAR7Xrj8f1jlIoUmMKp4GcxfdqfTeuu7kWGOJEP6cvgTjSJFj2gawDv7f4yZcltnK2x0L
e4GW/rBTmGvZtKWb2ahjINLxPuh3dDaSaWdb+zVgbtyrI5FrjxBkq+aOxSjyNsqnCx1L0uWbxnkl
88NbXN3dTaECXHNm/fsleayM5hKis7kTv9BFajJMGy+BhQlmIYpE+F5zchnTTFUFJZCz1sX9Fc8e
HcY7irB8mR3ajdzjUZLBQEMktp096Nheq3U75A==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
hpeBLwN9x2ZFDwroYLlUe5GjjDepHik2l0c2s3/6S7JPCRkzQSyt2V1Ad/JewAs/QNp5SXSbYYB4
rQl0My1LDMF3xw43r0g2IbcyHVpPhGp0W5msuQdF67afnsRv90iJYWLMI3QkYGCTWAzl4HrLxFSg
3z8XZRK670IcxznOrlvgHmIKsvubZrBkuc1EynrVb9Nw16QnIx2rc4WgcEXeFf+4i1RoYLDd3gXK
NFCNMdtaRYUThunFP6Z4ViZ5UnDmKq+IMhd31jTaqIlWOBDxPI1+v5RJYxIyTbn4rxlKR2fNbl5/
z4OUjBTd+1GH3I2OXlqmAOvIhpe2Z2HH7nZu/A==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Mt2RhTSUwEIEWeNARbyL+EdfS1UF6nPaL/fKl/7oO2gina93egwCWDLl1fbBtkfaPco0cu4MJ9K3
OraAsyHRlY+MNShmJ1LzAIA1LjZx4y55lu9dlQqSUXR7AW7wVbkg1864mK+hM/1XygU0jvebKNW9
B7xSER+asLO6pxi0mt7uC2PHxLPAYEszFhmnap82TtbDGdQ2qtyekY+ngs+N2fAdsblxVwJruiMl
e6XJ127M8N1mYwhWU2HtRpBOSnnKoHgD9fG51XK/rhk8DxT66QnX9uLPB+H25eDupBJGi1Y5o6x8
hOwZiSUVlBLh7brfzevh7+eRn+7es6wBas0+3w==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 18992)
`pragma protect data_block
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
5Wa16fmIdRGO2vI=
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
