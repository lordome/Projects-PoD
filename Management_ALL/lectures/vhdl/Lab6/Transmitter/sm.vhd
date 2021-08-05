LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY SM IS
    PORT (
        data : IN STD_LOGIC_VECTOR (0 TO 7);
        valid : IN STD_LOGIC;
        clk_sm : IN STD_LOGIC;
        busy : OUT STD_LOGIC;
        tx_out : OUT STD_LOGIC);
END ENTITY SM;
ARCHITECTURE rtl OF SM IS
    TYPE state_t IS (IDLE, START, B0, B1, B2, B3, B4, B5, B6, B7, STOP);
    SIGNAL state : state_t := IDLE;
BEGIN -- architecture rtl
    main : PROCESS (clk_sm) IS
    BEGIN -- process main
        IF rising_edge(clk_sm) THEN
            -- rising clock edge
            CASE state IS
                WHEN IDLE =>
                    busy <= '0';
                        tx_out <= '1';
                    IF (valid = '1') THEN
                        state <= START;
                    END IF;
                WHEN START =>
                    busy <= '1';
                    tx_out <= '0';
                    state <= B0;
                WHEN B0 =>
                    tx_out <= data(0);
                    state <= B1;
                WHEN B1 =>
                    tx_out <= data(1);
                    state <= B2;
                WHEN B2 =>
                    tx_out <= data(2);
                    state <= B3;
                WHEN B3 =>
                    tx_out <= data(3);
                    state <= B4;
                WHEN B4 =>
                    tx_out <= data(4);
                    state <= B5;
                WHEN B5 =>
                    tx_out <= data(5);
                    state <= B6;
                WHEN B6 =>
                    tx_out <= data(6);
                    state <= B7;
                WHEN B7 =>
                    tx_out <= data(7);
                    state <= STOP;
                WHEN STOP =>
                    busy <= '0';
                    tx_out <= '0';
                    state <= IDLE;
                WHEN OTHERS => NULL;
            END CASE;
        END IF;
    END PROCESS main;
END ARCHITECTURE rtl;