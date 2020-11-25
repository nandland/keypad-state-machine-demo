// Moore State Machine
// Takes the input keypress, looks for the specific password: 860
// If that is correct, will drive o_Safe_Unlocked high.
// If that is incorrect, will drive o_Safe_Locked high.
// Can be reset at any time by driving i_Reset.

module state_machine
 (input  i_Clk,       // Main Clock
  input  i_Reset,
  input  i_Keypad_DV,
  input [3:0] i_Keypad_Digit,
  output o_Safe_Unlocked,
  output o_Safe_Locked);

reg [2:0] r_SM_Main;

localparam CHECK_DIGIT_1 = 3'b000;
localparam CHECK_DIGIT_2 = 3'b001;
localparam CHECK_DIGIT_3 = 3'b010;
localparam SAFE_UNLOCKED = 3'b011;
localparam SAFE_LOCKED   = 3'b100;

localparam PASSWORD_DIGIT_1 = 4'd8;
localparam PASSWORD_DIGIT_2 = 4'd6;
localparam PASSWORD_DIGIT_3 = 4'd0;

//assign o_Safe_Locked = (r_SM_Main == SAFE_LOCKED) ? 1'b1 : 1'b0;  // Ternary Operator

assign o_Safe_Locked   = (r_SM_Main == SAFE_LOCKED);
assign o_Safe_Unlocked = (r_SM_Main == SAFE_UNLOCKED);

always @(posedge i_Clk)
begin
  if (i_Reset == 1'b1)
  begin
    r_SM_Main <= CHECK_DIGIT_1;
  end
  else
  begin
    if (i_Keypad_DV == 1'b1)
    begin
        case (r_SM_Main)
            CHECK_DIGIT_1: 
            begin
                if (i_Keypad_Digit == PASSWORD_DIGIT_1)
                begin
                    r_SM_Main <= CHECK_DIGIT_2;
                end      
                else
                begin
                    r_SM_Main <= SAFE_LOCKED;
                end
            end

            CHECK_DIGIT_2: 
            begin
                if (i_Keypad_Digit == PASSWORD_DIGIT_2)
                begin
                    r_SM_Main <= CHECK_DIGIT_3;
                end      
                else
                begin
                    r_SM_Main <= SAFE_LOCKED;
                end
            end

            CHECK_DIGIT_3: 
            begin
                if (i_Keypad_Digit == PASSWORD_DIGIT_3)
                begin
                    r_SM_Main <= SAFE_UNLOCKED;
                end      
                else
                begin
                    r_SM_Main <= SAFE_LOCKED;
                end
            end

            SAFE_UNLOCKED:
            begin
                r_SM_Main <= SAFE_UNLOCKED;
            end    
            
            SAFE_LOCKED: 
            begin
                r_SM_Main <= SAFE_LOCKED;
            end

        endcase
    end // i_Keypad_DV
  end
end

endmodule