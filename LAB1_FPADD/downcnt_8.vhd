library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity DownCounter8Bit is
    Port ( CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
           LOAD : in STD_LOGIC; -- Load enable signal
           DATA_IN : in STD_LOGIC_VECTOR(7 downto 0); -- Load value
           Q : out STD_LOGIC); -- Output count
end DownCounter8Bit;

architecture Structural of DownCounter8Bit is
    signal tmpQ, nextQ : STD_LOGIC_VECTOR(7 downto 0); -- Intermediate signals for flip-flop connections
begin
    -- Instantiate 8 DFFs
    gen_dffs: for i in 0 to 7 generate
        dff_inst: entity work.DFF
            port map(
                D => nextQ(i),
                CLK => CLK,
                RESET => RESET,
                Q => tmpQ(i)
            );
    end generate;

    -- Logic to decrement or load the counter
    process(tmpQ, LOAD, DATA_IN)
    begin
        if LOAD = '1' then
            nextQ <= DATA_IN; -- Load the input value when LOAD is enabled
            Q <= '0'; -- Output is 0 when loading
        else
            nextQ <= std_logic_vector(tmpQ - 1); -- Decrement counter
            Q<= '1'; -- Output is 1 when counting
            tmpQ <= nextQ; -- Update the flip-flop inputs
        end if;
    end process;

end Structural;
