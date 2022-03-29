----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
ENTITY sync_reg IS
  PORT(
    clk         : IN  STD_LOGIC;
    d_i         : IN  STD_LOGIC;
    q_o         : OUT STD_LOGIC);
END sync_reg;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF sync_reg IS
----------------------------------------------------------------------------------

  SIGNAL sync_sh_reg        : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');

  ATTRIBUTE ASYNC_REG                       : STRING;
  ATTRIBUTE ASYNC_REG OF sync_sh_reg        : SIGNAL IS "TRUE";

  ATTRIBUTE SHREG_EXTRACT                   : STRING;
  ATTRIBUTE SHREG_EXTRACT OF sync_sh_reg    : SIGNAL IS "NO";

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  PROCESS (clk) BEGIN
    IF rising_edge(clk) THEN
      sync_sh_reg <= sync_sh_reg(sync_sh_reg'HIGH-1 DOWNTO 0) & d_i;
    END IF;
  END PROCESS;

  q_o <= sync_sh_reg(sync_sh_reg'HIGH);

----------------------------------------------------------------------------------
END Behavioral;
----------------------------------------------------------------------------------
