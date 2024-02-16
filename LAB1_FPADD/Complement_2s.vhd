-- This is a 2's complmenter for 7 bit numbers
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TwosComplement7Bit is
    Port (
        InputNumber : in STD_LOGIC_VECTOR(6 downto 0); -- 7-bit input number
        TwosCompOutput : out STD_LOGIC_VECTOR(6 downto 0) -- 7-bit 2's complement output
    );
end TwosComplement7Bit;

architecture Structural of TwosComplement7Bit is
    component NotGate
        Port (
            A : in STD_LOGIC;
            Y : out STD_LOGIC
        );
    end component;
    
    component Adder7Bit
        Port (
            A : in STD_LOGIC_VECTOR(6 downto 0);
            B : in STD_LOGIC_VECTOR(6 downto 0);
            Sum : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;
    
    signal InvertedInput : STD_LOGIC_VECTOR(6 downto 0);
    signal ConstantOne : STD_LOGIC_VECTOR(6 downto 0) := "0000001"; -- To add 1
begin
    -- Instantiate NotGates for each bit to invert the input number
    Inverter_Gen: for i in 0 to 6 generate
        Inverter: NotGate
        Port Map (
            A => InputNumber(i),
            Y => InvertedInput(i)
        );
    end generate Inverter_Gen;
    
    -- Add 1 to the inverted input to get the 2's complement
    AdderInstance: Adder7Bit
    Port Map (
        A => InvertedInput,
        B => ConstantOne,
        Sum => TwosCompOutput
    );

end Structural;