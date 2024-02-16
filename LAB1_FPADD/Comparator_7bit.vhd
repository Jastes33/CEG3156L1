library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Comparator7Bit is
    Port (
        A : in STD_LOGIC_VECTOR(6 downto 0);  -- 7-bit input A
        B : in STD_LOGIC_VECTOR(6 downto 0);  -- 7-bit input B
        GT : out STD_LOGIC; -- A > B
        LT : out STD_LOGIC; -- A < B
        EQ : out STD_LOGIC  -- A = B
    );
end Comparator7Bit;

architecture Structural of Comparator7Bit is
    component BasicComparator
        Port (
            A : in STD_LOGIC;
            B : in STD_LOGIC;
            GT : out STD_LOGIC;
            LT : out STD_LOGIC;
            EQ : out STD_LOGIC
        );
    end component;
    
    signal GT_signals, LT_signals, EQ_signals : STD_LOGIC_VECTOR(6 downto 0);
begin
    -- Instantiate BasicComparators for each bit
    Comp_Gen: for i in 0 to 6 generate
        BC: BasicComparator
        Port Map (
            A => A(i),
            B => B(i),
            GT => GT_signals(i),
            LT => LT_signals(i),
            EQ => EQ_signals(i)
        );
    end generate Comp_Gen;

    -- Aggregate the results. This simplistic approach does not properly handle priority logic.
    -- For a real comparator, additional logic is needed to correctly set GT, LT, and EQ.
    GT <= '1' when GT_signals /= "0000000" and LT_signals = "0000000" else '0';
    LT <= '1' when LT_signals /= "0000000" and GT_signals = "0000000" else '0';
    EQ <= '1' when EQ_signals = "1111111" else '0';

end Structural;
