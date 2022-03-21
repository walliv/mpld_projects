library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity STOPWATCH_FSM_TB is
end entity;

architecture BEHAVIORAL of STOPWATCH_FSM_TB is

    signal simulation_finished : boolean := FALSE;

    signal clk : std_logic;
    signal rst : std_logic;

    signal btn_start   : std_logic;
    signal btn_lap     : std_logic;
    signal cnt_reset   : std_logic;
    signal cnt_enable  : std_logic;
    signal disp_enable : std_logic;

    constant CLK_PERIOD : time := 20 NS;

begin

    dut_i : entity work.STOPWATCH_FSM
        port map(
            CLK         => clk,
            RST         => rst,
            BTN_START   => btn_start,
            BTN_LAP     => btn_lap,
            CNT_RESET   => cnt_reset,
            CNT_ENABLE  => cnt_enable,
            DISP_ENABLE => disp_enable
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
        rst       <= '1';
        btn_start <= '0';
        btn_lap   <= '0';

        wait for CLK_PERIOD*10;

        rst <= '0';
        wait for CLK_PERIOD*10;

        -- transition IDLE -> RUN
        btn_start <= '1';
        wait for CLK_PERIOD;
        btn_start <= '0';

        wait for CLK_PERIOD*10;

        -- transition RUN -> CNTR_STOP
        btn_start <= '1';
        wait for CLK_PERIOD;
        btn_start <= '0';

        wait for CLK_PERIOD*10;

        -- transition CNTR_STOP -> RUN
        btn_start <= '1';
        wait for CLK_PERIOD;
        btn_start <= '0';

        wait for CLK_PERIOD*10;

        -- transition RUN -> CNTR_STOP
        btn_start <= '1';
        wait for CLK_PERIOD;
        btn_start <= '0';

        wait for CLK_PERIOD*10;

        -- transition CNTR_STOP -> IDLE
        btn_lap <= '1';
        wait for CLK_PERIOD;
        btn_lap <= '0';

        wait for CLK_PERIOD*10;

        -- transition IDLE -> RUN
        btn_start <= '1';
        wait for CLK_PERIOD;
        btn_start <= '0';

        wait for CLK_PERIOD*10;

        -- transition RUN -> LAP
        btn_lap <= '1';
        wait for CLK_PERIOD;
        btn_lap <= '0';

        wait for CLK_PERIOD*10;

        -- transition LAP -> REFRESH
        btn_lap <= '1';
        wait for CLK_PERIOD;
        btn_lap <= '0';

        -- unconditional transition back to the LAP

        wait for CLK_PERIOD*10;

        -- transition LAP -> RUN
        btn_start <= '1';
        wait for CLK_PERIOD;
        btn_start <= '0';

        wait for CLK_PERIOD*10;

        -- transition RUN -> CNTR_STOP
        btn_start <= '1';
        wait for CLK_PERIOD;
        btn_start <= '0';

        wait for CLK_PERIOD*10;

        -- transition CNTR_STOP -> IDLE
        btn_lap <= '1';
        wait for CLK_PERIOD;
        btn_lap <= '0';

        wait for clk_period * 5;
        simulation_finished <= TRUE;
        wait;
    end process;  -- stim_p

end architecture;
