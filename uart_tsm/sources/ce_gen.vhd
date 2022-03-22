-------------------------------------------------------------------------------
-- Title      : Clock divider
-- Project    : Libraries
-------------------------------------------------------------------------------
-- File       : ce_gen.vhd
-- Author     : Jan Kral  <kral.j@lit.cz>
-- Company    :
-- Created    : 2015-12-03
-- Last update: 2016-02-28
-- Platform   :
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: This entity divides input clock enable frequency by constant
-- factor given as generic parameter.
-------------------------------------------------------------------------------
-- Copyright (c) 2015 Jan Kral  <kral.j@lit.cz>
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2015-12-03  1.0      jakral  Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ce_gen is

  generic (
    DIV_FACT : positive := 2  -- clock division factor (when 1 output is always set,  2 for ce_o once per two clock enables
    );

  port (
    clk  : in  std_logic;               -- clock signal
    srst : in  std_logic;               -- synchronous reset
    ce   : in  std_logic;               -- input clock enable
    ce_o : out std_logic   -- clock enable output (always one clock long)
    );

end entity ce_gen;

architecture ce_gen_arch of ce_gen is

  -- @brief calculates number of bits needed to to fit number 'N'
  function bits_to_fit (N : natural) return natural is
    variable v_intermediate_x : natural;
    variable v_bit_count_d    : natural;
  begin
    v_intermediate_x := N;
    v_bit_count_d    := 0;
    loop
      exit when v_intermediate_x = 0;
      v_intermediate_x := v_intermediate_x / 2;
      v_bit_count_d    := v_bit_count_d + 1;
    end loop;

    if v_bit_count_d = 0 then
      return 1;
    end if;

    return v_bit_count_d;
  end;

  constant CNT_WIDTH : positive := bits_to_fit(DIV_FACT-1);  -- counter width

  signal cnt_d : unsigned (CNT_WIDTH-1 downto 0) := TO_UNSIGNED((DIV_FACT-1), CNT_WIDTH);  -- counter for clock division

begin  -- architecture clock_divider_arch

  everytime_output : if DIV_FACT = 1 generate
    ce_o <= ce;
  end generate everytime_output;


  divided_output : if DIV_FACT /= 1 generate

    -- purpose: divide clock to ouptut clock enable
    -- type   : sequential
    output_division : process (clk) is
    begin  -- process output_division
      if rising_edge(clk) then        -- rising clock edge
        if srst = '1' then              -- synchronous reset (active high)
          cnt_d <= (others => '0');
          ce_o  <= '0';
        else
          ce_o <= '0';                  -- by default ce_o output is not set
          if ce = '1' then
            cnt_d <= cnt_d + 1;
            if cnt_d = TO_UNSIGNED((DIV_FACT-1), cnt_d'length) then
              cnt_d <= (others => '0');
              ce_o  <= '1';
            end if;
          end if;
        end if;
      end if;
    end process output_division;

  end generate divided_output;

end architecture ce_gen_arch;
