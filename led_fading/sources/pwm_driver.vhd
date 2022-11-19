----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
----------------------------------------------------------------------------------

entity PWM_DRIVER is
    generic (
        -- Number of bits for the reference
        RESOLUTION : positive := 8);
    port (
        CLK       : in  std_logic;
        PWM_REF   : in  std_logic_vector (RESOLUTION -1 downto 0);
        PWM_OUT   : out std_logic;
        CNT_OUT   : out std_logic_vector (RESOLUTION -1 downto 0)
        );
end entity;

architecture FULL of PWM_DRIVER is
    signal cnt_pwm : unsigned(RESOLUTION -1 downto 0) := (others => '0');
begin

    cntr_pwm_p : process(CLK)
    begin
        if (rising_edge(CLK)) then
            cnt_pwm <= cnt_pwm + 1;
        end if;
    end process;  -- cntr_pwm_p

    pwm_comp_p : process(all)
    begin
        PWM_OUT <= '1';

        if (cnt_pwm >= unsigned(PWM_REF)) then
            PWM_OUT <= '0';
        end if;
    end process;

    CNT_OUT <= std_logic_vector(cnt_pwm);
end architecture;
