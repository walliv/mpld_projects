----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
ENTITY edge_detector IS
  PORT(
    clk         : IN  STD_LOGIC;
    sig_i       : IN  STD_LOGIC;
    posedge_o   : OUT STD_LOGIC;
    negedge_o   : OUT STD_LOGIC;
    edge_o      : OUT STD_LOGIC);
END edge_detector;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF edge_detector IS
----------------------------------------------------------------------------------

  SIGNAL sig_i_del          : STD_LOGIC := '0';

  SIGNAL posedge            : STD_LOGIC := '0';
  SIGNAL negedge            : STD_LOGIC := '0';
  SIGNAL edge               : STD_LOGIC := '0';

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  PROCESS (clk) BEGIN
    IF rising_edge(clk) THEN
      sig_i_del <= sig_i;

      posedge   <= '0';
      negedge   <= '0';
      edge      <= '0';

      IF NOT (sig_i = sig_i_del) THEN
        edge <= '1';
      END IF;

      IF sig_i = '1' AND sig_i_del = '0' THEN
        posedge <= '1';
      END IF;

      IF sig_i = '0' AND sig_i_del = '1' THEN
        negedge <= '1';
      END IF;

    END IF;
  END PROCESS;

  --------------------------------------------------------------------------------

  posedge_o <= posedge;
  negedge_o <= negedge;
  edge_o    <= edge;

----------------------------------------------------------------------------------
END Behavioral;
----------------------------------------------------------------------------------
