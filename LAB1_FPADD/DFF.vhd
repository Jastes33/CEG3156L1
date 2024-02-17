library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DFF is
    Port ( D : in STD_LOGIC;
           CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
           Q : out STD_LOGIC);
end DFF;

architecture Behavioral of DFF is
begin
    process(CLK, RESET)
    begin
        if RESET = '1' then
            Q <= '0';
        elsif rising_edge(CLK) then
            Q <= D;
        end if;
    end process;
end Behavioral;
