module L1_DIRECT_CACHE #(parameter CACHE_WIDTH = 32, DATA_WIDTH = 32, )
                        (input logic clk,rst,
                         input logic write_en, read_en,
                         input logic [DATA_WIDTH-1:0] data_in,
                         output logic [DATA_WIDTH-1:0] data_out,
                          );

  logic tag;
  logic offset;
  logic hit_or_miss;
  logic valid;

