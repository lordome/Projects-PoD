LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY testbench IS
END ENTITY testbench;
ARCHITECTURE str OF testbench IS
    COMPONENT mux4 IS
        PORT (a1, a2, a3, a4 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
             sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
             b : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
            );
    END COMPONENT mux4;
    SIGNAL a1, a2, a3, a4 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL sel : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL b : STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN -- architecture str
    DUT : mux4 PORT MAP(a1, a2, a3, a4, sel, b);
    PROCESS
    BEGIN
    a1 <= B"000";
    a2 <= B"000";
    a3 <= B"000";
    a4 <= B"000";
    sel <= B"00";
    WAIT FOR 1 ns;
    a1 <= B"100";
    a2 <= B"100";
    a3 <= B"100";
    a4 <= B"100";
    sel <= B"00";
    WAIT FOR 1 ns;
    a1 <= B"010";
    a2 <= B"010";
    a3 <= B"010";
    a4 <= B"010";
    sel <= B"00";
    WAIT FOR 1 ns;
    WAIT;
END PROCESS;
    
END ARCHITECTURE str;