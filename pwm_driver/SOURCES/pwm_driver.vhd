----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
----------------------------------------------------------------------------------
ENTITY pwm_driver IS
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
END pwm_driver;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF pwm_driver IS
----------------------------------------------------------------------------------

    signal cnt_pwm : unsigned(7 downto 0) := (others => '0');

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

    cntr_pwm_p : process( CLK )
    begin
        if (rising_edge(CLK)) then

            if (cnt_pwm >= 254) then
                cnt_pwm <= (others => '0');
            else
                cnt_pwm <= cnt_pwm + 1;
            end if;
        end if;
    end process ; -- cntr_pwm_p

    pwm_comp_p : process(all)
    begin

        PWM_OUT <= (others => '1');

        if (cnt_pwm >= unsigned(PWM_REF_0)) then
            PWM_OUT(0) <= '0';
        end if;

        if (cnt_pwm >= unsigned(PWM_REF_1)) then
            PWM_OUT(1) <= '0';
        end if;
        
        if (cnt_pwm >= unsigned(PWM_REF_2)) then
            PWM_OUT(2) <= '0';
        end if;
        
        if (cnt_pwm >= unsigned(PWM_REF_3)) then
            PWM_OUT(3) <= '0';
        end if;
        
        if (cnt_pwm >= unsigned(PWM_REF_4)) then
            PWM_OUT(4) <= '0';
        end if;
        
        if (cnt_pwm >= unsigned(PWM_REF_5)) then
            PWM_OUT(5) <= '0';
        end if;
        
        if (cnt_pwm >= unsigned(PWM_REF_6)) then
            PWM_OUT(6) <= '0';
        end if;
        
        if (cnt_pwm >= unsigned(PWM_REF_7)) then
            PWM_OUT(7) <= '0';
        end if;
        
    end process;

    CNT_OUT <= std_logic_vector(cnt_pwm);

----------------------------------------------------------------------------------
END Behavioral;
----------------------------------------------------------------------------------
