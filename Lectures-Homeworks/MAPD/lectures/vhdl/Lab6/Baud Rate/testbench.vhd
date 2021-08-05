LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY baud_testbench IS
END baud_testbench;
ARCHITECTURE behav OF baud_testbench IS
    COMPONENT baud IS
        PORT (
            clk : IN STD_LOGIC;
            y : OUT STD_LOGIC);
    END COMPONENT;
    SIGNAL  clk, y : STD_LOGIC := '0';
BEGIN --architecture behav
    DUT : ENTITY work.baud
        PORT MAP( clk, y);
    --clock generation
    clk <= NOT clk AFTER 5 ns;

    --waveform generation
    waveGen : PROCESS
    BEGIN
        WAIT FOR 100 us;
        WAIT;
    END PROCESS;
END ARCHITECTURE behav;
