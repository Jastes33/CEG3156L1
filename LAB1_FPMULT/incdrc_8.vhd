-- increment for 1
-- decrement for 0
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


Entity incdrc_8 IS
    Port ( 
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        A : in STD_LOGIC_VECTOR(7 downto 0);
        B : in STD_LOGIC;
        q : out STD_LOGIC_VECTOR(7 downto 0)
    );
End incdrc_8;

Architecture behav of incdrc_8 IS
    Signal temp : STD_LOGIC_VECTOR(7 downto 0);

    Begin
        process(clk, rst)
        Begin
            If rst = '1' Then
                temp <= (others => '0');
            Elsif rising_edge(clk) Then
                If B = '1' Then
                    temp <= temp + 1;
                Else
                    temp <= temp - 1;
                End If;
            End If;
        End process;

        q <= temp;
End behav;
