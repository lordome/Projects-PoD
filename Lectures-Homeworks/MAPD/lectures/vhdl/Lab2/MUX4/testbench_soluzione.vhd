-------------------------------------------------------------------------------
-- Title      : Testbench for design "mux4"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : mux4_tb.vhd
-- Author     : Antonio  <antonio@dhcp-35.pd.infn.it>
-- Company    : 
-- Created    : 2020-11-23
-- Last update: 2020-11-23
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-11-23  1.0      antonio Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity mux4_tb is

end entity mux4_tb;

-------------------------------------------------------------------------------

architecture tes of mux4_tb is

  -- component ports
  signal a1  : std_logic_vector(2 downto 0);
  signal a2  : std_logic_vector(2 downto 0);
  signal a3  : std_logic_vector(2 downto 0);
  signal a4  : std_logic_vector(2 downto 0);
  signal sel : std_logic_vector(1 downto 0);
  signal b   : std_logic_vector(2 downto 0);

  -- clock
  signal Clk : std_logic := '1';

begin  -- architecture tes

  -- component instantiation
  DUT : entity work.mux4
    port map (
      a1  => a1,
      a2  => a2,
      a3  => a3,
      a4  => a4,
      sel => sel,
      b   => b);


  -- waveform generation
  WaveGen_Proc : process
  begin
    a1 <= "010";
    a2 <= "011";
    a3 <= "100";
    a4 <= "111";

    sel <= "00";
    wait for 1 ns;
    sel <= "01";
    wait for 1 ns;
    sel <= "10";
    wait for 1 ns;
    sel <= "11";
    wait for 1 ns;
    wait;
  end process WaveGen_Proc;



end architecture tes;

-------------------------------------------------------------------------------

configuration mux4_tb_tes_cfg of mux4_tb is
  for tes
  end for;
end mux4_tb_tes_cfg;

-------------------------------------------------------------------------------
