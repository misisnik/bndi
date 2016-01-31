-- creator: Jan Sedlar
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
----------------------------------------------------------------------------
entity universal_divider is						--Funguje do 1Hz
generic  (DESIRED_FREQ: natural:=120); 		--vyb�rat takov� �isla aby 50MHz vyd�len� po�adovanou frekvenc� byla cel� �isla
															--Pokud zad�me 50Mhz/5 000 001 =9.99999 bude ��slo zaokrouhleno dole na 9 															-- coz je 5 555 555.556HZ ->Spatne
    Port ( clk, rst : in  STD_LOGIC;
           EN : out  STD_LOGIC);
end universal_divider;


architecture Behavioral of universal_divider is


----------------------------------------------------------------------------
--Funknce vrac� kolik bit� je pot�eba na ��slo------------------------------
--Pou�iteln� jen pro inicializaci-------------------------------------------
function log2c( n:natural ) return natural is
variable m , p ,sum: natural ;
begin
	m := 0;
	sum:= 0;
	p := 1;
	while sum < n loop
			m := m + 1;
			p := p * 2;
			sum:= sum+p;
	end loop ;
	return m;
end log2c;
----------------------------------------------------------------------------

----------------------------------------------------------------------------
--Inicializace velikosti sign�lu a vypo��tan� do kolika m� counter po��tat--
constant CLK_FREQ   :natural := 50000000;
constant MAX_COUNT  :natural := ((CLK_FREQ)/DESIRED_FREQ)-1;
signal counter 	  :std_logic_vector(log2c(MAX_COUNT-1) downto 0):=(others => '0');
signal counter_next :std_logic_vector(log2c(MAX_COUNT-1) downto 0):=(others => '0');
----------------------------------------------------------------------------



----------------------------------------------------------------------------
--Shift regist countru------------------------------------------------------
begin
process(clk)
begin
  if(clk'event and clk='1') then
		counter<=counter_next;
  end if;
end process;
----------------------------------------------------------------------------


----------------------------------------------------------------------------
--Logika countru s enable sign�lem------------------------------------------
counter_next<= (others => '0') when (MAX_COUNT = counter)
					else counter+1;

EN <= '0' when rst = '1' else					
		'1' when (MAX_COUNT = counter)
			 else '0';		
----------------------------------------------------------------------------


end Behavioral;
