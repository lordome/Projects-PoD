LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY testbench IS
END testbench;
ARCHITECTURE tb OF testbench IS
    COMPONENT dff IS
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            d: IN STD_LOGIC;
            q : OUT STD_LOGIC);
    END COMPONENT;
    SIGNAL clk, rst, d, q : STD_LOGIC;
BEGIN
    DUT : dff PORT MAP(clk, rst, d, q);
    PROCESS
    BEGIN
        clk <= '0';
        d <= '0';
        WAIT FOR 1 ns;
        clk <= '0';
        d <= '1';
        WAIT FOR 1 ns;
        clk <= '1';
        d <= '1';
        WAIT FOR 1 ns;
        clk <= '1';
        d <= '0';
        WAIT FOR 1 ns;
        rst<= '1';
        clk <= '0';
        d <= '0';
        WAIT FOR 1 ns;
        clk <= '0';
        d <= '0';
        WAIT FOR 1 ns;
        clk <= '1';
        d <= '0';
        WAIT FOR 1 ns;
        clk <= '1';
        d <= '0';
        WAIT FOR 1 ns;
        -- Clear inputs
        clk <= '0';
        d <= '0';
        WAIT;
    END PROCESS;
END tb;

