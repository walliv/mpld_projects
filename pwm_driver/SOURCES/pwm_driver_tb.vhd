----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
ENTITY pwm_driver_tb IS
END pwm_driver_tb;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF pwm_driver_tb IS
----------------------------------------------------------------------------------

  COMPONENT pwm_driver
  PORT (
    CLK                 : IN  STD_LOGIC;
    PWM_REF_7           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_6           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_5           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_4           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_3           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_2           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_1           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_0           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_OUT             : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    CNT_OUT             : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
  );
  END COMPONENT;

  --------------------------------------------------------------------------------

  SIGNAL clk            : STD_LOGIC := '0';

  SIGNAL pwm_ref_7      : STD_LOGIC_VECTOR (7 DOWNTO 0) := (OTHERS => '0');
  SIGNAL pwm_ref_6      : STD_LOGIC_VECTOR (7 DOWNTO 0) := (OTHERS => '0');
  SIGNAL pwm_ref_5      : STD_LOGIC_VECTOR (7 DOWNTO 0) := (OTHERS => '0');
  SIGNAL pwm_ref_4      : STD_LOGIC_VECTOR (7 DOWNTO 0) := (OTHERS => '0');
  SIGNAL pwm_ref_3      : STD_LOGIC_VECTOR (7 DOWNTO 0) := (OTHERS => '0');
  SIGNAL pwm_ref_2      : STD_LOGIC_VECTOR (7 DOWNTO 0) := (OTHERS => '0');
  SIGNAL pwm_ref_1      : STD_LOGIC_VECTOR (7 DOWNTO 0) := (OTHERS => '0');
  SIGNAL pwm_ref_0      : STD_LOGIC_VECTOR (7 DOWNTO 0) := (OTHERS => '0');

  SIGNAL pwm_out        : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL cnt_out        : STD_LOGIC_VECTOR (7 DOWNTO 0);

  --------------------------------------------------------------------------------

  CONSTANT C_CLK_PERIOD     : TIME := 20 ns;
  SIGNAL F_sim_finished     : BOOLEAN := FALSE;

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  pwm_driver_i : pwm_driver
  PORT MAP(
    CLK                 => clk,
    PWM_REF_7           => pwm_ref_7,
    PWM_REF_6           => pwm_ref_6,
    PWM_REF_5           => pwm_ref_5,
    PWM_REF_4           => pwm_ref_4,
    PWM_REF_3           => pwm_ref_3,
    PWM_REF_2           => pwm_ref_2,
    PWM_REF_1           => pwm_ref_1,
    PWM_REF_0           => pwm_ref_0,
    PWM_OUT             => pwm_out,
    CNT_OUT             => cnt_out
  );

  --------------------------------------------------------------------------------

  PROCESS
  BEGIN
    clk <= '0';
    WAIT FOR C_CLK_PERIOD/2;
    clk <= '1';
    WAIT FOR C_CLK_PERIOD/2;
    IF F_sim_finished THEN
      WAIT;
    END IF;
  END PROCESS;

  --------------------------------------------------------------------------------

  PROCESS
  BEGIN
    ------------------------------------------------------------------------------
    -- initialize PWM references
    pwm_ref_0 <= "00000000";
    pwm_ref_1 <= "00000001";
    pwm_ref_2 <= "00000011";
    pwm_ref_3 <= "00000111";
    pwm_ref_4 <= "00011111";
    pwm_ref_5 <= "00111111";
    pwm_ref_6 <= "11111110";
    pwm_ref_7 <= "11111111";

    WAIT FOR C_CLK_PERIOD*2000;

    ------------------------------------------------------------------------------

    F_sim_finished <= TRUE;

    ------------------------------------------------------------------------------
    -- final report
    REPORT LF &
             "================================================================" & LF &
             "Simulation finished! Check the waveform window!" & LF &
             "================================================================" & LF
             SEVERITY NOTE;

    WAIT;
  END PROCESS;

----------------------------------------------------------------------------------
END ARCHITECTURE;
----------------------------------------------------------------------------------
