//////////////////////////////////////////////////////////////////////////////////
// Company:       UCD School of Electrical and Electronic Engineering
// Engineer:      Brian Mulkeen
// Project:       Switch Signal Cleanup Design assignment
// Target Device: XC7A100T-csg324 on Digilent Nexys-4 board
// Description:   Hardware testbench for switch signal cleanup design.
//                Defines top-level input and output signals (see comments on ports).
//                Uses a 16-bit counter to show the effect of button inputs:
//                  BTNU goes through the cleanup system to be tested;
//                  BTNC enables the counter directly;
//                  BTND goes though a simple rising edge detector.
//                Instantiates clock and reset generator block, for 5 MHz clock.
//                Instantiates the cleanup system to be tested.
//                Instantiates a display interface to show the count value.
//  Created: 8 October 2016
//  Major changes 2 November 2020, to suit new assignment
//////////////////////////////////////////////////////////////////////////////////
module CleanupHardwareTest (
    input clk100,              // 100 MHz clock from oscillator on board
    input rstPBn,              // reset signal, active low, from CPU RESET pushbutton
    input btnU, btnC, btnD,    // signals from pushbuttons, active high
    output [3:0] JA,           // output for viewing on oscilloscope
    output [7:0] digit,        // digit controls - active low (7 on left, 0 on right)
    output [7:0] segment);     // segment controls - active low (a b c d e f g p)

// ===========================================================================
// Internal Signals
    wire clk5;              // 5 MHz clock signal, buffered
    wire reset;             // internal reset signal, active high
    reg [15:0] count;       // counter output signal
    wire up, edg, enable;   // counter control signals
    reg [1:0] shifter;      // shift register for edge detector    

// ===========================================================================
// Assign signals to the test port for viewing on oscilloscope
    assign JA = {edg, btnD, btnU, enable};
        
// ===========================================================================
// Generate the enable signal for the counter
    assign enable = up | btnC | edg;  // any of 3 signals

//=====================================================================================
// 16-bit counter 
    always @(posedge clk5)
        if (reset)
            count <= 16'd0;  // reset to zero
        else if (enable)
            count <= count + 16'd1;    // count up if enabled

//=====================================================================================
// Simple rising edge detector - behaviour after reset not important
    always @(posedge clk5)
        if (reset)
            shifter <= 2'b0;     // clear shift register on reset
        else
            shifter <= {btnD, shifter[1]}; // shift right

    assign edg = shifter[1] & ~shifter[0];  // detect rising edge 

// ===========================================================================
// Instantiate clock and reset generator, connect to signals
    clockReset clkGen (
        .clk100 (clk100),       // input clock at 100 MHz
        .rstPBn (rstPBn),       // input reset, active low
        .clk5   (clk5),         // output clock, 5 MHz
        .reset  (reset));       // output reset, active high

// ==================================================================================
// Instantiate your display interface here.  Use count as the value to be displayed.
// Keep all the dots turned off (connect the dots port to a constant 0000).
// Use the 5 MHz clock signal, clk5, and the active high reset signal, reset.

    Design_Interface interface (.clock(clk5), .reset(reset), .value(count), .dots(4'b0000), .segment(segment), .digit(digit));
// ===========================================================================
// Instantiate your cleanup module here.  Connect btnU to the raw input.
// Connect the clean output to the up signal.
// Use the 5 MHz clock signal, clk5, and the active high reset signal, reset.
    Clean_pulse clean (.clock(clk5), .reset(reset), .raw(btnU), .clean(up));

endmodule