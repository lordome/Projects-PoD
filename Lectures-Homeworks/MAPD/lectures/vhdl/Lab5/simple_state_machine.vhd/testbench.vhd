LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY testbench IS
END testbench;
ARCHITECTURE behav OF testbench IS
    COMPONENT my_fsm1 IS
        PORT (
            TOG_EN, CLK, CLR : IN STD_LOGIC;
            Z1 : OUT STD_LOGIC);
        END COMPONENT;
    SIGNAL TOG_EN, CLK, CLR, Z1:  STD_LOGIC := '1';
BEGIN --architecture behav
    DUT : ENTITY work.my_fsm1

        PORT MAP(TOG_EN, CLK, CLR, Z1);

    --clock generation
    CLK <= NOT CLK AFTER 5 ns;

    --waveform generation
    waveGen : PROCESS
    BEGIN
        CLR <= '1';
        WAIT FOR 20 NS;
        CLR<= '0';
        WAIT FOR 20 NS;
        TOG_EN <= '1';
        WAIT;
    END PROCESS;
END behav;