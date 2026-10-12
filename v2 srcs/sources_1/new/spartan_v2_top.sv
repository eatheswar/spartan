`timescale 1ns / 1ps

module spartan_v2_top (
    input  logic        clk,         // 100 MHz oscillator
    input  logic        btnC,        // Master Reset
    input  logic        RsRx,        // USB-UART RX
    
    output logic [15:0] led,         // Diagnostic LEDs
    output logic [3:0]  an,          // 7-segment anodes
    output logic [6:0]  seg          // 7-segment cathodes
);

    logic rst;
    assign rst = btnC;
    logic rst_n;
    assign rst_n = ~rst;

    // -------------------------------------------------------------------------
    // 1. UART Data Ingestion (115200 Baud)
    // -------------------------------------------------------------------------
    logic [7:0] rx_byte;
    logic       rx_valid;

    localparam int CLKS_PER_BIT = 868;
    logic [10:0] baud_cnt;
    logic [3:0]  bit_idx;
    logic [7:0]  rx_shift;
    enum logic [1:0] {UART_IDLE, UART_START, UART_DATA, UART_STOP} uart_state;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            uart_state <= UART_IDLE;
            baud_cnt   <= '0;
            bit_idx    <= '0;
            rx_byte    <= '0;
            rx_valid   <= 1'b0;
        end else begin
            rx_valid <= 1'b0;
            case (uart_state)
                UART_IDLE: begin
                    baud_cnt <= '0;
                    bit_idx  <= '0;
                    if (!RsRx) uart_state <= UART_START;
                end
                UART_START: begin
                    if (baud_cnt == (CLKS_PER_BIT / 2)) begin
                        if (!RsRx) begin
                            baud_cnt <= '0;
                            uart_state <= UART_DATA;
                        end else uart_state <= UART_IDLE;
                    end else baud_cnt <= baud_cnt + 1;
                end
                UART_DATA: begin
                    if (baud_cnt == CLKS_PER_BIT - 1) begin
                        baud_cnt <= '0;
                        rx_shift[bit_idx] <= RsRx;
                        if (bit_idx == 3'd7) uart_state <= UART_STOP;
                        else bit_idx <= bit_idx + 1;
                    end else baud_cnt <= baud_cnt + 1;
                end
                UART_STOP: begin
                    if (baud_cnt == CLKS_PER_BIT - 1) begin
                        rx_byte  <= rx_shift;
                        rx_valid <= 1'b1;
                        uart_state <= UART_IDLE;
                    end else baud_cnt <= baud_cnt + 1;
                end
            endcase
        end
    end

    // -------------------------------------------------------------------------
    // 2. UART to AXI4-Stream Master Bridge
    // -------------------------------------------------------------------------
    logic [7:0] axis_tdata;
    logic       axis_tvalid;
    logic       axis_tready;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            axis_tvalid <= 1'b0;
            axis_tdata  <= 8'd0;
        end else begin
            if (rx_valid) begin
                axis_tdata  <= rx_byte;
                axis_tvalid <= 1'b1; // Raise TVALID when UART receives a byte
            end else if (axis_tready && axis_tvalid) begin
                axis_tvalid <= 1'b0; // Lower TVALID after successful AXI handshake
            end
        end
    end

    // -------------------------------------------------------------------------
    // 3. SPARTAN AXI4-Stream Accelerator Core (4-Core SIMD Array)
    // -------------------------------------------------------------------------
    logic fetch_next;
    (* keep = "true" *) logic signed [19:0] array_accumulators [0:3];

    spartan_axis_core #(
        .NUM_CORES(4)
    ) u_axis_core (
        .aclk               (clk),
        .aresetn            (rst_n),
        .s_axis_tdata       (axis_tdata),
        .s_axis_tvalid      (axis_tvalid),
        .s_axis_tready      (axis_tready),
        .fetch_next_out     (fetch_next),
        .array_accumulators (array_accumulators)
    );

    // -------------------------------------------------------------------------
    // 4. Hardware Cycle Profiler
    // -------------------------------------------------------------------------
    logic [15:0] cycle_count_reg;
    logic        counting;

    // The CSR Decoder pulls s_axis_tready LOW for exactly 1 cycle 
    // when it emits the assembled vector to the PE Array.
    logic vector_emitted;
    assign vector_emitted = ~axis_tready;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            cycle_count_reg <= 16'd0;
            counting        <= 1'b0;
        end else begin
            if (vector_emitted && !counting) begin
                cycle_count_reg <= 16'd1;
                counting        <= 1'b1;
            end else if (counting) begin
                if (fetch_next) begin
                    counting <= 1'b0; 
                end else begin
                    cycle_count_reg <= cycle_count_reg + 1'b1;
                end
            end
        end
    end

    assign led[14:0] = cycle_count_reg[14:0];
    assign led[15]   = fetch_next;

    // -------------------------------------------------------------------------
    // 5. 7-Segment Multiplexed Display Unit
    // -------------------------------------------------------------------------
    seven_segment_ctrl display_unit (
        .clk      (clk),
        .rst      (rst),
        .count_in (cycle_count_reg),
        .an       (an),
        .seg      (seg)
    );

endmodule