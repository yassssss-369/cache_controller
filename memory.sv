`timescale 1ns/1ns
//-----------------------------------------------------------
// Module    : memory_single_port.sv
// Author    : Yash Prasad
// Description: Synthesizable single-port memory with
//              parameterized width and depth
//-----------------------------------------------------------

module memory #(
  parameter MEM_WIDTH = 1024,                // total number of blocks
  parameter BLOCK_SIZE = 64,               //  block size
  parameter BLOCK_OFFSET_BITS = 1,         // log2(words per block) = 1 for 2-word blocks
  parameter BLOCK_ADDR_BITS = $clog2(BLOCK_SIZE)  // block address width
)
  (
  input logic clk,rst,
  input logic write_en,read_en,
  input logic [MEM_WIDTH-1:0] data_in,
  input logic [BLOCK_OFFSET_BITS-1:0] word_offset,
  input logic [BLOCK_ADDR_BITS-1:0] block_addr,
  output logic [MEM_WIDTH-1:0] data_out

  );
  typedef enum logic [1:0] {
    IDLE = 2'b00,
    READ = 2'b01,
    WRITE = 2'b10
  } state_t;
  state_t state, next_state;

  logic [MEM_WIDTH-1:0] mem [BLOCK_SIZE-1];
 //  logic [ADDRESS_PTR-1:0] mem_addr;
 //
  logic [$clog2(MEM_WIDTH)+ BLOCK_OFFSET_BITS - 1:0]mem_addr;
  assign mem_addr = {block_addr,word_offset};
  always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
      for (int i = 0; i < BLOCK_SIZE; i++) begin
        mem[i] <= 1'b0;
      end

    end
    else begin
      state <= next_state;
       
      case (next_state)
        WRITE: mem[mem_addr] <= data_in;
        READ : data_out <= mem[mem_addr];
        default: data_out <= 32'b0 ; // do nothing
      endcase
   
    end
  end

  always_comb begin  
    case(state)
      IDLE: begin
        if (write_en) begin
          next_state = WRITE;
        end else if (read_en) begin
          next_state = READ;
        end else begin
          next_state = IDLE;
          
        end
      end

      WRITE: begin
        // mem[mem_addr] <= data_in;
        next_state = IDLE;
      end

      READ: begin
        // data_out = mem[mem_addr];
        next_state = IDLE;
      end

      default: next_state = IDLE;
      endcase
  end
endmodule 
