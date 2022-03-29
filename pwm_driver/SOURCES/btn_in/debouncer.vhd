----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
ENTITY debouncer IS
  GENERIC(
    DEB_PERIOD  : INTEGER := 10);
  PORT(
    clk         : IN  STD_LOGIC;
    ce          : IN  STD_LOGIC;
    btn_i       : IN  STD_LOGIC;
    btn_o       : OUT STD_LOGIC);
END debouncer;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF debouncer IS
----------------------------------------------------------------------------------

  SIGNAL sh_reg_deb         : STD_LOGIC_VECTOR(DEB_PERIOD-1 DOWNTO 0) := (OTHERS => '0');
  CONSTANT C_ZEROS          : STD_LOGIC_VECTOR(sh_reg_deb'RANGE) := (OTHERS => '0');
  CONSTANT C_ONES           : STD_LOGIC_VECTOR(sh_reg_deb'RANGE) := (OTHERS => '1');
  SIGNAL btn_deb            : STD_LOGIC := '0';

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  PROCESS (clk) BEGIN
    IF rising_edge(clk) THEN
      IF ce = '1' THEN

        sh_reg_deb <= sh_reg_deb(sh_reg_deb'HIGH-1 DOWNTO 0) & btn_i;

        IF sh_reg_deb = C_ZEROS THEN
          btn_deb <= '0';
        END IF;

        IF sh_reg_deb = C_ONES THEN
          btn_deb <= '1';
        END IF;

      END IF;
    END IF;
  END PROCESS;

  btn_o <= btn_deb;

----------------------------------------------------------------------------------
END Behavioral;
----------------------------------------------------------------------------------
