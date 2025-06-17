module Ps2_Key(
 input clk, ps2_clk, ps2_data,
 output logic WriteEn,
 output logic [7:0] Code_Key
);

logic [7:0] KEY_ENTER     = 8'h5A; // Enter
logic [7:0] KEY_SPACE     = 8'h29; // Espacio
logic [7:0] KEY_BACKSPACE = 8'h66; // Retroceso (Backspace)
logic [7:0] ARROW_UP    = 8'h75; // Flecha arriba
logic [7:0] ARROW_DOWN   = 8'h72; // Flecha abajo


 logic key_press;
 logic read; // to know if needs more bits
 logic previous_state; // to check clocks changes 
 logic error; // if there on error in the data
 logic full_buffer; //this is 1 when received the 11bits
 logic trigger; // clock slower
 logic holding; // to change the key_code
 
 logic[11:0] read_counter; // to count time passed
 logic[10:0] scan_code; //all the packet
 logic[7:0] key_code; // the 8 bits for the key
 logic[3:0] counter; // bits counter for 0 to 11
 logic[7:0] down_counter; // for the trigger 
 logic[29:0] holding_counter; //time the value will be hold 

 
 
 //set initial values 
 initial begin 
  previous_state = 1; 
  trigger = 0;
  down_counter = 0;
  error = 0;
  scan_code = 0;
  counter = 0;
  key_code = 0;
  read = 0;
  read_counter = 0;
  key_press = 0;

  holding_counter = 8'b0;
  holding = 0; 
  WriteEn = 0;

  
 end
 
 //frequency slower 
 always @(posedge clk) begin
  if(down_counter < 249) begin 
   down_counter <= down_counter + 1;
   trigger <= 0;
  end else begin 
   down_counter <= 0;
   trigger <= 1;
  end
 end
 
 //counter increase 
 always @(posedge clk) begin 
  if(trigger) begin
   if(read) begin 
    read_counter <= read_counter + 1;
   end else begin 
    read_counter <= 0;
   end
  end
 end
 
 // controls the buffer and the scan_code
 always @(posedge clk) begin
  if(trigger) begin 
   // to append the bit to the scaned code 
   if (ps2_clk != previous_state) begin 
    if(!ps2_clk) begin
     read <= 1;
     error <= 0;
     scan_code[10:0] <= {ps2_data, scan_code[10:1]};
     counter <= counter + 1;
    end
   end 
   
    // if the scan_code is complete
   else if (counter == 11)  begin
    counter <= 0;
    read <= 0;
    full_buffer <= 1;
   
    //in case of scan error 
    if (scan_code[10] == 1'b0 && scan_code[0] == 1'b1 && 
   (scan_code[1] ^ scan_code[2] ^ scan_code[3] ^ scan_code[4] ^ 
    scan_code[5] ^ scan_code[6] ^ scan_code[7] ^ scan_code[8] ^ 
    scan_code[9]) == 1'b0) 
     error <= 1;
    else error <= 0;
    
   end
   //if there isnt change in the ps2 clk 
   else begin 
    full_buffer <= 0;
    if(counter < 11 & read_counter >= 4000) begin
     counter <= 0;
     read <= 0;
    end
   end
   
   previous_state <= ps2_clk;
  end
 end
 
 // to update the key_code
 always @(posedge clk)begin 
  if(trigger)begin
   if(full_buffer)begin
    if(error) begin
     key_code <= 8'd0;
    end else begin
     key_code <= scan_code[8:1];
    end
   end else begin
    key_code <= 8'd0;
   end
   
  end else begin
   key_code <= 8'd0;
  end
 end
 
 
 //to update the outputs
 always @(posedge clk)begin
 
  if (key_code == ARROW_UP | key_code == KEY_ENTER | key_code == KEY_BACKSPACE | key_code == KEY_SPACE | key_code == ARROW_DOWN) begin
   key_press = 1'b1;
   
  end else begin
   key_press = 1'b0;
  end
 end
 
 //leds control 
 always @(posedge clk)begin 

  if(key_press)begin
   WriteEn = 1'b1;
   holding = 1'b1;
  end
  
  if(holding)begin
   holding_counter = holding_counter + 1'b1;
  end
  
  if(holding_counter > 10000000)begin
   WriteEn = 1'b0;

   holding = 1'b0;
   holding_counter = 30'b0;
  end
  
  
 end
 


assign Code_Key = key_code;

endmodule
