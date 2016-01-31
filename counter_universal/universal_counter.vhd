library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity universal_counter is
--volime take cislo ake chceme pocitat s tim ze generic je nutne aby bylo dvojkove napriklad pokud chceme pocitat do 5 tak potrebujem  3 bitove cislo takze n bude 3
generic(n: natural :=4);
		Port(	clk:	in std_logic;										--systemovej clock
				rst:	in std_logic;										--reset
				enable_up:	in std_logic;								--povolovaci signal
				Q:	out std_logic_vector(n-1 downto 0);				--vysledek
				final: in std_logic_vector(n-1 downto 0));		--konecne pozadovane cislo	
end universal_counter;

architecture behvorial of universal_counter is		 	  
    signal count_q: std_logic_vector(n-1 downto 0) := (others => '0');

begin
   process(enable_up, rst, clk, count_q)
   begin
		if rst = '1' then
			 count_q <= (others => '0');
		elsif rising_edge(clk) then
			 if enable_up = '1' then
				if count_q < final then 
					count_q <= std_logic_vector(unsigned(count_q) + 1);
				else
					count_q <= (others => '0');
				end if; 
			 end if;
		end if;
   end process;	

    Q <= count_q;

end behvorial;
