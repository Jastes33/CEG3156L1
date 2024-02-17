LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY CLA_8 IS
    PORT(
        A : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        load : IN STD_LOGIC;
        CIN : IN STD_LOGIC;
        SUM : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        COUT : OUT STD_LOGIC
    );
END CLA_8;


ARCHITECTURE rtl OF CLA_8 IS
    SIGNAL C : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL G : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL P : STD_LOGIC_VECTOR(7 DOWNTO 0);

    BEGIN
    -- Generate G and P signals
    
    if load = '1' then
        G(0) <= A(0) and B(0);
        P(0) <= A(0) or B(0);

        G(1) <= A(1) and B(1);
        P(1) <= A(1) or B(1);

        G(2) <= A(2) and B(2);
        P(2) <= A(2) or B(2);

        G(3) <= A(3) and B(3);
        P(3) <= A(3) or B(3);

        G(4) <= A(4) and B(4);
        P(4) <= A(4) or B(4);

        G(5) <= A(5) and B(5);
        P(5) <= A(5) or B(5);

        G(6) <= A(6) and B(6);
        P(6) <= A(6) or B(6);

        G(7) <= A(7) and B(7);
        P(7) <= A(7) or B(7);

        -- Generate C signals
        C(0) <= Cin;
        C(1) <= G(0) or (P(0) and C(0));
        C(2) <= G(1) or (P(1) and C(1));
        C(3) <= G(2) or (P(2) and C(2));
        C(4) <= G(3) or (P(3) and C(3));
        C(5) <= G(4) or (P(4) and C(4));
        C(6) <= G(5) or (P(5) and C(5));
        C(7) <= G(6) or (P(6) and C(6));
        C(8) <= G(7) or (P(7) and C(7));

        -- Output signals
        Sum <= (others => '0') when Cin = '0' else G(7 downto 0);
        Cout <= C(8);
    else
        Sum <= (others => '0');
        Cout <= '0';
    end if;


END rtl;