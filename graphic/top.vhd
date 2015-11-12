----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:19:25 10/19/2015 
-- Design Name: 
-- Module Name:    top - Behavioral 
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

entity top is
    Port ( clk : in  STD_LOGIC;
           hsync, vsync : out  STD_LOGIC;
			  rgb : out std_logic_vector (2 downto 0));
end top;

architecture Behavioral of top is
	--connect components
	component vga_sync
	Port (  clk, reset: in std_logic;
      hsync, vsync: out std_logic;
      video_on: out std_logic;
      pixel_x, pixel_y: out std_logic_vector (9 downto 0));
	end component;
	
	component rom_1
	Port ( address : in  STD_LOGIC_VECTOR (14 downto 0);
           data : out  STD_LOGIC_VECTOR (3 downto 0));
	end component;
	-----
	--signals for work with pixels
	signal pixel_x, pixel_y : std_logic_vector(9 downto 0);
	signal pix_x, pix_y : unsigned(9 downto 0); 
	--signals for work with vga
	signal vga_clk : std_logic;
	signal video_on : std_logic;
	signal hsync_reg, vsync_reg : std_logic; 
	signal rgb_reg, rgb_out_reg: std_logic_vector(2 downto 0);
	
	--database
	signal db_data : std_logic_vector(3 downto 0);
	signal addr : unsigned(14 downto 0);
	--define object from rom_1
	constant ROM_SIZE : unsigned := to_unsigned(32,9);
	--panacek
	signal panacek_on : std_logic;
	signal panacek_x : unsigned(9 downto 0) := to_unsigned(48,9);	--start position
	signal panacek_y : unsigned(9 downto 0) := to_unsigned(64,9);	--start position
	--vrtule
	signal vrtula2_on : std_logic;
	signal vrtula2_x : unsigned(9 downto 0) := to_unsigned(32,9);	--start position
	signal vrtula2_y : unsigned(9 downto 0) := to_unsigned(32,9);	--start position
	signal vrtula1_on : std_logic;
	signal vrtula1_x : unsigned(9 downto 0) := to_unsigned(64,9);	--start position
	signal vrtula1_y : unsigned(9 downto 0) := to_unsigned(32,9);	--start position
	--object off
	signal background : std_logic;
begin
	vga_sync_1:vga_sync
		port map( clk => clk, reset=> '0', hsync => hsync_reg, vsync => vsync_reg,video_on => video_on, pixel_x => pixel_x, pixel_y =>pixel_y);

	database_1:rom_1
		port map( address => std_logic_vector(addr), data => db_data);

	--convert pixels
	pix_x <= unsigned(pixel_x);
	pix_y <= unsigned(pixel_y);
	
	
	--set out data
	process (video_on, rgb_reg, pix_x, pix_y) begin
		if rising_edge(clk) then
			if video_on = '1' then
				if background = '0' then
					rgb_out_reg <= db_data(2 downto 0);
				else
					rgb_out_reg <= "011";
				end if;
			else
				rgb_out_reg <= "000";
			end if;
		end if;
	end process;
	
	
	--get address of objects
	process (pix_x, pix_y, clk, panacek_on, vrtula1_on, vrtula2_on) begin
		if rising_edge(clk) then
			background <= '0';
			if  panacek_on = '1' then 
				addr <=  "00000" & (pix_y(4 downto 0) - panacek_y(4 downto 0)) & (pix_x(4 downto 0) - panacek_x(4 downto 0));
			elsif vrtula1_on = '1' then
				addr <=  "00001" & (pix_y(4 downto 0) - vrtula1_y(4 downto 0)) & (pix_x(4 downto 0) - vrtula1_x(4 downto 0));
			elsif vrtula2_on = '1' then
				addr <=  "00010" & (pix_y(4 downto 0) - vrtula2_y(4 downto 0)) & (pix_x(4 downto 0) - vrtula2_x(4 downto 0));
			else
				background <= '1';
			end if;
		end if;
	end process;
	
	--signals if object is on
	panacek_on <= '1' when (panacek_x <= pix_x) and ((panacek_x + ROM_SIZE -1) >= pix_x) and 
								  (panacek_y <= pix_y) and ((panacek_y + ROM_SIZE -1) >= pix_y) else '0';
	vrtula2_on <= '1' when (vrtula2_x <= pix_x) and ((vrtula2_x + ROM_SIZE -1) >= pix_x) and 
								  (vrtula2_y <= pix_y) and ((vrtula2_y + ROM_SIZE -1) >= pix_y) else '0';
	vrtula1_on <= '1' when (vrtula1_x <= pix_x) and ((vrtula1_x + ROM_SIZE -1) >= pix_x) and 
								  (vrtula1_y <= pix_y) and ((vrtula1_y + ROM_SIZE -1) >= pix_y) else '0';
	
	--set outputs
	rgb <= rgb_out_reg;
	hsync <= hsync_reg;
	vsync <= vsync_reg;
end Behavioral;
