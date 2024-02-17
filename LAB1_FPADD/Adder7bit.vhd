library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Adder7Bit is
    Port (
        A : in STD_LOGIC_VECTOR(6 downto 0); -- Input A (7 bits)
        B : in STD_LOGIC_VECTOR(6 downto 0); -- Input B (7 bits)
        Sum : out STD_LOGIC_VECTOR(6 downto 0) -- Sum (7 bits)
    );
end Adder7Bit;

architecture Behavioral of Adder7Bit is
begin
    Sum <= A + B;
end Behavioral;
```
