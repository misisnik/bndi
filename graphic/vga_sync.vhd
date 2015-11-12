----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:01:24 10/17/2015 
-- Design Name: 
-- Module Name:    vga_sync - Behavioral 
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
use IEEE.numeric_std.ALL;

--use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_sync is
   port(
      clk, reset: in std_logic;
      hsync, vsync: out std_logic;
      video_on: out std_logic;
      pixel_x, pixel_y: out std_logic_vector (9 downto 0)
    );
end vga_sync;

architecture Behavioral of vga_sync is
	--dividers for clock
   signal divider_reg, divider, pixel_clk: std_logic;
	--counter for pixels
   signal x_counter_reg, x_counter, y_counter_reg, y_counter: unsigned(9 downto 0);
	signal y_end, x_end: std_logic;
   -- synchronization
   signal v_sync, v_sync_reg, h_sync, h_sync_reg: std_logic;
begin
   --couter as v and h sync width prepared reset
   process (clk,reset)
   begin
      if reset='1' then
         --now it is reset action so
         --ve have to set v and h sync to 0
         v_sync_reg <= '0';
         h_sync_reg <= '0';
         --null pixels
         y_counter_reg <= (others=>'0');
         x_counter_reg <= (others=>'0');
         --power of divider for pixel clock
         divider_reg <= '0';
      elsif (clk'event and clk='1') then
         --new data for h and v sync
         v_sync_reg <= v_sync;
         h_sync_reg <= h_sync;
         --new data for pixels
         y_counter_reg <= y_counter;
         x_counter_reg <= x_counter;
         --new data for dificer for pixel clock
         divider_reg <= divider;
      end if;
   end process;
   --and completed clock for pixel
   divider <= not divider_reg;
   pixel_clk <= '1' when divider_reg='1' else '0';
   ----

   -- setting status of pixel if is in border of monitor
   --horisontal is 800 -> 0 to 799
   y_end <= '1' when x_counter_reg = 799 else 
            '0';
   --vertical is 525 -> 0 to 524
   x_end <= '1' when y_counter_reg = 524 else 
            '0';

   --horisontal synchronization
   process (x_counter_reg,y_end,pixel_clk)
   begin
      if pixel_clk='1' then
         if y_end='1' then
            x_counter <= (others=>'0');
         else
            x_counter <= x_counter_reg + 1;
         end if;
      else
         x_counter <= x_counter_reg;
      end if;
   end process;
   
	
	--vertical synchronization
   process (y_counter_reg,y_end,x_end,pixel_clk)
   begin
      if pixel_clk='1' and y_end='1' then
         if (x_end='1') then
            y_counter <= (others=>'0');
         else
            y_counter <= y_counter_reg + 1;
         end if;
      else
         y_counter <= y_counter_reg;
      end if;
   end process;
	
	--completed horisontal and vertical synchronization
   h_sync <= '1' when (x_counter_reg >= 656) and (x_counter_reg <= 751) else
				 '0';
   v_sync <= '1' when (y_counter_reg >= 490) and (y_counter_reg <= 491) else
				 '0';
	--output sinchronization, just read from register
   hsync <= h_sync_reg;
   vsync <= v_sync_reg;
   -- video on/off
   video_on <= '1' when (x_counter_reg < 640) and (y_counter_reg < 480) else
      '0';
   -- and finally push pixel x and y as std_logic_vector
   pixel_x <= std_logic_vector(x_counter_reg);
   pixel_y <= std_logic_vector(y_counter_reg);

end Behavioral;
