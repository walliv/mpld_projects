----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
USE std.textio.ALL;
----------------------------------------------------------------------------------
entity FIR_50k_TB is
end FIR_50k_TB;
----------------------------------------------------------------------------------
architecture tb of FIR_50k_TB is
----------------------------------------------------------------------------------

  COMPONENT FIR_50k_wrapper IS
  GENERIC (
    SIM_MODEL                           : BOOLEAN := TRUE
  );
  PORT (
    aclk                                : IN  STD_LOGIC;
    s_axis_data_tvalid                  : IN  STD_LOGIC;
    s_axis_data_tready                  : OUT STD_LOGIC;
    s_axis_data_tdata                   : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_data_tvalid                  : OUT STD_LOGIC;
    m_axis_data_tdata                   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
  END COMPONENT FIR_50k_wrapper;

  -----------------------------------------------------------------------

  SIGNAL sig_SIM_finished               : BOOLEAN := FALSE;

  CONSTANT C_aclk_period                : time := 20 ns;
  SIGNAL aclk                           : STD_LOGIC := '0';

  SIGNAL s_axis_data_tvalid             : STD_LOGIC := '0';
  SIGNAL s_axis_data_tready             : STD_LOGIC;
  SIGNAL s_axis_data_tdata              : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
  SIGNAL m_axis_data_tvalid             : STD_LOGIC;
  SIGNAL m_axis_data_tdata              : STD_LOGIC_VECTOR(15 DOWNTO 0);


    signal inp_cntr : integer := 0;
    signal err_cntr : integer := 0;

----------------------------------------------------------------------------------
begin
----------------------------------------------------------------------------------


  --------------------------------------------------------------------------------
  -- Clock process definitions
  --------------------------------------------------------------------------------

  P_aclk: PROCESS
  BEGIN
    aclk <= '0'; WAIT FOR C_aclk_period/2;
    aclk <= '1'; WAIT FOR C_aclk_period/2;
    IF sig_SIM_finished THEN WAIT; END IF;
  END PROCESS P_aclk;


  -----------------------------------------------------------------------
  -- Instantiate the DUT
  -----------------------------------------------------------------------

  FIR_50k_i : FIR_50k_wrapper
  GENERIC MAP(
    SIM_MODEL           => TRUE
  )
  PORT MAP(
    aclk                => aclk,
    s_axis_data_tvalid  => s_axis_data_tvalid,
    s_axis_data_tready  => s_axis_data_tready,
    s_axis_data_tdata   => s_axis_data_tdata,
    m_axis_data_tvalid  => m_axis_data_tvalid,
    m_axis_data_tdata   => m_axis_data_tdata
  );

  -----------------------------------------------------------------------
  -- FIR input
  --    read FIR_data_in.txt
  --    feed the FIR filter with the data from file
  -----------------------------------------------------------------------

    read_txt_p : process

        file file_id : text;
        variable line_in : line;
        variable v_number : integer;

    begin

        file_open(file_id, "..\..\..\..\SOURCES\FIR_data\FIR_data_in.txt", read_mode);
        wait until falling_edge(aclk);

        while not endfile(file_id) loop

            readline(file_id,line_in);
            read(line_in,v_number);

            s_axis_data_tdata <= std_logic_vector(to_signed(v_number,16));
            s_axis_data_tvalid <= '1';
            wait for C_aclk_period * 1;
            s_axis_data_tvalid <= '0';
            wait for C_aclk_period * 7;

        end loop;

        file_close(file_id);
        sig_SIM_finished <= true;
        wait;
    end process; 

  -----------------------------------------------------------------------
  -- FIR output data check
  --    read reference data from FIR_data_out.txt
  --    compare the reference and actual data
  --    report any discrepancy (both a text LOG file and simulator console)
  --    report overall test result
  -----------------------------------------------------------------------

    log_file_report_gen_p : process

        file ctl_file_id : text;
        file log_file_id : text;

        variable line_out : line;
        variable line_in : line;

        variable v_number : integer;


        variable o_data : integer;
        variable data_delta : integer;
    
    begin

        file_open(ctl_file_id, "..\..\..\..\SOURCES\FIR_data\FIR_data_out.txt", read_mode);
        file_open(log_file_id, "log_data_out.txt", write_mode);
        wait until falling_edge(aclk);

        while (not sig_SIM_finished) and (not endfile(ctl_file_id)) loop

            if m_axis_data_tvalid = '1' then

                o_data := to_integer(signed(m_axis_data_tdata));
                write (line_out, string'("Simulation time: "));
                write (line_out, time'image(now));
                write (line_out, string'(", output data (decimal): "));
                write (line_out, integer'image(o_data));

                report line_out.all severity note;
                writeline (log_file_id, line_out);

                readline(ctl_file_id,line_in);
                read(line_in,v_number);

                data_delta := v_number - o_data;
                inp_cntr <= inp_cntr + 1;
                
                if (data_delta /= 0) then

                    err_cntr <= err_cntr + 1;
                    write (line_out, string'("ERROR: Output data mismatch: "));
                    write (line_out, integer'image(v_number));
                    write (line_out, string'(", delta: "));
                    write (line_out, integer'image(data_delta));

                    report line_out.all severity note;
                    writeline (log_file_id, line_out);

                else

                    
                

                end if;
                
            end if;

            wait for C_aclk_period;

        end loop;

        file_close (ctl_file_id);
        file_close (log_file_id);

        wait;
    end process;
 
    fin_p : process
    begin 
    
    	wait until sig_SIM_finished;
        wait for 10 ns;
        
        if(err_cntr /= 0) then
            report "Test FAILED! The amount of errors: " & INTEGER'image(err_cntr) & ", number of inputs: " & INTEGER'image(inp_cntr);        
        else
            report "Test PASSED! There are zero errors. Number of inputs: " & INTEGER'image(inp_cntr);        
        end if;
    
    end process;
----------------------------------------------------------------------------------
end tb;
----------------------------------------------------------------------------------
