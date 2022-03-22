----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
ENTITY clk_gen_uart IS
  GENERIC (
    FREQ_CLK        : INTEGER := 50000000;      -- Hz
    UART_SPEED      : INTEGER := 9600);         -- Bd
  PORT (
    clk             : IN  STD_LOGIC;
    clk_en_uart     : OUT STD_LOGIC);
END clk_gen_uart;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF clk_gen_uart IS
----------------------------------------------------------------------------------

  CONSTANT CNT_UART_MAX : INTEGER := (FREQ_CLK/UART_SPEED);

  SIGNAL cnt_uart       : INTEGER RANGE 1 TO CNT_UART_MAX;
  SIGNAL clk_en_uart_i  : STD_LOGIC := '0';

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  clk_gen_proc: PROCESS (clk) BEGIN
    IF rising_edge(clk) THEN
      IF cnt_uart = CNT_UART_MAX THEN
        cnt_uart      <= 1;
        clk_en_uart_i <= '1';
      ELSE
        cnt_uart <= cnt_uart + 1;
        clk_en_uart_i <= '0';
      END IF;
    END IF;
  END PROCESS clk_gen_proc;

  clk_en_uart <= clk_en_uart_i;

----------------------------------------------------------------------------------
END Behavioral;
----------------------------------------------------------------------------------
