-- 3Bit counter
-- Jessica Hemstead
-- Used counter code from Rami 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY LRShiftreg8 IS
	PORT(
		i_clear , i_Lshift , i_Rshift	: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_data: IN STD_LOGIC_VECTOR(7 downto 0);
		o_Q			: OUT	STD_LOGIC_VECTOR(7 downto 0));
		
END LRShiftreg8;

ARCHITECTURE rtl OF LRShiftreg8 IS
	SIGNAL int_Rshift , int_Lshift, int_data , int_isLeft : STD_LOGIC_VECTOR(7 downto 0);

	COMPONENT reg8
		PORT(
			i_clear	: IN	STD_LOGIC;
			i_clock			: IN	STD_LOGIC;
			i_data: IN STD_LOGIC_VECTOR(7 downto 0);
			o_Q			: OUT	STD_LOGIC_VECTOR(7 downto 0));
			
	END COMPONENT;

	COMPONENT eightBitmux2to1
		PORT(
			i_op0:IN STD_LOGIC_VECTOR(7 downto 0);
			i_op1:IN STD_LOGIC_VECTOR(7 downto 0);
			i_selection: IN STD_LOGIC;
			o_choice:OUT STD_LOGIC_VECTOR(7 downto 0));
	END COMPONENT;

BEGIN
	shiftLT: eightBitmux2to1
		PORT MAP(
			i_op0 => i_data,
			i_op1(0) => int_data(0),
			i_op1(1) => int_data(1), 
			i_op1(2) => int_data(2),
			i_op1(3) => int_data(3),
			i_op1(4) => int_data(4),
			i_op1(5) => int_data(5),
			i_op1(6) => int_data(6),
			i_op1(7) => int_data(7),
			i_selection => i_Lshift ,
			o_choice => int_isLeft 
			);

	shiftR : eightBitmux2to1
		PORT MAP(
			i_op0 => int_isLeft,
			i_op1(0) => int_data(1),
			i_op1(1) => int_data(2), 
			i_op1(2) => int_data(3),
			i_op1(3) => int_data(4),
			i_op1(4) => int_data(5),
			i_op1(5) => int_data(6),
			i_op1(6) => int_data(7),
			i_op1(7) => int_data(7),
			i_selection => i_Rshift,
			o_choice => int_Rshift
			);
	
	shiftL : eightBitmux2to1
		PORT MAP(
			i_op0 => int_Rshift,
			i_op1(0) => '0',
			i_op1(1) => int_Rshift(0),
			i_op1(2) => int_Rshift(1),
			i_op1(3) => int_Rshift(2),
			i_op1(4) => int_Rshift(3),
			i_op1(5) => int_Rshift(4),
			i_op1(6) => int_Rshift(5),
			i_op1(7) => int_Rshift(6),
			i_selection => i_Lshift,
			o_choice => int_Lshift 
			);
	shiftingreg : reg8
		PORT MAP(
			i_clear => i_clear,
			i_clock => i_Clock,
			i_data => int_Lshift,
			o_Q => int_data
			);

--------output------------			
	o_Q <= int_data;
			
END RTL;