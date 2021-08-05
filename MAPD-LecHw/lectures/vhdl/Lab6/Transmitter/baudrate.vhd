LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY baud IS
    PORT (
        baud_clk : IN STD_LOGIC;
        baud_out : OUT STD_LOGIC);
END ENTITY baud;
ARCHITECTURE rtl OF baud IS
    SIGNAL counter : unsigned(9 DOWNTO 0) := (OTHERS => '0');
    CONSTANT divisor : unsigned(9 DOWNTO 0) := to_unsigned(867, 10);
BEGIN -- architecture rtl
    main : PROCESS (baud_clk) IS
    BEGIN -- process main
        IF rising_edge(baud_clk) THEN
            -- rising clock edge
            counter <= counter + 1;
            IF counter = divisor THEN
                baud_out <= '1';
                counter <= (OTHERS => '0');
            ELSE
                baud_out <= '0';
            END IF;
        END IF;
    END PROCESS main;
END ARCHITECTURE rtl;