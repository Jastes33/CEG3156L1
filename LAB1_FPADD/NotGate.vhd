library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity NotGate is
    Port (
        A : in STD_LOGIC;  -- Input bit
        Y : out STD_LOGIC  -- Output bit (Inverted input)
    );
end NotGate;

architecture Behavioral of NotGate is
begin
    Y <= not A;
end Behavioral;
