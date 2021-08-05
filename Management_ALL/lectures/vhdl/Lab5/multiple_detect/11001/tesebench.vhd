LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY pattern_testbench IS
END pattern_testbench;
ARCHITECTURE behav OF pattern_testbench IS
    COMPONENT patterndetect IS
        PORT (
            a : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            y : OUT STD_LOGIC);
    END COMPONENT;
    SIGNAL a, clk, rst, y : STD_LOGIC := '0';
BEGIN --architecture behav
    DUT : ENTITY work.patterndetect
        PORT MAP(a, clk, rst, y);

    --clock generation
    clk <= NOT clk AFTER 2 ns;

    --waveform generation
    waveGen : PROCESS
    BEGIN
        a <= '0';
        rst <= '1';
        WAIT FOR 10 ns;
        WAIT UNTIL rising_edge(clk);
        rst <= '0';
        WAIT FOR 10 ns;
        WAIT UNTIL rising_edge(clk);
        rst <= '1';
        WAIT UNTIL rising_edge(clk);
        a <= '1';
        WAIT UNTIL rising_edge(clk);
        a <= '1';
        WAIT UNTIL rising_edge(clk);
        a <= '0';
        WAIT UNTIL rising_edge(clk);
        a <= '0';
        WAIT UNTIL rising_edge(clk);
        a <= '1';
        WAIT FOR 100 ns;
        WAIT;
    END PROCESS;
END ARCHITECTURE behav;
