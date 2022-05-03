library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RP_TOP_TB is
end entity;

architecture BEHAVIORAL of RP_TOP_TB is

    signal simulation_finished : boolean := FALSE;

    signal clk : std_logic;

    signal btn_i        : std_logic_vector(3 downto 0) := (others => '0');
    signal sw_i         : std_logic_vector(3 downto 0) := (others => '0');
    signal led_o        : std_logic_vector(7 downto 0);
    signal disp_seg_o   : std_logic_vector(7 downto 0);
    signal disp_dig_o   : std_logic_vector(4 downto 0);

    constant CLK_PERIOD : time := 20 NS;

begin

    dut_i : entity work.RP_TOP
        port map(
            CLK        => clk,
            BTN_I      => btn_i,         
            SW_I       => sw_i,      
            LED_O      => led_o,     
            DISP_SEG_O => disp_seg_o,
            DISP_DIG_O => disp_dig_o
        );


    clk_p : process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;

        if simulation_finished then
            wait;
        end if;
    end process;  -- lk_p

    stim_p : process
    begin

        -- perform reset
        sw_i(0) <= '1';
        wait for clk_period*100;
        sw_i(0) <= '0';

        wait for CLK_PERIOD*10;

        btn_i(0) <= '1';
        wait for CLK_PERIOD*20;
        btn_i(0) <= '0';
        wait for CLK_PERIOD*10;

        btn_i(3) <= '1';
        wait for CLK_PERIOD*20;
        btn_i(3) <= '0';
        wait for CLK_PERIOD*10;

        btn_i(2) <= '1';
        wait for CLK_PERIOD*20;
        btn_i(2) <= '0';
        wait for CLK_PERIOD*10;

        btn_i(1) <= '1';
        wait for CLK_PERIOD*20;
        btn_i(1) <= '0';
        wait for CLK_PERIOD*10;

        btn_i(2) <= '1';
        wait for CLK_PERIOD*20;
        btn_i(2) <= '0';
        wait for CLK_PERIOD*10;

        btn_i(3) <= '1';
        wait for CLK_PERIOD*20;
        btn_i(3) <= '0';
        wait for CLK_PERIOD*10;

        btn_i(2) <= '1';
        wait for CLK_PERIOD*20;
        btn_i(2) <= '0';
        wait for CLK_PERIOD*10;

        btn_i(1) <= '1';
        wait for CLK_PERIOD*20;
        btn_i(1) <= '0';


        wait for CLK_PERIOD * 100;
        simulation_finished <= TRUE;
        wait;
    end process;  -- stim_p

end architecture;
