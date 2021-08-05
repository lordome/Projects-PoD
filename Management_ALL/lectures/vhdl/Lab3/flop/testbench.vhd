LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY testbench IS
END testbench;
ARCHITECTURE tb OF testbench IS
    COMPONENT dff IS
        PORT (
            clk : IN STD_LOGIC :='0';
            t : IN STD_LOGIC := '0';
            d: INOUT STD_LOGIC := '0';
            q : INOUT STD_LOGIC := '0');
    END COMPONENT;
    SIGNAL clk, t, d, q : STD_LOGIC;
BEGIN
    DUT : dff PORT MAP(clk, t, d, q);
    PROCESS
    BEGIN
        clk <= '0';
        t <= '0';
        WAIT FOR 1 ns;
        clk <= '0';
        t <= '1';
        WAIT FOR 1 ns;
        clk <= '1';
        t <= '1';
        WAIT FOR 1 ns;
        clk <= '1';
        t <= '0';
        WAIT FOR 1 ns;
        clk <= '0';
        t <= '0';
        WAIT FOR 1 ns;
        clk <= '0';
        t <= '0';
        WAIT FOR 1 ns;
        clk <= '1';
        t <= '0';
        WAIT FOR 1 ns;
        clk <= '1';
        t <= '0';
        WAIT FOR 1 ns;
        -- Clear inputs
        clk <= '0';
        t <= '0';
        WAIT;
    END PROCESS;
END tb;

