`timescale 1ns / 1ps
module Clean_Pulse_TB;

    // Inputs to module being verified
    reg clock, reset, raw;
    
    // Outputs from module being verified
    wire clean, enable, delay;
    
    // Instantiate module
    Clean_pulse uut (
        .clock(clock),
        .reset(reset),
        .raw(raw),
        .clean(clean),
        .enable(enable),
        .delay(delay)
    );
    initial
		begin
			clock  = 1'b1;
			forever
				#100 clock  = ~clock ;
		end
	initial
		begin
			reset = 1'b0;
			#150
			reset = 1'b1;
			#800
			reset = 1'b0;
			#15500
			reset = 1'b1;
			#1200
			reset = 1'b0;
			#30000
			reset = 1'b1;
			#30000
			reset = 1'b0;
		end
	initial
		begin
			raw = 1'b0;
			#1450
			raw = 1'b1;
			#200
			raw = 1'b0;
			#300
			raw = 1'b1;
			#300
			raw = 1'b0;
			#300
			raw = 1'b1;
			#600
			raw = 1'b0;
			#500
			raw = 1'b1;
			#25500
			raw = 1'b0;
			#300
			raw = 1'b1;
			#200
			raw = 1'b0;
			#200
			raw = 1'b1;
			#700
			raw = 1'b0;
			#500
			raw = 1'b1;
			#200
			raw = 1'b0;
			#20000
			raw = 1'b1;
			#200
			raw = 1'b0;
			#300
			raw = 1'b1;
			#300
			raw = 1'b0;
			#300
			raw = 1'b1;
			#600
			raw = 1'b0;
			#500
			raw = 1'b1;
			#15000
			raw = 1'b0;
			#300
			raw = 1'b1;
			#200
			raw = 1'b0;
			#200
			raw = 1'b1;
			#700
			raw = 1'b0;
			#500
			raw = 1'b1;
			#200
			raw = 1'b0;
			#10000
		    $stop;
		end

endmodule