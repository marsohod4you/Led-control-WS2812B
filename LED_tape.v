`timescale 1ns / 1ps

module LED_tape(
    input wire clk,
    input wire [23:0] RGB,
    output reg data,
    output wire[15:0]num,
	output reg sync,
    output reg req
    );

parameter  NUM_LEDS = 8;
parameter  NUM_RESET_LEDS = 2;
localparam NUM_TOTAL = (NUM_LEDS+NUM_RESET_LEDS);

//3 tick counter
reg [1:0] cnt3 = 2'b0;
always @(posedge clk)
	if (cnt3 == 2'b10)
		cnt3 <= 2'b0;
	else
		cnt3 <= cnt3+1;

//24 tick counter
reg [4:0] cnt24 = 5'b0;
always @(posedge clk)
	if (cnt3 == 2'b10)
		cnt24 <= ( cnt24 == 23 ) ? 5'b0 : cnt24 +1'b1;

reg _req  = 1'b0;
reg req_ = 1'b0;
always @(posedge clk)
begin
	_req <= (cnt3 == 2'b10) & (cnt24 == 22);
	req <= _req;
	req_ <= req;
end


reg [15:0]cntN = 0;
always @(posedge clk)
	if(_req)
	begin
		if( cntN==(NUM_TOTAL) )
			cntN <= 0;
		else
			cntN <= cntN + 1;
	end
assign num = cntN;

reg [23:0]shift_r24;
always @(posedge clk)
	if(req_)
		shift_r24 <= RGB;
	else
	if( cnt3==2'b10 )
		shift_r24 <= { 1'b0, shift_r24[23:1] };

wire hide; assign hide = (cntN>NUM_LEDS & cntN<=(NUM_TOTAL));
always @(posedge clk)
	sync <= hide;
	
always @(posedge clk)
	if( hide )
		data <= 1'b0;
	else
		data <= (cnt3==2'b00) ? 1'b1 :
				(cnt3==2'b01) ? shift_r24[0] : 1'b0;

endmodule
