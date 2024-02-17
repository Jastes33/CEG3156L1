-- This is the data path for the Floating Point Adder
-- Kuan-Yu Chang
-- 300201058
-- University of Ottawa
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY DataPath_FPA IS
    PORT(
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        A : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        B : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        i_sel0, i_sel1, i_controlincdnc, i_SR, i_SL,i_Load : IN STD_LOGIC;
        result : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        overflow : OUT STD_LOGIC
    );
END DataPath_FPA;

ARCHITECTURE rtl of DataPath_FPA IS
    SIGNAL int_expoA : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL int_expoB : STD_LOGIC_VECTOR(6 DOWNTO 0);
    
    SIGNAL int_mantA : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL int_mantB : STD_LOGIC_VECTOR(7 DOWNTO 0);
   
    SIGNAL int_signA <= A(15);
    SIGNAL int_signB <= B(15);
    
    SIGNAL int_signRes : STD_LOGIC; -- sign of the result
    SIGNAL int_expoRes : STD_LOGIC_VECTOR(7 DOWNTO 0); -- exponent of the result
    SIGNAL int_mantRes : STD_LOGIC_VECTOR(7 DOWNTO 0); -- mantissa of the result
    
    SIGNAL int_ediffSign : STD_LOGIC; -- sign of the exponent difference 1 for dcrement and 0 for increment
    SIGNAL int_ediff : STD_LOGIC_VECTOR(6 DOWNTO 0); -- exponent difference
    SIGNAL int_2sediff : STD_LOGIC; -- exponent difference complement
    SIGNAL int_downcnt : STD_LOGIC; -- down counter for exponent difference
    
    SIGNAL int_ge : STD_LOGIC; -- greater exponent
    SIGNAL int_expobefore : STD_LOGIC_VECTOR(7 DOWNTO 0); -- expo before increment or decrement
    SIGNAL int_mantSum : STD_LOGIC_VECTOR(7 DOWNTO 0); -- mantissa sum before mux
    SIGNAL int_ShiftLR : STD_LOGIC_VECTOR(7 DOWNTO 0); -- mantissa sum before shift left or right

    SIGNAL int_overflow : STD_LOGIC; -- overflow signal

    COMPONENT CLA_8 IS
        PORT(
            A : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            load : IN STD_LOGIC;
            CIN : IN STD_LOGIC;
            SUM : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            COUT : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT addSUB IS
        PORT(
            i_operation : IN STD_LOGIC;
            i_xx : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            i_yy : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            o_s : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            o_c: OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT LRShiftreg8 IS
        PORT(
            i_clear , i_Lshift , i_Rshift	: IN	STD_LOGIC;
		    i_clock			: IN	STD_LOGIC;
		    i_data: IN STD_LOGIC_VECTOR(7 downto 0);
		    o_Q			: OUT	STD_LOGIC_VECTOR(7 downto 0)
        );
    END COMPONENT;

    COMPONENT eightBitmux2to1 IS
        PORT(
            i_op0:IN STD_LOGIC_VECTOR(7 downto 0);
		    i_op1:IN STD_LOGIC_VECTOR(7 downto 0);
		    i_selection: IN STD_LOGIC;
		    o_choice:OUT STD_LOGIC_VECTOR(7 downto 0)
        );
    END COMPONENT;

    COMPONENT incdrc_8 IS
        PORT(
            rst: IN	STD_LOGIC;
            clk: IN	STD_LOGIC;
            A: IN STD_LOGIC_VECTOR(7 downto 0);
            B: IN	STD_LOGIC;
            q: OUT	STD_LOGIC_VECTOR(7 downto 0)
        );
    END COMPONENT;

    COMPONENT downcnt_8 IS
        PORT(
           CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
           LOAD : in STD_LOGIC; 
           DATA_IN : in STD_LOGIC_VECTOR(7 downto 0);
           Q : out STD_LOGIC
        ); 
    END COMPONENT;


    COMPONENT Complement_2s IS
        PORT(
            InputNumber : in STD_LOGIC_VECTOR(6 downto 0);
            TwosCompOutput : out STD_LOGIC_VECTOR(6 downto 0)
        );
    END COMPONENT;

    BEGIN
        -- 1. Sign bit
        int_signRes <= int_signA XOR int_signB;

        -- 2. Exponent Difference
        ExpoDiff: addSUB PORT MAP(
            i_operation => '1',
            i_xx[6:0] => int_expoA,
            i_xx[7] => '0',
            i_yy[6:0] => int_expoB,
            i_yy[7] => '0',
            o_s => int_expoRes,
            o_s[8] => int_ediffSign,
            o_c => int_overflow
        );

        -- 3. Mantissa
        -- 3.1. Add the two mantissas
        Mantissa: CLA_8 PORT MAP(
            A => i_mantA,
            B => int_mantB,
            CIN => '0',
            SUM => int_mantSum,
            COUT => int_overflow
        );

        -- 3.2. Shift the smaller mantissa to the right
        ALUshiftR: LRShiftreg8 PORT MAP(
            i_clear => '0',
            i_Lshift =>'0',
            i_Rshift => int_downcnt,
            i_clock => clk,
            i_data => int_mantA,
            o_Q => int_mantA,
            '0' => int_mantA[7]
        );

        -- 4. Muxes
        -- 4.1 Mux for the smaller value of the mantissas
        MuxforBigALUShiftR: eightBitmux2to1 PORT MAP(
            i_op0 => A[7:0],
            i_op1 => B[7:0],
            i_selection => int_ediffSign,
            o_choice => int_mantA
        );
        
        -- 4.2 Mux for the bigger value of the mantissas
        MuxforBigALU: eightBitmux2to1 PORT MAP(
            i_op0 => A[7:0],
            i_op1 => B[7:0],
            i_selection => not int_ediffSign,
            o_choice => int_mantB
        );

        -- 4.3 Mux for choosing the greater Exponent
        MuxforExpo: eightBitmux2to1 PORT MAP(
            i_op0[6:0] => int_expoA,
            i_op1[6:0] => int_expoB,
            i_selection => int_ediffSign,
            o_choice => int_ge
        );
        --4.4 Mux for choosing which to be the exponent before increment or decrement
        MuxforExpo: eightBitmux2to1 PORT MAP(
            i_op0 => int_ge,
            i_op1 => int_expoRes,
            i_selection => i_sel0,
            o_choice => int_expobefore
        );

        --4.5 Mux for the mantissa result
        MuxforRes: eightBitmux2to1 PORT MAP(
            i_op0 => int_mantSum,
            i_op1 => int_mantRes,
            i_selection => i_sel1,
            o_choice => int_ShiftLR
        );

        --4.6 Mux for complementing the exponent difference
        MuxforComplement: eightBitmux2to1 PORT MAP(
            i_op0 => int_ediff,
            i_op1 => int_2sediff,
            i_selection => int_ediffSign,
            o_choice => int_ediff
        );

        -- 5. Increment or Decrement the Exponent
        IncDecExpo: incdrc_8 PORT MAP(
            rst => reset,
            clk => clk,
            A => int_expobefore,
            B => i_controlincdnc, -- 1 to increment the exponent and 0 to decrement
            q => int_expoRes
        );

        -- 6. Shift left or right the mantissa
        ALUShiftLorR: LRShiftreg8 PORT MAP(
            i_clear => '0',
            i_Lshift => i_SL,
            i_Rshift => i_SR,
            i_clock => clk,
            i_data => int_ShiftLR,
            o_Q => int_mantRes,
        );

        --7. Result for Sum of Floating Point Adder
        result[15] <= int_signRes;
        result[14:8]<= int_expoRes[6:0];
        result[7:0] <= int_mantRes;


        --8. down counting the Ediff
        DownCountEdiff: downcnt_8 PORT MAP(
            CLK => clk,
            RESET => reset,
            LOAD => i_Load,
            DATA_IN => int_ediff,
            Q => int_downcnt
        );
        
        
        --9. Complementing the Ediff
        ComplementEDiff: Complement_2s PORT MAP(
            InputNumber => int_ediff,
            TwosCompOutput => int_2sediff
        );

        
