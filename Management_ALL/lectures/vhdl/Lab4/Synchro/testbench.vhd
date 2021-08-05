LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY testbench IS
END testbench;
ARCHITECTURE behav OF testbench IS
    COMPONENT sync IS
        PORT (
            clk : IN STD_LOGIC;
            t : IN STD_LOGIC := '0';
            q : OUT STD_LOGIC := '0');
    END COMPONENT;
    SIGNAL clk, t, q : STD_LOGIC := '1';
BEGIN --architecture behav
    DUT : ENTITY work.sync
        PORT MAP(clk, t, q);

    --clock generation
    clk <= NOT clk AFTER 5 ns;

    --waveform generation
    waveGen : PROCESS
    BEGIN
        t <= '0';
        WAIT FOR 17 ns;
        t <= '1';
        WAIT FOR 20 ns;
        t <= '0';
        WAIT FOR 10 ns;
        t <= '1';
        WAIT FOR 5 ns;
        t <= '0';
        WAIT FOR 5 ns;
        t <= '1';
        WAIT FOR 5 ns;
        t <= '0';
        WAIT FOR 20 ns;
        WAIT;
    END PROCESS;
END behav;