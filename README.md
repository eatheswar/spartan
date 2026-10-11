# SPARTAN: Sparsity-Aware Tensor Accelerator Node

![FPGA Target](https://img.shields.io/badge/Target-Xilinx_Artix--7-blue)
![Language](https://img.shields.io/badge/Language-SystemVerilog-orange)
![Interface](https://img.shields.io/badge/Interface-UART-lightgray)
![Status](https://img.shields.io/badge/Status-Silicon_Proven-success)

**SPARTAN** is a custom, zero-skipping edge AI accelerator designed from scratch for Xilinx Artix-7 FPGAs. It optimizes neural network convolutions by exploiting L1-regularized sparse weight matrices. By dynamically bypassing zero-value multiply-accumulate (MAC) operations, SPARTAN significantly reduces clock cycles and dynamic power consumption compared to traditional dense accelerators.

---

## 🚀 Key Innovations

* **Zero-Skipping Compute Engine:** A custom state machine that detects zero-weights and bypasses the DSP pipeline, reducing compute latency by up to **33.3%** compared to dense architectures.
* **End-to-End Live Data Pipeline:** Integrated PC-to-FPGA bridge utilizing a custom UART receiver to stream 8-bit image data (static or live webcam) directly into the hardware activation buffer.
* **Cycle-Accurate Profiling:** Built-in hardware cycle-counters mapped to onboard LEDs for real-time latency benchmarking.

---

## 🏗️ System Architecture

The hardware pipeline consists of three primary subsystems operating at 100 MHz:

### 1. Data Ingestion (UART to Buffer)
* A custom `uart_rx` module operates at 115200 baud to receive continuous 8-bit pixel data from a host PC.
* Incoming data is cascaded into a 32-bit shift register (`act_vec_buffer`), packing four INT8 activations before triggering the compute engine.

### 2. Memory Subsystem
* **Weight BRAM:** Stores L1-regularized, pre-trained network weights. Initialized via global synthesis.
* **Activation Buffer:** Holds the streaming input vector. 

### 3. Sparse Compute Engine (The Datapath)
* Upon receiving the `rx_valid` flag from the UART module, the state machine fetches the first weight.
* **If Weight == 0:** The clock cycle increments, but the MAC is disabled (Zero-Skip).
* **If Weight != 0:** The activation is multiplied by the weight and added to the accumulator.
* Once the vector is processed, a `done` signal is raised, and the total clock cycles are latched to the LED output.

---

## 📊 Hardware Performance Results

| Metric | Dense Accelerator (Baseline) | SPARTAN Accelerator | Improvement |
| :--- | :--- | :--- | :--- |
| **Target Device** | Xilinx Artix-7 (Basys 3) | Xilinx Artix-7 (Basys 3) | - |
| **Clock Speed** | 100 MHz | 100 MHz | - |
| **Execution Latency** | 36 Cycles (360 ns) | 24-27 Cycles (240-270 ns) | **~33.3% Reduction** |

> **Note:** Every time a DSP48E1 slice on the Artix-7 toggles to multiply by zero, it burns dynamic (switching) power. By physically bypassing the multiplier when a zero weight is detected, SPARTAN actively lowers the dynamic power consumption of the FPGA.

---

## 🔮 Future Work

As the SPARTAN architecture scales, the following hardware upgrades are planned:

* **CSR/RLE Memory Compression:** Currently, zero-weights still consume physical BRAM space. Implementing Compressed Sparse Row (CSR) or Run-Length Encoding (RLE) memory controllers will allow significantly larger neural networks to fit onto the heavily constrained Basys 3 hardware.
* **Matrix Scale-Up:** Expanding the activation buffer and state machine to process larger convolution windows (e.g., 3x3, 5x5) and deeper network layers.
* **Parallel MAC Units:** Deploying multiple DSP slices to process non-zero multiply-accumulate operations simultaneously rather than sequentially.
* **AXI4-Stream Integration:** Upgrading the PC-to-FPGA ingestion pipeline from UART to an AXI4-Stream interface to support high-bandwidth, direct memory access (DMA) integration with soft-core processors (like RISC-V).

---

## 💻 Software Bridge & Demo

The repository includes a Python-based PC interface (`stream_pixels.py` and `live_camera.py`) that utilizes `pyserial` and `OpenCV`/`Pillow`. It converts standard image files or live webcam feeds into INT8 vectors and streams them directly into the FPGA for real-time hardware inference.

### Running the Live Video Demo

1. Flash the SPARTAN bitstream to the Basys 3 board.
2. Press the **Up Button** (`btnU`) on the board to reset the hardware state machine.
3. Install the required Python dependencies:
   ```bash
   pip install pyserial opencv-python pillow
