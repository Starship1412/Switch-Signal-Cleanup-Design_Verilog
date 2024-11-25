 /* Switch Signal Cleanup Design - Clean pulse 
 Required to generate an output pulse in reponse to signal from an input of a push button switch.
 The pulse is synchonised with the clock. This solution uses a Moore state machine, helped by a 
 counter.*/

module Clean_pulse (
    input clock,  // input ports  
    input raw,
    input reset,
    output clean,
    output enable,
    output delay); // output ports 

    // =========== State Machine ================
    reg [2:0] current_state, next_state;
    localparam [2:0] 
    IDLE = 3'b000,          // Initial State
    PRESSED = 3'b001,       // Button has been pressed
    ON = 3'b010,            // Button was pressed and waiting for fixed time (=7ms)
    WAITING = 3'b011,       // Waiting until the button is released
    RELEASED = 3'b100;      // Button is released
 
    // Output logic
    // Outputs at ON and RELEASED states
    assign enable = current_state == ON || current_state == RELEASED || current_state == PRESSED;
    
    // Outputs at PRESSED state
    assign clean = current_state == PRESSED;
    
    // State Register
    always @(posedge clock)      // reset will be synchronous
        if (reset)
            current_state <= IDLE;
        else
            current_state <= next_state;

    // Next state logic 
    always @(current_state, raw, delay)
        case (current_state)
            IDLE:
                if (raw)
                    next_state = PRESSED;       // go to PRESSED if raw is high
                else
                    next_state = IDLE;
            PRESSED:
                next_state = ON;                // go to ON regardless of inputs
            ON:
                if (delay)
                    next_state = WAITING;       // go to WAITING if delay is high
                else
                    next_state = ON;
            WAITING:
                if (!raw)
                    next_state = RELEASED;      // go to RELEASED if raw is low
                else
                    next_state = WAITING;
            RELEASED:
                if (delay)
                    next_state = IDLE;          // go to IDLE if delay is high 
                else
                    next_state = RELEASED;
            // go to IDLE from RELEASED or unused state 
            default next_state = IDLE;
        endcase
    // Instantiation 16-bit counter
    bit_counter counter_16 (.clk(clock), .rst(reset), .enable(enable), .delay(delay)); 

endmodule