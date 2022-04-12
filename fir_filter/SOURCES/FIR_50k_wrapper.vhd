----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
----------------------------------------------------------------------------------
ENTITY FIR_50k_wrapper IS
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
END FIR_50k_wrapper;
----------------------------------------------------------------------------------
ARCHITECTURE structural OF FIR_50k_wrapper IS
----------------------------------------------------------------------------------

  COMPONENT FIR_50k IS
  PORT (
    aclk                                : IN  STD_LOGIC;
    s_axis_data_tvalid                  : IN  STD_LOGIC;
    s_axis_data_tready                  : OUT STD_LOGIC;
    s_axis_data_tdata                   : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_data_tvalid                  : OUT STD_LOGIC;
    m_axis_data_tdata                   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
  END COMPONENT FIR_50k;

  COMPONENT FIR_50k_SIM IS
  PORT (
    aclk                                : IN  STD_LOGIC;
    s_axis_data_tvalid                  : IN  STD_LOGIC;
    s_axis_data_tready                  : OUT STD_LOGIC;
    s_axis_data_tdata                   : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_data_tvalid                  : OUT STD_LOGIC;
    m_axis_data_tdata                   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
  END COMPONENT FIR_50k_SIM;

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  gen_rtl_model: IF NOT SIM_MODEL GENERATE
    FIR_50k_i : FIR_50k
    PORT MAP(
      aclk                => aclk,
      s_axis_data_tvalid  => s_axis_data_tvalid,
      s_axis_data_tready  => s_axis_data_tready,
      s_axis_data_tdata   => s_axis_data_tdata,
      m_axis_data_tvalid  => m_axis_data_tvalid,
      m_axis_data_tdata   => m_axis_data_tdata
    );
  END GENERATE gen_rtl_model;

  gen_sim_model: IF SIM_MODEL GENERATE
    FIR_50k_i : FIR_50k_SIM
    PORT MAP(
      aclk                => aclk,
      s_axis_data_tvalid  => s_axis_data_tvalid,
      s_axis_data_tready  => s_axis_data_tready,
      s_axis_data_tdata   => s_axis_data_tdata,
      m_axis_data_tvalid  => m_axis_data_tvalid,
      m_axis_data_tdata   => m_axis_data_tdata
    );
  END GENERATE gen_sim_model;

----------------------------------------------------------------------------------
END structural;
----------------------------------------------------------------------------------
