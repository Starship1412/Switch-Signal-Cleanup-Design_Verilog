/* 16-bit counter module -
To count the number of cycles to pass minimum requirements of bounce region.*/ 

module bit_counter (
    input clk,         // input ports 
    input rst,
    input enable,
    output delay);     // output delay 
                      
    reg [15:0] counter, next;             

    always @(posedge clk)  // Synchronous reset, waits for clock
        begin
            if (rst)
                counter <= 16'b0;   
            else
                counter <= next;          // logic for next value        
        end 
        
    always @(counter or enable)
        begin 
            if (enable)
                next = 1'b1 + counter;    // if enable is 1, we increment
            else
                next = 16'b0;             // otherwise, input next is 0
        end
    
    assign delay = (counter == 16'd50);   // delay is 1 if the counter reaches desired value

endmodule