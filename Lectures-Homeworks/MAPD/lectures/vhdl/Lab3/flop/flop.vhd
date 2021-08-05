LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY dff IS
    PORT (
        clk : IN STD_LOGIC := '0';
        t: IN STD_LOGIC := '0';
        d: INOUT STD_LOGIC := '0';
        q: INOUT STD_LOGIC := '0');
END ENTITY dff;


ARCHITECTURE rtl OF dff IS
BEGIN -- architecture rtl
    flipflop : PROCESS (clk) IS
    BEGIN -- process flipflop
        IF rising_edge(clk) THEN  -- rising clock edge
            d <= t XOR q;
            q <= d;
        END IF;
    END PROCESS flipflop;
END ARCHITECTURE rtl;