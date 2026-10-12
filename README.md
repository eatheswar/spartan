# SPARTAN v2.0: Sparsity-Aware Tensor Accelerator Node

![FPGA Target](https://img.shields.io/badge/Target-Xilinx_Artix--7-blue)
![Language](https://img.shields.io/badge/Language-SystemVerilog-orange)
![Interface](https://img.shields.io/badge/Interface-AXI4--Stream-success)
![Status](https://img.shields.io/badge/Status-Silicon_Proven-success)

**SPARTAN v2.0** is a professional-grade, multi-core edge AI accelerator designed for Xilinx Artix-7 FPGAs. Building upon the zero-skipping logic of v1.0, this upgraded architecture eliminates I/O bottlenecks using **Compressed Sparse Row (CSR)** hardware decoding and an industry-standard **AMBA AXI4-Stream** interconnect. By broadcasting compressed activations to a 4-Core SIMD (Single Instruction, Multiple Data) array, SPARTAN v2.0 quadruples mathematical throughput while actively preventing bandwidth waste over the serial line.

---

## 🚀 Key Innovations (v2.0)

- **AXI4-Stream IP Integration:** Replaced the rigid UART pipeline with a standardized `TVALID`/`TREADY` handshake, enabling native backpressure, zero-packet-drop elastic buffering, and seamless integration into modern SoC Block Designs (e.g., alongside ARM Cortex processors).
- **CSR Hardware Decoder:** A combinational priority-encoder front-end that accepts a 4-bit sparsity mask, dynamically routes incoming non-zero bytes to their correct mathematical slots, and zero-pads the rest in a single clock cycle.
- **4-Core SIMD Tensor Array:** A parameterized generation of parallel Processing Elements (PEs) that execute 4 unique weight filters against the exact same incoming activation vector simultaneously, multiplying peak throughput by 4x.
- **Zero-Bandwidth Waste:** The companion Python software strips zero-value pixels before transmission. If an image patch is fully black, the host sends a single `0x00` mask byte, and the hardware advances in 1 clock cycle—saving 4 bytes of serial bandwidth.

---

## 🔬 Performance & Efficiency Deltas

To rigorously prove the architectural scaling, SPARTAN v2.0 was synthesized, physically flashed, and benchmarked against both the Dense Baseline and the v1.0 Sparse core on the Basys 3 (XC7A35T) FPGA. 

**Benchmark Condition:** A 4-element input vector with 50% sparsity (e.g., `[4, 3, 0, 0]`). Clock speed: 100 MHz.

| Metric | Dense Baseline (Standard MAC) | SPARTAN v1.0 (Single Core) | SPARTAN v2.0 (4-Core AXI Array) |
| :--- | :--- | :--- | :--- |
| **Data Interface** | Raw UART (Rigid) | Raw UART (Rigid) | **AXI4-Stream (Elastic)** |
| **Host Tx Payload** | 4 Bytes (Sends Zeros) | 4 Bytes (Sends Zeros) | **3 Bytes (CSR Compressed)** |
| **Compute Cores** | 1 Core | 1 Core | **4 Cores (SIMD Broadcasting)** |
| **Execution Latency**| 4 Clock Cycles | 2 Clock Cycles | **4 Clock Cycles (Inc. AXI Handshake)** |
| **Operations Completed** | 1 Vector × 1 Filter | 1 Vector × 1 Filter | **1 Vector × 4 Filters Simultaneously** |
| **Peak Throughput** | 100 Mega-MACs/sec | 100 Mega-MACs/sec | **400 Mega-MACs/sec** |

*Note: While v2.0 registers 4 cycles of latency due to the AXI protocol pipeline buffer, it computes 4 times the amount of math in that identical timeframe, yielding a massive net gain in tensor throughput.*

---

## 🏗️ System Architecture

The v2.0 hardware pipeline consists of three perfectly decoupled subsystems:

### 1. The Bridge (UART to AXI Master)
Acts as the Host-to-FPGA translator. It buffers the 115200 baud serial data and asserts the `s_axis_tvalid` signal only when a byte is fully formed, creating an asynchronous reservoir for the compute engine.

### 2. AXI4-Stream CSR Decoder
- Receives the incoming AXI stream. The first byte is always the **Sparsity Mask** (e.g., `0b0011`).
- Uses a hardware popcount to determine exactly how many non-zero bytes are following.
- Routes the incoming bytes directly into the 32-bit `act_vec` and drops `s_axis_tready` low to pause the PC if the SIMD array is currently computing.

### 3. Multi-Core SIMD Execution Array
- Upon receiving the `vector_ready` flag and the sparsity mask from the CSR decoder, all 4 cores fire in lockstep.
- Each core utilizes a priority encoder to instantly hop between non-zero indices, bypassing the DSP pipeline for zeros.
- Core 0 computes Filter 0, Core 1 computes Filter 1, etc. Once the mask clears to `0000`, the array universally triggers `fetch_next` to pull the next vector from the AXI decoder.

---

## 💻 Software Bridge & Python Compressor

The repository includes a custom PC interface (`stream_sparse.py`) that acts as the software counterpart to the hardware CSR decoder. 

1. Opens a target image (or live camera feed) using `OpenCV`/`Pillow`.
2. Flattens the image into 4-pixel tensor vectors.
3. Evaluates the vector for zero-values.
4. Generates a 1-byte bitmask and packages *only* the non-zero bytes into a custom payload.
5. Streams the compressed payload over PySerial to the FPGA, dramatically reducing USB bandwidth overhead.

### Running the Live Demo
1. Flash the `spartan_v2_top.bit` bitstream to the Basys 3 board.
2. Press the **Center Button** (`btnC`) on the board to assert the Master Reset.
3. Run the Python compressor:
   ```bash
   python stream_sparse.py
