----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
ENTITY btn_in IS
  GENERIC(
    DEB_PERIOD          : INTEGER := 10);
  PORT(
    clk                 : IN  STD_LOGIC;
    ce                  : IN  STD_LOGIC;
    btn_i               : IN  STD_LOGIC;
    btn_deb_o           : OUT STD_LOGIC;
    btn_posedge_o       : OUT STD_LOGIC;
    btn_negedge_o       : OUT STD_LOGIC;
    btn_edge_o          : OUT STD_LOGIC);
END btn_in;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF btn_in IS
----------------------------------------------------------------------------------

  COMPONENT sync_reg
  PORT(
    clk         : IN  STD_LOGIC;
    d_i         : IN  STD_LOGIC;
    q_o         : OUT STD_LOGIC);
  END COMPONENT;

  --------------------------------------------------------------------------------

  COMPONENT debouncer
  GENERIC(
    DEB_PERIOD  : INTEGER := 10);
  PORT(
    clk         : IN  STD_LOGIC;
    ce          : IN  STD_LOGIC;
    btn_i       : IN  STD_LOGIC;
    btn_o       : OUT STD_LOGIC);
  END COMPONENT;

  --------------------------------------------------------------------------------

  COMPONENT edge_detector
  PORT(
    clk         : IN  STD_LOGIC;
    sig_i       : IN  STD_LOGIC;
    posedge_o   : OUT STD_LOGIC;
    negedge_o   : OUT STD_LOGIC;
    edge_o      : OUT STD_LOGIC);
  END COMPONENT;

  --------------------------------------------------------------------------------

  SIGNAL btn_nm             : STD_LOGIC;
  SIGNAL btn_deb            : STD_LOGIC;

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  sync_reg_i : sync_reg
  PORT MAP(
    clk         => clk,
    d_i         => btn_i,
    q_o         => btn_nm);

  --------------------------------------------------------------------------------

  debouncer_i : debouncer
  GENERIC MAP(
    DEB_PERIOD  => DEB_PERIOD)
  PORT MAP(
    clk         => clk,
    ce          => ce,
    btn_i       => btn_nm,
    btn_o       => btn_deb);

  --------------------------------------------------------------------------------

  edge_detector_i : edge_detector
  PORT MAP(
    clk         => clk,
    sig_i       => btn_deb,
    posedge_o   => btn_posedge_o,
    negedge_o   => btn_negedge_o,
    edge_o      => btn_edge_o);

  --------------------------------------------------------------------------------

  btn_deb_o <= btn_deb;

----------------------------------------------------------------------------------
END Behavioral;
----------------------------------------------------------------------------------
