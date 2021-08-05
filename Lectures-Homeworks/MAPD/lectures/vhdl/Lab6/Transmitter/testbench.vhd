LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY baud_testbench IS
END baud_testbench;

ARCHITECTURE behav OF baud_testbench IS
    COMPONENT baud_tb IS
        PORT (
            data_U : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            valid_U : IN STD_LOGIC;
            clk_U : IN STD_LOGIC;
            busy_U: OUT STD_LOGIC;
            tx_out_U : OUT STD_LOGIC
        );
    END COMPONENT;
    SIGNAL clk, tx_out, busy : STD_LOGIC := '0';
    SIGNAL data : STD_LOGIC_VECTOR (7 DOWNTO 0) := "10011010";
    SIGNAL valid : STD_LOGIC := '1';
BEGIN --architecture behav
    DUT : ENTITY work.uart_trans
        PORT MAP(data, valid, clk, busy, tx_out);
    --clock generation
    clk <= NOT clk AFTER 5 ns;

    --waveform generation
    waveGen : PROCESS
    BEGIN
        valid <= '1';
        WAIT FOR 20 us;
        valid <= '0';
        WAIT UNTIL busy = '0';
        data <= "10111010";
        valid <= '1';
        WAIT UNTIL busy = '0';
        valid <= '0';
        WAIT;
    END PROCESS;
END ARCHITECTURE behav;