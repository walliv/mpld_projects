----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
ENTITY cnt_bin_tb IS
END cnt_bin_tb;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF cnt_bin_tb IS
----------------------------------------------------------------------------------

  COMPONENT cnt_bin
  PORT (
    CLK                 : IN  STD_LOGIC;
    SRST                : IN  STD_LOGIC;
    CE                  : IN  STD_LOGIC;
    CNT_LOAD            : IN  STD_LOGIC;
    CNT_UP              : IN  STD_LOGIC;
    CNT                 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
  );
  END COMPONENT;

  --------------------------------------------------------------------------------

  CONSTANT C_CLK_PERIOD : TIME := 20 ns;
  SIGNAL F_sim_finished : BOOLEAN := FALSE;

  SIGNAL CLK            : STD_LOGIC := '0';
  SIGNAL SRST           : STD_LOGIC := '0';
  SIGNAL CE             : STD_LOGIC := '0';
  SIGNAL CNT_LOAD       : STD_LOGIC := '0';
  SIGNAL CNT_UP         : STD_LOGIC := '0';
  SIGNAL CNT            : STD_LOGIC_VECTOR (31 DOWNTO 0);

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  cnt_bin_i : cnt_bin
  PORT MAP (
    CLK                 => CLK,
    SRST                => SRST,
    CE                  => CE,
    CNT_LOAD            => CNT_LOAD,
    CNT_UP              => CNT_UP,
    CNT                 => CNT
  );

  --------------------------------------------------------------------------------

  PROCESS
  BEGIN
    CLK <= '0';
    WAIT FOR C_CLK_PERIOD/2;
    CLK <= '1';
    WAIT FOR C_CLK_PERIOD/2;
    IF F_sim_finished THEN
      WAIT;
    END IF;
  END PROCESS;

  --------------------------------------------------------------------------------

  PROCESS
    VARIABLE cnt_err  : INTEGER := 0;
  BEGIN
    ------------------------------------------------------------------------------
    -- initialize control signals
    SRST     <= '0';
    CE       <= '0';
    CNT_LOAD <= '0';
    CNT_UP   <= '0';
    WAIT FOR C_CLK_PERIOD;
    ------------------------------------------------------------------------------
    -- CE + CNT_UP function verification (count up)
    REPORT "==== Checking count enable (CE) and count up (CNT_UP = '1') functionality..." SEVERITY NOTE;
    CE       <= '1';
    CNT_UP   <= '1';
    WAIT FOR C_CLK_PERIOD * 100;
    CE       <= '0';
    WAIT FOR C_CLK_PERIOD * 10;
    IF NOT (UNSIGNED(CNT) = TO_UNSIGNED(100,CNT'LENGTH)) THEN
      REPORT "!!!! CNT_UP / CE function error (count up)" SEVERITY WARNING;
      cnt_err := cnt_err + 1;
    END IF;

    ------------------------------------------------------------------------------
    -- SRST function verification
    REPORT "==== Checking reset (SRST) functionality..." SEVERITY NOTE;
    SRST     <= '1';
    CE       <= '1';
    CNT_LOAD <= '1';
    WAIT FOR C_CLK_PERIOD * 10;
    IF NOT (UNSIGNED(CNT) = TO_UNSIGNED(0,CNT'LENGTH)) THEN
      REPORT "!!!! SRST function error" SEVERITY WARNING;
      cnt_err := cnt_err + 1;
    END IF;
    SRST     <= '0';
    CE       <= '0';
    CNT_LOAD <= '0';
    WAIT FOR C_CLK_PERIOD * 1;

    ------------------------------------------------------------------------------
    -- CE + CNT_UP function verification (count down)
    REPORT "==== Checking count enable (CE) and count down (CNT_UP = '0') functionality..." SEVERITY NOTE;
    CE       <= '1';
    CNT_UP   <= '0';
    WAIT FOR C_CLK_PERIOD * 100;
    CE       <= '0';
    WAIT FOR C_CLK_PERIOD * 10;
    IF NOT ( UNSIGNED(CNT) = (TO_UNSIGNED(0,CNT'LENGTH) - TO_UNSIGNED(100,CNT'LENGTH)) ) THEN
      REPORT "!!!! CNT_UP / CE function error (count down)" SEVERITY WARNING;
      cnt_err := cnt_err + 1;
    END IF;

    ------------------------------------------------------------------------------
    -- CNT_LOAD function verification
    REPORT "==== Checking load (CNT_LOAD) functionality..." SEVERITY NOTE;
    CE       <= '1';
    CNT_LOAD <= '1';
    WAIT FOR C_CLK_PERIOD * 1;
    CE       <= '0';
    CNT_LOAD <= '0';
    IF NOT (CNT = X"55555555") THEN
      REPORT "!!!! CNT_LOAD function error" SEVERITY WARNING;
      cnt_err := cnt_err + 1;
    END IF;

    F_sim_finished <= TRUE;

    ------------------------------------------------------------------------------
    -- final report
    IF cnt_err = 0 THEN
      REPORT LF &
             "================================================================" & LF &
             "Simulation PASSED (no erros)!" & LF &
             "================================================================" & LF
             SEVERITY NOTE;
    ELSE
      REPORT LF &
             "================================================================" & LF &
             "Simulation FAILED, " & INTEGER'IMAGE(cnt_err) & " errors detected." & LF &
             "================================================================" & LF
      		 SEVERITY ERROR;
    END IF;

    WAIT;
  END PROCESS;

----------------------------------------------------------------------------------
END ARCHITECTURE;
----------------------------------------------------------------------------------
