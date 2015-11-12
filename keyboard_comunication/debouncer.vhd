----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:21:53 10/26/2015 
-- Design Name: 
-- Module Name:    debouncer - Behavioral 
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

entity debouncer is
    Port ( clk, deb_in : in  STD_LOGIC;
           deb_out : out  STD_LOGIC);
end debouncer;

architecture Behavioral of debouncer is
	signal reg : STD_LOGIC_VECTOR (7 downto 0):=(others=>'0');
begin
		
	process (clk)
	begin
		if (clk'event and clk = '1') then
			--move signal and add input
			reg <= reg(6 downto 0) & deb_in;
		end if;
	end process;
	
	--when register is full that out is 1 else 0
	deb_out <= '1' when reg = "11111111" else '0';

end Behavioral;

