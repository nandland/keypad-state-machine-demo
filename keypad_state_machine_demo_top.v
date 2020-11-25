// TOP OF THE DESIGN

module keypad_state_machine_demo_top
 (input  i_Clk,       // Main Clock
  
  input  io_PMOD_7,   // Mapped to Row3
  input  io_PMOD_8,   // Mapped to Row2
  input  io_PMOD_9,   // Mapped to Row1
  input  io_PMOD_10,  // Mapped to Row0

  output io_PMOD_1,   // Mapped to Col3
  output io_PMOD_2,   // Mapped to Col2
  output io_PMOD_3,   // Mapped to Col1
  output io_PMOD_4,   // Mapped to Col0

  // 7-Segment Displays, Segment1 is upper digit
  output o_Segment1_A,
  output o_Segment1_B,
  output o_Segment1_C,
  output o_Segment1_D,
  output o_Segment1_E,
  output o_Segment1_F,
  output o_Segment1_G,
 
  // Switch Input (Used to reset the internal state machine)
  input i_Switch_1,

  // LED Outputs
  output o_LED_1,
  output o_LED_2, 
  output o_LED_3,
  output o_LED_4);

reg [3:0] r_Decode_Out;
reg r_Decode_DV;
wire [3:0] w_Decode_Out;
wire [3:0] w_Row, w_Col;
wire w_Segment1_A;
wire w_Segment1_B;
wire w_Segment1_C;
wire w_Segment1_D;
wire w_Segment1_E;
wire w_Segment1_F;
wire w_Segment1_G;

// Building up a 4 bit wire using concatenation
//assign w_Row = {io_PMOD_7, io_PMOD_8, io_PMOD_9, io_PMOD_10};
assign w_Row = {io_PMOD_10, io_PMOD_9, io_PMOD_8, io_PMOD_7};

// Assigning each PMOD output to a single bit of w_Col
assign io_PMOD_1 = w_Col[0]; // bit 3 
assign io_PMOD_2 = w_Col[1]; 
assign io_PMOD_3 = w_Col[2];
assign io_PMOD_4 = w_Col[3];

always @(posedge i_Clk)
begin
  r_Decode_Out <= w_Decode_Out;

  if (r_Decode_Out != w_Decode_Out)
  begin
    r_Decode_DV <= 1'b1;
  end
  else 
  begin
    r_Decode_DV <= 1'b0;
  end

end

  // Note: Alternative method of generating data-valid pulse
  // This would create a DV pulse 1 clock cycle earlier than r_Decode_DV
  // assign w_Decode_DV = (r_Decode_Out != w_Decode_Out);


// Decoder communicates with the KEYPAD to pull in decoded digit
Decoder Decoder_Inst
 (.clk(i_Clk),
  .Row(w_Row),   // input
  .Col(w_Col),   // output
  .DecodeOut(w_Decode_Out));


state_machine safe_password_checker_inst
 (.i_Clk(i_Clk),       // Main Clock
  .i_Reset(i_Switch_1),
  .i_Keypad_DV(r_Decode_DV),
  .i_Keypad_Digit(w_Decode_Out),
  .o_Safe_Unlocked(o_LED_1),
  .o_Safe_Locked(o_LED_4)
  );

  // Binary to 7-Segment Converter for Upper Digit
  Binary_To_7Segment SevenSeg1_Inst
  (.i_Clk(i_Clk),
   .i_Binary_Num(w_Decode_Out),
   .o_Segment_A(w_Segment1_A),
   .o_Segment_B(w_Segment1_B),
   .o_Segment_C(w_Segment1_C),
   .o_Segment_D(w_Segment1_D),
   .o_Segment_E(w_Segment1_E),
   .o_Segment_F(w_Segment1_F),
   .o_Segment_G(w_Segment1_G));
   
  assign o_Segment1_A = ~w_Segment1_A;
  assign o_Segment1_B = ~w_Segment1_B;
  assign o_Segment1_C = ~w_Segment1_C;
  assign o_Segment1_D = ~w_Segment1_D;
  assign o_Segment1_E = ~w_Segment1_E;
  assign o_Segment1_F = ~w_Segment1_F;
  assign o_Segment1_G = ~w_Segment1_G;
  
endmodule