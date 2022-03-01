----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/22/2022 09:51:22 AM
-- Design Name: 
-- Module Name: MIC_RESPONSE_TOP - FULL
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MIC_RESPONSE_TOP is
    Port (
        CLK         : in std_logic; -- assumed to be 50 MHz
        RST         : in std_logic; -- active high
        MIC_DATA    : in std_logic;
        MIC_CLK     : out std_logic -- 3,125 MHz output clock
    );
end entity;

architecture FULL of MIC_RESPONSE_TOP is

    signal clk_div : unsigned(3 downto 0);

begin

    MIC_CLK <= clk_div(clk_div'high);
    
    clk_div_p : process(CLK)
    begin
        if(rising_edge(CLK)) then
            if(RST = '1') then
                clk_div <= (others => '0');            
            else
                clk_div <= clk_div + 1;
            end if;
        end if;    
    end process;
    
    


end architecture;
