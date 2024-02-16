--Lab1 CEG3156
--Alexander Wilson 300219585

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY multiplier IS
	PORT(
	i_multiplicand, i_multiplier : in STD_logic_VECTOR(7 downto 0);
	i_clk, i_clear , i_rshift: IN STD_logic;
	o_mux : out std_LOGIC;
	o_product: out STD_logic_VECTOR(15 downto 0);
	o_sreg, o_reg, o_alu : OUT STD_LOGIC_VECTOR (7 downto 0));
	
END multiplier;

Architecture rtl OF multiplier IS

Signal int_ALUA, int_ALUB, int_prodA ,int_prodB, int_prodq, int_ALUout : STD_LOGIC_VECTOR(7 downto 0);
SIGNAL int_controlcarry , int_test : STD_LOGIC;

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

COMPONENT SHIFTLR16bit
	PORT(
		i_clear , i_Lshift , i_Rshift	: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_data: IN STD_LOGIC_VECTOR(15 downto 0);
		o_Q			: OUT	STD_LOGIC_VECTOR(15 downto 0));
		
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

COMPONENT enARdFF_2
	PORT(
		i_resetBar	: IN	STD_LOGIC;
		i_d		: IN	STD_LOGIC;
		i_enable	: IN	STD_LOGIC;
		i_clock		: IN	STD_LOGIC;
		o_q, o_qBar	: OUT	STD_LOGIC);
END COMPONENT;

BEGIN

multiplicad : reg8
	
	PORT MAP(
		i_clear => i_clear,
		i_clock => i_clk,
		i_data => i_multiplicand,
		o_Q => int_ALUB
		);	

multiplier : LRShiftreg8
		PORT MAP(
		i_clear => i_clear,
		i_Lshift => '0',  
		i_Rshift => i_rshift,
		i_clock => i_clk,
		i_data => i_multiplier,
		o_Q => int_prodB
		);
Product : SHIFTLR16bit
	PORT MAP(
		i_clear => i_clear,
		i_Lshift => '0',		
		i_Rshift => i_rshift,
		i_clock => i_clk,
		i_data(7 downto 0) => int_prodB, 
		i_data(15 downto 8) => int_prodA,
		o_Q(7 downto 0) => int_prodq,
		o_Q(15 downto 8) => int_ALUA
		);
		
myALU : addSUB
	PORT MAP(
	i_xx => int_ALUA,
	i_yy => int_ALUB,
	i_operation => int_prodB(0),
	o_s => int_ALUout,
	o_c => int_controlcarry
	);
	
check	: enARdFF_2
	PORT MAP(
		i_resetBar => '1',
		i_d => int_prodB(0),		
		i_enable => '1',
		i_clock => i_clk,
		o_q => int_test
		);

ALUmux : eightBitmux2to1
	PORT MAP(
		i_op0 => int_ALUA,
		i_op1 => int_ALUout,
		i_selection => (int_test XOR int_prodB(0)),
		o_choice => int_prodA
		);
	
	
o_product(15 downto 8) <= int_ALUA;
o_product(7 downto 0) <= int_prodq;


o_reg <= int_ALUB;
o_alu <=int_ALUout;
o_sreg <= int_prodB;
o_mux <= int_test;
END rtl;