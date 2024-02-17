--This is the control path of the floating point adder
-- Kuan-Yu Chang
-- 300201058
-- University of Ottawa
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY ControlPath_FPA IS
PORT(
    clk, reset: IN STD_LOGIC;
    loadfordcnt: out STD_LOGIC;
    B: out STD_LOGIC;
    i_sel0 : out STD_LOGIC;
    i_sel1 : out STD_LOGIC;
    ShiftL : out STD_LOGIC;
    ShiftR : out STD_LOGIC;
);
END ControlPath_FPA;

ARCHITECTURE rtl OF ControlPath_FPA IS

COMPONENT enARdFF_2 IS
PORT(
    i_resetBar	: IN	STD_LOGIC;
	i_d		: IN	STD_LOGIC;
	i_enable	: IN	STD_LOGIC;
	i_clock		: IN	STD_LOGIC;
	o_q, o_qBar	: OUT	STD_LOGIC
);
END COMPONENT;

s0: enARdFF_2 PORT MAP(
    i_resetBar => not reset,
    i_d => '0',
    i_enable => '1',
    i_clock => clk,
    o_q => loadfordcnt & s0,
);

s1: enARdFF_2 PORT MAP(
    i_resetBar => not reset,
    i_d => i_sel0,
    i_enable => '1',
    i_clock => clk,
    o_q => B,
);
