LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY uart_trans IS
    PORT (
        data_U : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        valid_U : IN STD_LOGIC;
        clk_U : IN STD_LOGIC;
        busy_U : OUT STD_LOGIC;
        tx_out_U : OUT STD_LOGIC
    );
END ENTITY uart_trans;

ARCHITECTURE rtl OF uart_trans IS
    COMPONENT baud IS
        PORT (
            baud_clk : IN STD_LOGIC;
            baud_out : OUT STD_LOGIC);
    END COMPONENT;
    COMPONENT SM IS
        PORT (
            data : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            valid : IN STD_LOGIC;
            clk_sm : IN STD_LOGIC;
            busy : OUT STD_LOGIC;
            tx_out : OUT STD_LOGIC);
    END COMPONENT;

    SIGNAL sig_baud_clk : STD_LOGIC;

BEGIN -- architecture rtl
    bd : baud
    PORT MAP(
        baud_clk => clk_U,
        baud_out => sig_baud_clk);
    stm : SM
    PORT MAP(
        data => data_U,
        valid => valid_U,
        clk_sm => sig_baud_clk,
        busy => busy_U,
        tx_out => tx_out_U
    );
END ARCHITECTURE rtl;