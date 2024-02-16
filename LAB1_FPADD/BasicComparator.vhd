library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BasicComparator is
    Port (
        A : in STD_LOGIC;  -- Input bit 1
        B : in STD_LOGIC;  -- Input bit 2
        GT : out STD_LOGIC; -- A > B
        LT : out STD_LOGIC; -- A < B
        EQ : out STD_LOGIC  -- A = B
    );
end BasicComparator;

architecture Behavioral of BasicComparator is
begin
    GT <= '1' when A > B else '0';
    LT <= '1' when A < B else '0';
    EQ <= '1' when A = B else '0';
end Behavioral;
