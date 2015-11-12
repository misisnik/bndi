----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:17:47 10/26/2015 
-- Design Name: 
-- Module Name:    keyboard - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity keyboard is
    Port ( input : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR(7 downto 0));
end keyboard;

architecture Behavioral of keyboard is
	component ps2_rx is
		 Port (clk, ps2_c, ps2_d : in  STD_LOGIC;
           ps_out : out  STD_LOGIC_VECTOR (7 downto 0));
	end component;
begin
	ps2rx_inst1 : ps2_rx
	port map (clk => clk, ps2_c => ps2_c, deb_out => reg_deb);

end Behavioral;

