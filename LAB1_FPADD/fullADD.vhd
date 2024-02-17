--Lab2 CEG3155 Group 3
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fullADD IS
	PORT(
	i_x, i_y, i_cin : IN STD_logic;
	o_sum, o_cout :OUT STD_logic);
END fullADD;

Architecture rtl of fullADD IS

	SIGNAL int_c0,int_c1,int_s :STD_logic;

BEGIN

int_s <= (i_x xor i_y);
o_sum <= (int_s xor i_cin);

int_c0 <= (i_cin and int_s);
int_c1 <= (i_x and i_y);

o_cout <= (int_c0 or int_c1);
	
END rtl; 
