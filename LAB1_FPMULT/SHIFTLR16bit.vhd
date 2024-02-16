-- 3Bit counter
-- Jessica Hemstead
-- Used counter code from Rami 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY SHIFTLR16bit IS
	PORT(
		i_clear , i_Lshift , i_Rshift	: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_data: IN STD_LOGIC_VECTOR(15 downto 0);
		o_Q			: OUT	STD_LOGIC_VECTOR(15 downto 0));
		
END SHIFTLR16bit;

ARCHITECTURE rtl OF SHIFTLR16bit IS
	SIGNAL int_Rshift , int_Lshift, int_data , int_isLeft : STD_LOGIC_VECTOR(15 downto 0);

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
	shiftLT1 : eightBitmux2to1
		PORT MAP(
			i_op0 => i_data(7 downto 0),
			i_op1(0) => int_data(0),
			i_op1(1) => int_data(1), 
			i_op1(2) => int_data(2),
			i_op1(3) => int_data(3),
			i_op1(4) => int_data(4),
			i_op1(5) => int_data(5),
			i_op1(6) => int_data(6),
			i_op1(7) => int_data(7),
			i_selection => i_Lshift ,
			o_choice => int_isLeft(7 downto 0) 
			);
	shiftLT2 : eightBitmux2to1
		PORT MAP(
			i_op0 => i_data(15 downto 8),
			i_op1(0) => int_data(8),
			i_op1(1) => int_data(9), 
			i_op1(2) => int_data(10),
			i_op1(3) => int_data(11),
			i_op1(4) => int_data(12),
			i_op1(5) => int_data(13),
			i_op1(6) => int_data(14),
			i_op1(7) => int_data(15),
			i_selection => i_Lshift ,
			o_choice => int_isLeft(15 downto 8) 
			);
	shiftR1 : eightBitmux2to1
		PORT MAP(
			i_op0 => int_isLeft(7 downto 0),
			i_op1(0) => int_data(1),
			i_op1(1) => int_data(2), 
			i_op1(2) => int_data(3),
			i_op1(3) => int_data(4),
			i_op1(4) => int_data(5),
			i_op1(5) => int_data(6),
			i_op1(6) => int_data(7),
			i_op1(7) => int_data(8),
			i_selection => i_Rshift,
			o_choice => int_Rshift(7 downto 0)
			);
	shiftR2 : eightBitmux2to1
		PORT MAP(
			i_op0 => int_isLeft(15 downto 8),
			i_op1(0) => int_data(9),
			i_op1(1) => int_data(10), 
			i_op1(2) => int_data(11),
			i_op1(3) => int_data(12),
			i_op1(4) => int_data(13),
			i_op1(5) => int_data(14),
			i_op1(6) => int_data(15),
			i_op1(7) => int_data(15),
			i_selection => i_Rshift,
			o_choice => int_Rshift(15 downto 8)
			);	
	shiftL1 : eightBitmux2to1
		PORT MAP(
			i_op0 => int_Rshift(7 downto 0),
			i_op1(0) => '0',
			i_op1(1) => int_Rshift(0),
			i_op1(2) => int_Rshift(1),
			i_op1(3) => int_Rshift(2),
			i_op1(4) => int_Rshift(3),
			i_op1(5) => int_Rshift(4),
			i_op1(6) => int_Rshift(5),
			i_op1(7) => int_Rshift(6),
			i_selection => i_Lshift,
			o_choice => int_Lshift(7 downto 0) 
			);
	shiftL2 : eightBitmux2to1
		PORT MAP(
			i_op0 => int_Rshift(15 downto 8),
			i_op1(0) => int_Rshift(7),
			i_op1(1) => int_Rshift(8),
			i_op1(2) => int_Rshift(9),
			i_op1(3) => int_Rshift(10),
			i_op1(4) => int_Rshift(11),
			i_op1(5) => int_Rshift(12),
			i_op1(6) => int_Rshift(13),
			i_op1(7) => int_Rshift(14),
			i_selection => i_Lshift,
			o_choice => int_Lshift(15 downto 8) 
			);
	shiftingreg1 : reg8
		PORT MAP(
			i_clear => i_clear,
			i_clock => i_Clock,
			i_data => int_Lshift(7 downto 0),
			o_Q => int_data(7 downto 0)
			);
	shiftingreg2 : reg8
		PORT MAP(
			i_clear => i_clear,
			i_clock => i_Clock,
			i_data => int_Lshift(15 downto 8),
			o_Q => int_data(15 downto 8)
			);
--------output------------			
	o_Q <= int_data;
			
END RTL;