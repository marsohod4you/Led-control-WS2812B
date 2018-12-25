`timescale 1ns / 1ns

module LED_tape_TB;

// Inputs
reg clk = 0;
always
	begin
		#5;
		clk = ~clk;
	end

// Outputs
wire data;
wire [15:0] w_num;
wire w_req;
wire w_sync;

reg [23:0]rgb = 0;
always @(posedge clk )
	if( w_req )
		rgb <= w_sync ? 0 : { {8{w_num[2]}}, {8{w_num[1]}}, {8{w_num[0]}} };

// Instantiate the Unit Under Test (UUT)
LED_tape #( .NUM_LEDS(7), .NUM_RESET_LEDS(4) )uut (
	.clk(clk), 
	.RGB(rgb), 
	.data(data), 
	.num(w_num), 
	.sync(w_sync),
	.req(w_req)
);

initial begin
	$dumpfile("out.vcd");
	$dumpvars(0,LED_tape_TB);

	#1000000;
	$finish(0);
end

endmodule

