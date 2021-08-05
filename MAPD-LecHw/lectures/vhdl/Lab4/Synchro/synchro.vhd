LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY sync IS
    PORT (
        clk : IN STD_LOGIC := '0';
        t : IN STD_LOGIC := '0';
        q : OUT STD_LOGIC := '0');
END ENTITY sync;

ARCHITECTURE rtl OF sync IS
    SIGNAL sig_one_two : STD_LOGIC;
BEGIN -- architecture rtl
    flipflop : PROCESS (clk) IS
    BEGIN -- process flipflop
        IF rising_edge(clk) THEN -- rising clock edge
            q <= sig_one_two;
            sig_one_two <= t;
        END IF;
    END PROCESS flipflop;
END ARCHITECTURE rtl;