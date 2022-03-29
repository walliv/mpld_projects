library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RP_TOP_TB is
end entity;

architecture BEHAVIORAL of RP_TOP_TB is

    signal simulation_finished : boolean := FALSE;

    signal clk : std_logic;

    signal btn_i        : std_logic_vector(3 downto 0);
    signal sw_i         : std_logic_vector(3 downto 0);
    signal led_o        : std_logic_vector(7 downto 0);
    signal disp_seg_o   : std_logic_vector(7 downto 0);
    signal disp_dig_o   : std_logic_vector(4 downto 0);
    signal uart_tx_data : std_logic;

    constant CLK_PERIOD : time := 20 NS;

begin

    dut_i : entity work.RP_TOP
        port map(
            clk             => clk,
            btn_i           => btn_i,         
            sw_i            => sw_i,      
            led_o           => led_o,     
            disp_seg_o      => disp_seg_o,
            disp_dig_o      => disp_dig_o,
            uart_tx_data    => uart_tx_data
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

    sw_i <= (others => '0');

    stim_p : process
    begin

        btn_i(0) <= '0'; 
        wait for CLK_PERIOD*50;
        btn_i(0) <= '1';
        wait for CLK_PERIOD*50;
        btn_i(0) <= '0';
        wait for CLK_PERIOD*100;

        --wait for clk_period * 5;
        --simulation_finished <= TRUE;
        wait;
    end process;  -- stim_p

end architecture;
