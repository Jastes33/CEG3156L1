--Lab1 CEG3156
--Alexander Wilson 300219585

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY FPmultiplier IS
	PORT(
	i_signA, i_signB, i_GClock, i_GReset: IN STD_logic;
	i_MantissaA, i_MantissaB: IN STD_logic_VECTOR(7 downto 0);
	i_ExponentA, i_ExponentB: IN STD_logic_VECTOR(6 downto 0);
	o_Signout, o_overflow: OUT STD_logic;
	o_MantissaOut: OUT STD_logic_VECTOR(7 downto 0);
	o_ExponentOut : OUT STD_logic_VECTOR(6 downto 0)
	);
		
END FPmultiplier;

Architecture rtl OF FPmultiplier IS

SIGNAL int_EXPA, int_EXPB,  int_EXPSum, int_EXPSumo, int_MANTA, int_MANTB: STD_LOGIC_VECTOR(7 downto 0);
SIGNAL int_EXPCarr, int_Lshift1,  int_Rshift1, int_shiftingM: STD_LOGIC;
SIGNAL int_Product, int_ProductOut : STD_LOGIC_VECTOR (15 downto 0);

COMPONENT multiplier
	PORT(
	i_multiplicand, i_multiplier : in STD_logic_VECTOR(7 downto 0);
	i_clk, i_clear , i_rshift: IN STD_logic;
	o_mux : out std_LOGIC;
	o_product: out STD_logic_VECTOR(15 downto 0);
	o_sreg, o_reg, o_alu : OUT STD_LOGIC_VECTOR (7 downto 0));
	
END COMPONENT;

COMPONENT SHIFTLR16bit
	PORT(
		i_clear , i_Lshift , i_Rshift	: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_data: IN STD_LOGIC_VECTOR(15 downto 0);
		o_Q			: OUT	STD_LOGIC_VECTOR(15 downto 0));
		
END COMPONENT;

COMPONENT LRShiftreg8
	PORT(
		i_clear , i_Lshift , i_Rshift	: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_data: IN STD_LOGIC_VECTOR(7 downto 0);
		o_Q			: OUT	STD_LOGIC_VECTOR(7 downto 0));
		
END COMPONENT;

COMPONENT eightBitmux2to1 IS
	PORT(
		i_op0:IN STD_LOGIC_VECTOR(7 downto 0);
		i_op1:IN STD_LOGIC_VECTOR(7 downto 0);
		i_selection: IN STD_LOGIC;
		o_choice:OUT STD_LOGIC_VECTOR(7 downto 0));
END COMPONENT;
COMPONENT reg8
	PORT(
		i_clear	: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_data: IN STD_LOGIC_VECTOR(7 downto 0);
		o_Q			: OUT	STD_LOGIC_VECTOR(7 downto 0));
		
END COMPONENT;

COMPONENT addSUB
	PORT(
	i_xx, i_yy : IN STD_logic_vector(0 to 7);
	--i_cinBit :IN STD_logic;
	i_operation: IN STD_logic;
	o_s:OUT STD_logic_vector(0 to 7);
	o_c:OUT STD_logic);
	
END COMPONENT;

BEGIN 

SignAndExponentA : reg8
	PORT MAP(
		i_clear => i_GReset,
		i_clock => i_GClock,
		i_data(7) => i_signA,
		i_data(6 downto 0) => i_exponentA,
		o_Q => int_EXPA
		);
MantisaA : reg8
	PORT MAP(
		i_clear => i_GReset,
		i_clock => i_GClock,
		i_data => i_MantissaA,
		o_Q => int_MANTA	
		);
SignAndExponentB : reg8
	PORT MAP(
		i_clear => i_GReset,
		i_clock => i_GClock,
		i_data(7) => i_SignB,
		i_data(6 downto 0) => i_exponentB,
		o_Q => int_EXPB
		);
MantisaB : reg8
	PORT MAP(
		i_clear => i_GReset,
		i_clock => i_GClock,
		i_data => i_MantissaB,
		o_Q => int_MANTB
		);
smallALU : addSUB
	PORT MAP(
	i_xx(7) => '0',
	i_xx(0 to 6) => int_EXPA(6 downto 0), 
	i_yy(7) => '0',
	i_yy(0 to 6) =>  int_EXPB(6 downto 0),
	i_operation => '1',
	o_s => int_EXPSum,
	o_c => int_EXPCarr
	);
	
Exponent: reg8
	PORT MAP(
		i_clear => i_GReset,
		i_clock => i_GClock,
		i_data => int_EXPSum,
		o_Q => int_EXPSumo
		);

BIGALU : multiplier
	PORT MAP(
	i_multiplicand => int_MANTA,
	i_multiplier => int_MANTB,
	i_clk => i_GClock,
	i_clear => i_GReset,
	i_rshift => int_shiftingM,
	o_product => int_product
	);

bigALUout : SHIFTLR16bit
	PORT MAP(
		i_clear => i_GReset,
		i_Lshift => int_Lshift1 ,
		i_Rshift	=> int_Rshift1,
		i_clock	=> i_GClock,
		i_data => int_Product,
		o_Q	=> int_ProductOut
		);

SignAndExponentOut : reg8
	PORT MAP(
		i_clear => i_GReset,
		i_clock => i_GClock,
		i_data => int_EXPSumo,
		o_q(7) => o_signout,
		o_Q(6 downto 0) => o_exponentOut
		);
MantisaOut : reg8
	PORT MAP(
		i_clear => i_GReset,
		i_clock => i_GClock,
		i_data => int_ProductOut (15 downto 8),
		o_Q => o_mantissaOut
		);

END rtl;