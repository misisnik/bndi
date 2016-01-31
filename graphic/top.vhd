library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use ieee.std_logic_unsigned.all;
entity top is
    Port ( clk, reset : in  STD_LOGIC;
			  but : in STD_LOGIC;
           hsync, vsync, ledka, ledka2 : out  STD_LOGIC;
			  skor, game_uk : out std_logic_vector (1 downto 0);
			  rgb : out std_logic_vector (2 downto 0));
end top;

architecture Behavioral of top is
	------------------------
	--nejdrive si nadefinujeme pouzivane komponenty vcetne prekazek apodobne...
	------------------------
	--connect components
	component vga_sync
	Port (  clk, reset: in std_logic;
      hsync, vsync: out std_logic;
      video_on: out std_logic;
      pixel_x, pixel_y: out std_logic_vector (9 downto 0));
	end component;
	
	--debouncer component 
	component debouncer
	Port ( clk,clk_en,vstup : in  STD_LOGIC;
           rst,vystup : out  STD_LOGIC);
	end component;
	--rom 1 -- panacek, vrtula, melej mrak, retez
	component rom_1
	Port (  address_a : in  STD_LOGIC_VECTOR (12 downto 0);
			  address_b : in  STD_LOGIC_VECTOR (12 downto 0);
			  clk : in STD_LOGIC;
			  data_a : out  STD_LOGIC_VECTOR (3 downto 0);
           data_b : out  STD_LOGIC_VECTOR (3 downto 0));
	end component;
	--rom 2 -- prekazka, blbost na retezu 4x
	component rom_2
	Port (  address_a : in  STD_LOGIC_VECTOR (11 downto 0);
			  address_b : in  STD_LOGIC_VECTOR (11 downto 0);
			  clk : in STD_LOGIC;
			  data_a : out  STD_LOGIC_VECTOR (3 downto 0);
           data_b : out  STD_LOGIC_VECTOR (3 downto 0));
	end component;
	--rom 3 -- strom, technika, oblak
	component rom_3
	Port (  address_a : in  STD_LOGIC_VECTOR (13 downto 0);
			  address_b : in  STD_LOGIC_VECTOR (13 downto 0);
			  clk : in STD_LOGIC;
			  data_a : out  STD_LOGIC_VECTOR (3 downto 0);
           data_b : out  STD_LOGIC_VECTOR (3 downto 0));
	end component;
	--rom 4 -- pismo a cisla
	component rom_4
	Port (  address : in  STD_LOGIC_VECTOR (12 downto 0);
			  clk : in STD_LOGIC;
           data : out  STD_LOGIC_VECTOR (3 downto 0));
	end component;
	
	--universal divider
	component universal_divider
	 generic  (DESIRED_FREQ: natural:=120); 
	 Port ( clk, rst : in  STD_LOGIC;
           EN : out  STD_LOGIC);
	end component;
	--universal counter
	component universal_counter
			generic(n: natural :=4);
			Port(	clk:	in std_logic;									
				rst:	in std_logic;									
				enable_up:	in std_logic;		
				Q:	out std_logic_vector(n-1 downto 0);
				final: in std_logic_vector(n-1 downto 0));
	end component;
	
	--random generator
	component random
	    Port ( 	
				clk 		: in  std_logic; 
				PSU 		: out STD_LOGIC_VECTOR (3 downto 0);
				NEW_SEED : in std_logic_vector (15 downto 0));
	end component;
	
	--bin to bcd show numeric
	component BIN_TO_BCD_12BIT
	    Port ( clk 			: in STD_LOGIC;
			  reset			: in STD_LOGIC;
			  clk_en 		: in STD_LOGIC:= ('1');
			  Binarni_skore: in  STD_LOGIC_VECTOR (11 downto 0);
           BCD_Jednotky : out  STD_LOGIC_VECTOR (3 downto 0);
           BCD_Desitky 	: out  STD_LOGIC_VECTOR (3 downto 0);
           BCD_Stovky 	: out  STD_LOGIC_VECTOR (3 downto 0);
           BCD_Tisice 	: out  STD_LOGIC_VECTOR (3 downto 0));
	end component;
	
	--------------------------------------
	--nadefinujeme si pomocne signaly - predevsim pro umisteni objektu vcetne toho jeslti maj byt zapnute nebo ne
	--------------------------------------
	signal pixel_x, pixel_y : std_logic_vector(9 downto 0) := (others=>'0');
	--signals for work with vga
	signal video_on : std_logic := '0';
	signal hsync_reg, vsync_reg : std_logic; 
	signal rgb_out_reg: std_logic_vector(2 downto 0) := (others=>'0');
	
	--database
	signal db_data_reg : std_logic_vector(3 downto 0) := (others=>'0');
	--define object for rom_1
	constant ROM32_SIZE : integer := 32;
	--define object for rom_2
	constant ROM64_SIZE : integer := 64;
	
	--define object for rom_4
	constant ROM16_SIZE : integer := 16;
	--panacek
	signal panacek_on : std_logic;
	signal panacek_x, panacek_x_reg : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(304,10));	--start position
	signal panacek_y, panacek_y_reg : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(320,10));	--start position
	--vrtule
	signal vrtula2_on : std_logic;
	signal vrtula2_x : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(288,10));	--start position
	signal vrtula2_y : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(288,10));	--start position
	signal vrtula1_on : std_logic;
	signal vrtula1_x : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(320,10));	--start position
	signal vrtula1_y : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(288,10));	--start position
	--mracek
	signal mracek_on : std_logic;
	signal mracek_x, mracek_x_reg : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(304,10));	--start position
	signal mracek_y, mracek_y_reg : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(224,10));	--start position
	--mracek
	signal mracek_2_on : std_logic;
	signal mracek_2_x, mracek_2_x_reg : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(304,10));	--start position
	signal mracek_2_y, mracek_2_y_reg : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(738,10));	--start position

	--vertikalni prekazka
	signal vprekazka1_on : std_logic;
	signal vprekazka1_x : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(57,10));	--start position
	signal vprekazka1_y : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(0,10));	--start position
	signal vprekazka2_on : std_logic;
	signal vprekazka2_x : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(560,10));	--start position
	signal vprekazka2_y : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(0,10));	--start position
	--horizontalni prekazka
	signal hprekazka1_on : std_logic;
	signal hprekazka1_x : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(0,10));	--start position
	signal hprekazka1_y, hprekazka1_y_reg : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(940,10));	--start position
	signal hprekazka2_on : std_logic;
	signal hprekazka2_x : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(0,10));	--start position
	signal hprekazka2_y, hprekazka2_y_reg: std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(500,10));	--start position
	--64bitove
	-----------
	--strom
	signal strom_on :std_logic;
	signal strom_x : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(96,10));	--start position
	signal strom_y, strom_y_reg : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(416,10));	--start position
	--mrak
	signal mrak_on :std_logic;
	signal mrak_x, mrak_x_reg : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(145,10));	--start position
	signal mrak_y, mrak_y_reg : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(54,10));	--start position
	--mrak
	signal mrak2_on :std_logic;
	signal mrak2_x, mrak2_x_reg : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(410,10));	--start position
	signal mrak2_y, mrak2_y_reg : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(908,10));	--start position
	
	--mrak
	signal mrak_2_on :std_logic;
	signal mrak_2_x, mrak_2_x_reg : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(145,10));	--start position
	signal mrak_2_y, mrak_2_y_reg : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(568,10));	--start position
	--mrak
	signal mrak2_2_on :std_logic;
	signal mrak2_2_x, mrak2_2_x_reg : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(410,10));	--start position
	signal mrak2_2_y, mrak2_2_y_reg : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(398,10));	--start position

	--technika
	signal technika_on :std_logic;
	signal technika_x : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(293,10));	--start position
	signal technika_y, technika_y_reg : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(352,10));	--start position
	
	--killleerr 3000
	signal killer1_on : std_logic;
	signal killer1_x : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(0,10));	--start position
	signal killer1_y : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(0,10));	--start position
	signal killer2_on : std_logic;
	signal killer2_x : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(0,10));	--start position
	signal killer2_y : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(0,10));	--start position
	--dratek
	signal dratek1_on : std_logic;
	signal dratek1_x : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(0,10));	--start position
	signal dratek1_y, dratek1_y_reg : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(18,10));	--start position
	signal dratek2_on : std_logic;
	signal dratek2_x : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(0,10));	--start position
	signal dratek2_y, dratek2_y_reg : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(518,10));	--start position
	
	----16 bitove
	--cisla
	--jednotky
	signal jednotky_on : std_logic;
	signal jednotky_x : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(330,10));	--start position
	signal jednotky_y : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(96,10));	--start position
	--desitky
	signal desitky_on : std_logic;
	signal desitky_x : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(312,10));	--start position
	signal desitky_y : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(96,10));	--start position
	--stovky
	signal stovky_on : std_logic;
	signal stovky_x : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(294,10));	--start position
	signal stovky_y : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(96,10));	--start position
	
	--pismena
	--titulek xcopters
	--x
	signal tit_x_on : std_logic;
	signal tit_x_x : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(20,10));	--start position
	signal tit_x_y : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(30,10));	--start position
	--c
	signal tit_c_on : std_logic;
	signal tit_c_x : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(20,10));	--start position
	signal tit_c_y : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(60,10));	--start position
	--o
	signal tit_o_on : std_logic;
	signal tit_o_x : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(20,10));	--start position
	signal tit_o_y : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(90,10));	--start position
	--p
	signal tit_p_on : std_logic;
	signal tit_p_x : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(20,10));	--start position
	signal tit_p_y : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(120,10));	--start position
	--t
	signal tit_t_on : std_logic;
	signal tit_t_x : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(20,10));	--start position
	signal tit_t_y : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(150,10));	--start position
	--e
	signal tit_e_on : std_logic;
	signal tit_e_x : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(20,10));	--start position
	signal tit_e_y : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(180,10));	--start position
	--r
	signal tit_r_on : std_logic;
	signal tit_r_x : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(20,10));	--start position
	signal tit_r_y : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(210,10));	--start position
	--s
	signal tit_s_on : std_logic;
	signal tit_s_x : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(20,10));	--start position
	signal tit_s_y : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(240,10));	--start position
	
	--others letters
	--g
	signal let_g_on : std_logic;
	signal let_g_x : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(258,10));	--start position
	signal let_g_y : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(39,10));	--start position
	--a
	signal let_a_on : std_logic;
	signal let_a_x : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(276,10));	--start position
	signal let_a_y : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(39,10));	--start position
	--m
	signal let_m_on : std_logic;
	signal let_m_x : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(294,10));	--start position
	signal let_m_y : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(39,10));	--start position
	--o
	signal let_o_on : std_logic;
	signal let_o_x : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(340,10));	--start position
	signal let_o_y : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(39,10));	--start position
	--v
	signal let_v_on : std_logic;
	signal let_v_x : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(358,10));	--start position
	signal let_v_y : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(39,10));	--start position
	--r
	signal let_r_on : std_logic;
	signal let_r_x : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(394,10));	--start position
	signal let_r_y : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(39,10));	--start position
	--press to start
	--press_p
	signal press_p_on : std_logic;
	signal press_p_x : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(276,10));	--start position
	signal press_p_y : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(135,10));	--start position

	--press_r
	signal press_r_on : std_logic;
	signal press_r_x : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(294,10));	--start position
	signal press_r_y : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(135,10));	--start position

	--press_e
	signal press_e_on : std_logic;
	signal press_e_x : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(312,10));	--start position
	signal press_e_y : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(135,10));	--start position

	--press_s
	signal press_s_on : std_logic;
	signal press_s_x : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(330,10));	--start position
	signal press_s_y : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(135,10));	--start position

	--press_s2
	signal press_s2_on : std_logic;
	signal press_s2_x : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(348,10));	--start position
	signal press_s2_y : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(135,10));	--start position

	--button
	signal button_on : std_logic;
	signal button_x : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(312,10));	--start position
	signal button_y : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(160,10));	--start position
	
	-----------------
	--pomocne signaly pro amimace
	-----------------
	signal vrtula_clk, killer_clk, game_clk, game_over_clk, dratek_clk, module_reset, module_reset_reg: std_logic;
	signal counter_vrtula, counter_killer: std_logic_vector(1 downto 0) := (others=>'0');
	signal counter_dratek : std_logic_vector(3 downto 0);
	signal counter_game, counter_game_over : std_logic_vector(4 downto 0) := (others=>'0');
	
	signal addr_rom1_a, addr_rom1_b: std_logic_vector(12 downto 0) := (others=>'0');
	signal addr_rom2_a, addr_rom2_b: std_logic_vector(11 downto 0) := (others=>'0');
	signal addr_rom3_a, addr_rom3_b : std_logic_vector(13 downto 0) := (others=>'0');
	signal addr_rom4 : std_logic_vector(12 downto 0) := (others=>'0');
	--signaly pro praci s databzi spolu s pomocnejma
	signal data_rom1_a, data_rom1_b, data_rom2_a, data_rom2_b, data_rom3_a, data_rom3_b, data_rom4 : std_logic_vector(3 downto 0) := (others=>'0');
	signal scale_helper1, scale_helper2 : std_logic_vector(6 downto 0);
	
	
	--prkeazky nastaveni
	constant ALL_BREAKS, SPEED : integer := 13;	--celkem muze byt na haci plose 13*32px prekazek
	signal random_break1, random1_reg : std_logic_vector(3 downto 0):= std_logic_vector(to_unsigned(5,4));
	signal random_break2, random2_reg : std_logic_vector(3 downto 0):= std_logic_vector(to_unsigned(8,4));
	signal rand, random_reg, rand_gen : std_logic_vector(3 downto 0) := (others=>'0');
	signal killer_x_pos, killer_y_pos, killer_x_reg, killer_y_reg : std_logic_vector(9 downto 0) := (others=>'0');
	
	--osetreni tlacitka pro ovladani panaka
	signal debouncer_clk, button, debouncer_rst : std_logic;
	
	---signaly pro ovladani hry
	signal run, run_reg, crash, orientation, orientation_reg, button_break, button_break_reg, panacek_clk, panacek_over_clk :std_logic  := '0';
	
	----pocitani skore
	signal skore, skore_reg : std_logic_vector(11 downto 0) := (others => '0');
	signal jednotky, desitky, stovky: std_logic_vector(3 downto 0) := (others => '0');
	signal skore_clk : std_logic;
	
	
	--game pages
	signal game, game_reg : std_logic_vector(1 downto 0) := (others => '0'); --signal for game indication

	--ukazovani obektu plynule nad obrazem helpery
	signal mracek_help,mrak1_help,mrak2_help,mracek_2_help,mrak1_2_help,mrak2_2_help,killer1_help,killer2_help,dratek1_help, dratek2_help, hprekazka1_help, hprekazka2_help : std_logic_vector(9 downto 0);
begin
	------------------------
	---hlavni statusy hry
	---1.uvodni obrazovna, 2.hra, 3. game over
	------------------------
	process (clk, button, button_break, crash, game, game_over_clk) begin
		if rising_edge(clk) then
			if game = "00" and button = '1' and button_break = '0' then
				game_reg <= "01";
			elsif game = "01" and crash = '1'  and button_break = '0' then
				game_reg <= "10";
			elsif (game = "10" and button = '1'  and button_break = '0') or (reset='1') then
				game_reg <= "00";			
			end if;
		end if;
	end process;
	game <= game_reg;
	game_uk <= game_reg;

	------------------------------------------------------
	------------------------------------------------------
	--importovani knihoven
	-----------------------
	vga_sync_1:vga_sync
		port map( clk => clk, reset=> '0', hsync => hsync_reg, vsync => vsync_reg,video_on => video_on, pixel_x => pixel_x, pixel_y =>pixel_y);
	
	---------------
	--dividers
	---------------
	--divider vrtula
	divider_vr:universal_divider
		generic map ( DESIRED_FREQ => 10)
		port map ( clk => clk, rst => not run, EN => vrtula_clk);
	--divider killer
	divider_kl:universal_divider
		generic map ( DESIRED_FREQ => 15)
		port map ( clk => clk, rst => '0', EN => killer_clk);
	--divider dratek
	divider_dr:universal_divider
		generic map ( DESIRED_FREQ => 4)
		port map ( clk => clk, rst => '0', EN => dratek_clk);
	--game clk	
	divider_game:universal_divider
		generic map ( DESIRED_FREQ => 80)
		port map ( clk => clk, rst => not run, EN => game_clk);
	--game over clk	
	divider_game_over:universal_divider
		generic map ( DESIRED_FREQ => 90)
		port map ( clk => clk, rst => '0', EN => game_over_clk);	
	--panacek clk	
	divider_panacek:universal_divider
		generic map ( DESIRED_FREQ => 160)
		port map ( clk => clk, rst => not run, EN => panacek_clk);
	divider_panacek_over:universal_divider
		generic map ( DESIRED_FREQ => 200)
		port map ( clk => clk, rst => run, EN => panacek_over_clk);	
	--divider 5kHz pro to pocitadlo
	divider_pocitadlo:universal_divider
		generic map (DESIRED_FREQ => 5000)
		port map ( clk => clk, rst => not run, EN => skore_clk);
	--debouncer divider -10ms
	divider_debouncer:universal_divider
		generic map (DESIRED_FREQ => 100)
		port map ( clk => clk, rst => '0',  EN => debouncer_clk);

	---------------
	--counters pro pocitani vseho mozneho
	---------------
	--counter vrtula
	counter_vr:universal_counter
		generic map ( n => 2)
		port map (clk => clk, rst => module_reset, enable_up => vrtula_clk, Q => counter_vrtula, final => "10");
	counter_kl:universal_counter
		generic map ( n => 2)
		port map (clk => clk, rst => module_reset, enable_up => killer_clk, Q => counter_killer, final => "01");
	--counter killer
	counter_gam:universal_counter
		generic map ( n => 5)
		port map (clk => clk, rst => module_reset, enable_up => game_clk, Q => counter_game, final => "11111");
	counter_gam_over:universal_counter
		generic map ( n => 5)
		port map (clk => clk, rst => '0', enable_up => game_over_clk, Q => counter_game_over, final => "11111");	
	counter_dr:universal_counter
		generic map ( n => 4)
		port map (clk => clk, rst => module_reset, enable_up => dratek_clk, Q => counter_dratek, final => "1001");
		
	debouncer_but:debouncer
		port map( clk => clk, clk_en => debouncer_clk, vstup => but, rst => debouncer_rst, vystup => button);
		
	---------------------	
	--random generator
	---------------------
	rand_generator:random
	   port map ( clk => clk, PSU => rand_gen, NEW_SEED => "0000000000000000");
		
	--------------------	
	--skore dekoder
	--------------------
	skore_dekoder: BIN_TO_BCD_12BIT
		port map ( clk => clk, reset => module_reset, clk_en => skore_clk, Binarni_skore => skore, BCD_Jednotky => jednotky, BCD_Desitky => desitky, BCD_Stovky => stovky, BCD_Tisice => open);
		
	-------------------
	---prace s tlacitkem
	-------------------
	process (clk, button, button_break, run, panacek_clk, crash, game) begin
		if rising_edge(clk) then
			--button long press detection
			if button = '1' and button_break = '0' and game /= "00" then
				button_break_reg <= '1';
			end if;
			--pokud je dlouho zmacknute tlacitko tak se to mnusi trochu osetrit
			if button = '0' then
				button_break_reg <= '0';
			end if;
			
			
			--reset or new game
			if reset = '1' or game = "00" then 
				panacek_x_reg <= std_logic_vector(to_unsigned(304,10));
				orientation_reg <= '0';
				run_reg <= '0';
				module_reset_reg <= '1';
			else
				module_reset_reg <= '0';
				
				--spiusteni hry pokud se zmackne tlaciyko
				if button = '1' and button_break = '0' and run = '0' and (game /= "01" or game /= "00") then
					run_reg <= '1';
				end if; 
				--zmacknute tlacitko a zmena pozice
				if button = '1' and run = '1' and button_break = '0' then
					orientation_reg <= not orientation;
					--stahovani nahodnejch velicin
					if unsigned(rand_gen) > 11 then
						random_reg <= std_logic_vector(to_unsigned(11,4));
					elsif unsigned(rand_gen) = 0 then
						random_reg <= std_logic_vector(to_unsigned(1,4));
					else
						random_reg <= rand_gen;
					end if;
				end if;

				--orientace panacka po zmacknuti tlacitka
				if run = '1' and panacek_clk = '1' then
					--hra bezi tak muzem pohybovat panakem
					if orientation = '1' then
						--pohybujeme se doprava - pricitame 1cku
						panacek_x_reg <= std_logic_vector(unsigned(panacek_x) +1);
					else
						panacek_x_reg <= std_logic_vector(unsigned(panacek_x) -1);
					end if;
				---game over
				elsif game = "10" then
					--change orientation
					if crash = '1' then
						orientation_reg <= not orientation;
					end if;
					if panacek_over_clk = '1' then
						--hra bezi tak muzem pohybovat panakem
						if orientation = '1' then
							--pohybujeme se doprava - pricitame 1cku
							panacek_x_reg <= std_logic_vector(unsigned(panacek_x) +1);
						else
							panacek_x_reg <= std_logic_vector(unsigned(panacek_x) -1);
						end if;
					end if;	
				end if;
				
				if crash = '1' then
					run_reg <= '0';
				end if;	
			end if;	
		end if;
	end process;
	module_reset <= module_reset_reg;
	panacek_x <= panacek_x_reg;
	run <= run_reg;
	orientation <= orientation_reg;
	button_break <= button_break_reg;
	ledka2 <= crash;	
	ledka <= button;
	rand <= random_reg;
	
	-------------------
	--pocotadlo pruchodu panakove
	-------------------
	process (clk, game_clk, reset, game, panacek_y, hprekazka1_y, hprekazka2_y) begin
		if rising_edge(clk) then
			--reset or new game
			if reset = '1' or game = "00" then 
				skore_reg <= (others=>'0');
			else
				if game_clk = '1' then
					--pokud je panacek y stejnej jak hprekazka1_y + 17 nebo stejne jjak hprekazka2_y + 17 tak se musi pricist cislo
					if (unsigned(panacek_y) + 17 = unsigned(hprekazka1_y)) or 
						(unsigned(panacek_y) + 17 = unsigned(hprekazka2_y)) then 
						skore_reg <= std_logic_vector(unsigned(skore) + 1);
					end if;
				end if;
			end if;
		end if;
	end process;
	skore <= skore_reg;
	skor <= game;
	
	
	-------------------
	---detekce narazeni
	-------------------
	 crash <= '1' when ((panacek_on = '1' or vrtula1_on = '1' or vrtula2_on = '1') and data_rom1_a(3) = '0')  --panak nebo vrtula je zapla je aktivni pin, taze muze narazit
				 and
				 (
					(
						(hprekazka1_on = '1' or hprekazka2_on = '1' or vprekazka1_on = '1' or vprekazka2_on = '1' or killer1_on = '1' or killer2_on = '1' or dratek1_on = '1' or dratek2_on = '1') and (data_rom2_a(3) = '0') 
					)or
					(
						(dratek1_on = '1' or dratek2_on = '1') and (data_rom1_b(3) = '0') 
					)
				 )
				 else '0';
	
	--------------------------
	--posunovani tema zakladama
	--------------------------
	process (clk, game_clk,reset, game, technika_y, run) begin
		if rising_edge(clk) then
			--reset or new game
			if reset = '1' or game = "00" then 
				technika_y_reg <= std_logic_vector(to_unsigned(352,10));
				strom_y_reg <= std_logic_vector(to_unsigned(416,10));
			else
				if game_clk = '1' then
					if unsigned(technika_y) <= 500 and run = '1' then
						technika_y_reg <= std_logic_vector(unsigned(technika_y) + 1);
						strom_y_reg <= std_logic_vector(unsigned(strom_y) + 1);
					end if;
				end if;
			end if;
		end if;
	end process;
	technika_y <= technika_y_reg;
	strom_y <= strom_y_reg;


	----------------------------------------------------------------
	--animations prekazky + generovani nahodnejch pozici tech prekzek
	----------------------------------------------------------------
	process (clk, game_clk, game_over_clk, reset, game, hprekazka1_y, hprekazka2_y, skore) begin
		if rising_edge(clk) then
			--reset or new game
			if reset = '1' or game = "00" then 
				hprekazka1_y_reg <= std_logic_vector(to_unsigned(960,10));
				hprekazka2_y_reg <= std_logic_vector(to_unsigned(500,10));
				dratek2_y_reg <= std_logic_vector(to_unsigned(518,10));
				dratek1_y_reg <= std_logic_vector(to_unsigned(978,10));
				
				--mraky
				mracek_x_reg <= std_logic_vector(to_unsigned(304,10));
				mracek_y_reg <= std_logic_vector(to_unsigned(224,10));
				mrak_x_reg <= std_logic_vector(to_unsigned(145,10));
				mrak_y_reg <= std_logic_vector(to_unsigned(54,10));
				mrak2_x_reg <= std_logic_vector(to_unsigned(410,10));
				mrak2_y_reg <= std_logic_vector(to_unsigned(908,10));
				mracek_2_x_reg <= std_logic_vector(to_unsigned(304,10));
				mracek_2_y_reg <= std_logic_vector(to_unsigned(738,10));
				mrak_2_x_reg <= std_logic_vector(to_unsigned(145,10));
				mrak_2_y_reg <= std_logic_vector(to_unsigned(568,10));
				mrak2_2_x_reg <= std_logic_vector(to_unsigned(410,10));
				mrak2_2_y_reg <= std_logic_vector(to_unsigned(398,10));
			else
				if game_clk = '1' then
					--mraky animation
					mracek_y_reg <= std_logic_vector(unsigned(mracek_y) + 1);
					mrak_y_reg <= std_logic_vector(unsigned(mrak_y) + 1);
					mrak2_y_reg <= std_logic_vector(unsigned(mrak2_y) + 1);
					
					mracek_2_y_reg <= std_logic_vector(unsigned(mracek_2_y) + 1);
					mrak_2_y_reg <= std_logic_vector(unsigned(mrak_2_y) + 1);
					mrak2_2_y_reg <= std_logic_vector(unsigned(mrak2_2_y) + 1);
					
					--reset animace kdys je v urcite pozici
					if (unsigned(hprekazka1_y) = 235) then --299-64=235
						hprekazka2_y_reg <= std_logic_vector(to_unsigned(960,10));	--1024-64=960
						hprekazka1_y_reg <= std_logic_vector(unsigned(hprekazka1_y) + 1);
						
						dratek2_y_reg <= std_logic_vector(to_unsigned(978,10));	--960+18=978
						dratek1_y_reg <= std_logic_vector(unsigned(dratek1_y) + 1);
					elsif (unsigned(hprekazka2_y) = 235) then	--299-64=235
						hprekazka1_y_reg <= std_logic_vector(to_unsigned(960,10));	--1024-64=960
						hprekazka2_y_reg <= std_logic_vector(unsigned(hprekazka2_y) + 1);
						
						dratek1_y_reg <= std_logic_vector(to_unsigned(978,10)); --960+18=978
						dratek2_y_reg <= std_logic_vector(unsigned(dratek2_y) + 1);
					else
						hprekazka1_y_reg <= std_logic_vector(unsigned(hprekazka1_y) + 1);
						hprekazka2_y_reg <= std_logic_vector(unsigned(hprekazka2_y) + 1);
						
						dratek1_y_reg <= std_logic_vector(unsigned(dratek1_y) + 1);
						dratek2_y_reg <= std_logic_vector(unsigned(dratek2_y) + 1);
					end if;
					
					--random sampler
					if (unsigned(hprekazka1_y) = 200) then
						random2_reg <= rand;
					elsif (unsigned(hprekazka2_y) = 200 or (unsigned(hprekazka2_y) = 510 and unsigned(skore) = 0)) then 	
						random1_reg <= rand;
					end if;
				elsif game = "10" and game_over_clk = '1' then
					--mraky pri game over animation
					mracek_y_reg <= std_logic_vector(unsigned(mracek_y) - 1);
					mrak_y_reg <= std_logic_vector(unsigned(mrak_y) - 1);
					mrak2_y_reg <= std_logic_vector(unsigned(mrak2_y) - 1);
					mracek_2_y_reg <= std_logic_vector(unsigned(mracek_2_y) - 1);
					mrak_2_y_reg <= std_logic_vector(unsigned(mrak_2_y) - 1);
					mrak2_2_y_reg <= std_logic_vector(unsigned(mrak2_2_y) - 1);
				end if;
			end if;
		end if;
	end process;
	
	mracek_y <= mracek_y_reg;
	mrak_y <= mrak_y_reg;
	mrak2_y <= mrak2_y_reg;
	
	mracek_2_y <= mracek_2_y_reg;
	mrak_2_y <= mrak_2_y_reg;
	mrak2_2_y <= mrak2_2_y_reg;
	
	random_break1 <= random1_reg;
	random_break2 <= random2_reg;
	
	hprekazka1_y <= hprekazka1_y_reg;
	hprekazka2_y <= hprekazka2_y_reg;
	dratek1_y <= dratek1_y_reg;
	dratek2_y <= dratek2_y_reg;
	
	----------------------------------------
	--moove killer1
	----------------------------------------
	process (clk, counter_dratek) begin
		if rising_edge(clk) and dratek_clk = '1' then	
			if unsigned(counter_dratek) = 0 or unsigned(counter_dratek) = 3  then
				--decrease
				killer_x_reg <= std_logic_vector(to_unsigned(9,10));
				killer_y_reg <= std_logic_vector(to_unsigned(5,10));
			elsif unsigned(counter_dratek) = 1 or unsigned(counter_dratek) = 2 then
				--increase
				killer_x_reg <= std_logic_vector(to_unsigned(0,10));
				killer_y_reg <= std_logic_vector(to_unsigned(0,10));
			elsif unsigned(counter_dratek) = 4 or unsigned(counter_dratek) = 9 then
				--increase
				killer_x_reg <= std_logic_vector(to_unsigned(18,10));
				killer_y_reg <= std_logic_vector(to_unsigned(7,10));
			elsif unsigned(counter_dratek) = 5 or unsigned(counter_dratek) = 8 then
				--increase
				killer_x_reg <= std_logic_vector(to_unsigned(27,10));
				killer_y_reg <= std_logic_vector(to_unsigned(5,10));
			elsif unsigned(counter_dratek) = 6 or unsigned(counter_dratek) = 7 then
				--increase
				killer_x_reg <= std_logic_vector(to_unsigned(36,10));
				killer_y_reg <= std_logic_vector(to_unsigned(0,10));
			end if;
		end if;
	end process;
	killer_x_pos <= killer_x_reg ;
	killer_y_pos <= killer_y_reg;
	
	
	---------------------
	--technicka scale
	---------------------
	scale_helper1 <= std_logic_vector((unsigned(pixel_y(6 downto 0)) - unsigned(technika_y(6 downto 0)))/2);
	scale_helper2 <= std_logic_vector((unsigned(pixel_x(6 downto 0)) - unsigned(technika_x(6 downto 0)))/2);
	
	-----------------------------	
	--connection into database
	------------------------------
	database_1:rom_1
		port map (address_a => addr_rom1_a, address_b => addr_rom1_b, clk => clk, data_a => data_rom1_a, data_b => data_rom1_b);
	database_2:rom_2
		port map (address_a => addr_rom2_a, address_b => addr_rom2_b, clk => clk, data_a => data_rom2_a, data_b => data_rom2_b);
	database_3:rom_3
		port map (address_a => addr_rom3_a, address_b => addr_rom3_b, clk => clk, data_a => data_rom3_a, data_b => data_rom3_b);
	database_4:rom_4
		port map (address=> addr_rom4, clk => clk, data => data_rom4);

	---------------------------
	--adresy databazove - ziskavani aktualniho pixelu 4 bity alfa+R+G+B
	--adresa se sklada z <oznaceni_objektu><px_y><pix_x>
	---------------------------
	--16 bitove databaze
	addr_rom4 <= ('0' & jednotky & std_logic_vector(unsigned(pixel_y(3 downto 0)) - unsigned(jednotky_y(3 downto 0))) & (std_logic_vector(unsigned(pixel_x(3 downto 0)) - unsigned(jednotky_x(3 downto 0))))) 
						when (jednotky_on = '1')
						else
					('0' & desitky & std_logic_vector(unsigned(pixel_y(3 downto 0)) - unsigned(desitky_y(3 downto 0))) & (std_logic_vector(unsigned(pixel_x(3 downto 0)) - unsigned(desitky_x(3 downto 0))))) 
						when (desitky_on = '1')
						else
					('0' & stovky & std_logic_vector(unsigned(pixel_y(3 downto 0)) - unsigned(stovky_y(3 downto 0))) & (std_logic_vector(unsigned(pixel_x(3 downto 0)) - unsigned(stovky_x(3 downto 0))))) 
						when (stovky_on = '1') else
						
					--pismena
					--titulek xcopters
					("10111" & std_logic_vector(unsigned(pixel_y(3 downto 0)) - unsigned(tit_x_y(3 downto 0))) & (std_logic_vector(unsigned(pixel_x(3 downto 0)) - unsigned(tit_x_x(3 downto 0))))) 
						when (tit_x_on = '1') else
					("10000" & std_logic_vector(unsigned(pixel_y(3 downto 0)) - unsigned(tit_c_y(3 downto 0))) & (std_logic_vector(unsigned(pixel_x(3 downto 0)) - unsigned(tit_c_x(3 downto 0))))) 
											when (tit_c_on = '1') else
					("10110" & std_logic_vector(unsigned(pixel_y(3 downto 0)) - unsigned(tit_o_y(3 downto 0))) & (std_logic_vector(unsigned(pixel_x(3 downto 0)) - unsigned(tit_o_x(3 downto 0))))) 
											when (tit_o_on = '1') else
					("01111" & std_logic_vector(unsigned(pixel_y(3 downto 0)) - unsigned(tit_p_y(3 downto 0))) & (std_logic_vector(unsigned(pixel_x(3 downto 0)) - unsigned(tit_p_x(3 downto 0))))) 
											when (tit_p_on = '1') else
					("01100" & std_logic_vector(unsigned(pixel_y(3 downto 0)) - unsigned(tit_t_y(3 downto 0))) & (std_logic_vector(unsigned(pixel_x(3 downto 0)) - unsigned(tit_t_x(3 downto 0))))) 
											when (tit_t_on = '1') else
					("01011" & std_logic_vector(unsigned(pixel_y(3 downto 0)) - unsigned(tit_e_y(3 downto 0))) & (std_logic_vector(unsigned(pixel_x(3 downto 0)) - unsigned(tit_e_x(3 downto 0))))) 
											when (tit_e_on = '1') else
					("10100" & std_logic_vector(unsigned(pixel_y(3 downto 0)) - unsigned(tit_r_y(3 downto 0))) & (std_logic_vector(unsigned(pixel_x(3 downto 0)) - unsigned(tit_r_x(3 downto 0))))) 
											when (tit_r_on = '1') else
					("11000" & std_logic_vector(unsigned(pixel_y(3 downto 0)) - unsigned(tit_s_y(3 downto 0))) & (std_logic_vector(unsigned(pixel_x(3 downto 0)) - unsigned(tit_s_x(3 downto 0))))) 
											when (tit_s_on = '1') else
					--press	
					(std_logic_vector(to_unsigned(15,5)) & std_logic_vector(unsigned(pixel_y(3 downto 0)) - unsigned(press_p_y(3 downto 0))) & (std_logic_vector(unsigned(pixel_x(3 downto 0)) - unsigned(press_p_x(3 downto 0))))) 
											when (press_p_on = '1') else
					(std_logic_vector(to_unsigned(20,5)) & std_logic_vector(unsigned(pixel_y(3 downto 0)) - unsigned(press_r_y(3 downto 0))) & (std_logic_vector(unsigned(pixel_x(3 downto 0)) - unsigned(press_r_x(3 downto 0))))) 
											when (press_r_on = '1') else
					(std_logic_vector(to_unsigned(11,5)) & std_logic_vector(unsigned(pixel_y(3 downto 0)) - unsigned(press_e_y(3 downto 0))) & (std_logic_vector(unsigned(pixel_x(3 downto 0)) - unsigned(press_e_x(3 downto 0))))) 
											when (press_e_on = '1') else
					(std_logic_vector(to_unsigned(24,5)) & std_logic_vector(unsigned(pixel_y(3 downto 0)) - unsigned(press_s_y(3 downto 0))) & (std_logic_vector(unsigned(pixel_x(3 downto 0)) - unsigned(press_s_x(3 downto 0))))) 
											when (press_s_on = '1') else
					(std_logic_vector(to_unsigned(24,5)) & std_logic_vector(unsigned(pixel_y(3 downto 0)) - unsigned(press_s2_y(3 downto 0))) & (std_logic_vector(unsigned(pixel_x(3 downto 0)) - unsigned(press_s2_x(3 downto 0))))) 
											when (press_s2_on = '1') else
					(std_logic_vector(to_unsigned(25,5)) & std_logic_vector(unsigned(pixel_y(3 downto 0)) - unsigned(button_y(3 downto 0))) & (std_logic_vector(unsigned(pixel_x(3 downto 0)) - unsigned(button_x(3 downto 0))))) 
											when (button_on = '1') else
											
					 --others letters
					 --let_g
					(std_logic_vector(to_unsigned(18,5)) & std_logic_vector(unsigned(pixel_y(3 downto 0)) - unsigned(let_g_y(3 downto 0))) & (std_logic_vector(unsigned(pixel_x(3 downto 0)) - unsigned(let_g_x(3 downto 0))))) 
											when (let_g_on = '1') else
					--let_a
					(std_logic_vector(to_unsigned(19,5)) & std_logic_vector(unsigned(pixel_y(3 downto 0)) - unsigned(let_a_y(3 downto 0))) & (std_logic_vector(unsigned(pixel_x(3 downto 0)) - unsigned(let_a_x(3 downto 0))))) 
											when (let_a_on = '1') else
					--let_m
					(std_logic_vector(to_unsigned(21,5)) & std_logic_vector(unsigned(pixel_y(3 downto 0)) - unsigned(let_m_y(3 downto 0))) & (std_logic_vector(unsigned(pixel_x(3 downto 0)) - unsigned(let_m_x(3 downto 0))))) 
											when (let_m_on = '1') else
					--let_o
					(std_logic_vector(to_unsigned(22,5)) & std_logic_vector(unsigned(pixel_y(3 downto 0)) - unsigned(let_o_y(3 downto 0))) & (std_logic_vector(unsigned(pixel_x(3 downto 0)) - unsigned(let_o_x(3 downto 0))))) 
											when (let_o_on = '1') else
					--let_v
					(std_logic_vector(to_unsigned(13,5)) & std_logic_vector(unsigned(pixel_y(3 downto 0)) - unsigned(let_v_y(3 downto 0))) & (std_logic_vector(unsigned(pixel_x(3 downto 0)) - unsigned(let_v_x(3 downto 0))))) 
											when (let_v_on = '1') else
					--let_r
					(std_logic_vector(to_unsigned(20,5)) & std_logic_vector(unsigned(pixel_y(3 downto 0)) - unsigned(let_r_y(3 downto 0))) & (std_logic_vector(unsigned(pixel_x(3 downto 0)) - unsigned(let_r_x(3 downto 0))))) 
											when (let_r_on = '1')												
						else (others => '0');
						
	--32 bitove databaze
	addr_rom1_a <= ("000" & std_logic_vector(unsigned(pixel_y(4 downto 0)) - unsigned(panacek_y(4 downto 0))) & not(std_logic_vector(unsigned(pixel_x(4 downto 0)) - unsigned(panacek_x(4 downto 0))))) 
						  when (panacek_on = '1' and orientation = '0' and game /= "10")
						 else 
						  ("000" & std_logic_vector(unsigned(pixel_y(4 downto 0)) - unsigned(panacek_y(4 downto 0))) & (std_logic_vector(unsigned(pixel_x(4 downto 0)) - unsigned(panacek_x(4 downto 0))))) 
						  when (panacek_on = '1' and orientation = '1' and game /= "10")
						else
						--panacek v game over
						("111" & not (std_logic_vector(unsigned(pixel_y(4 downto 0)) - unsigned(panacek_y(4 downto 0)))) & not(std_logic_vector(unsigned(pixel_x(4 downto 0)) - unsigned(panacek_x(4 downto 0))))) 
						  when (panacek_on = '1' and orientation = '0' and game = "10")
						 else 
						  ("111" & not (std_logic_vector(unsigned(pixel_y(4 downto 0)) - unsigned(panacek_y(4 downto 0)))) & (std_logic_vector(unsigned(pixel_x(4 downto 0)) - unsigned(panacek_x(4 downto 0))))) 
						  when (panacek_on = '1' and orientation = '1' and game = "10")
						  
						 --vrtula
						 else
						  (std_logic_vector(unsigned(counter_vrtula) + 1) & std_logic_vector(unsigned(pixel_y(4 downto 0)) - unsigned(vrtula1_y(4 downto 0))) & not(std_logic_vector(unsigned(pixel_x(4 downto 0)) - unsigned(panacek_x(4 downto 0)) -16)))
						  when (vrtula1_on = '1' and game /= "10")
						else
						  (std_logic_vector(unsigned(counter_vrtula) + 1) & std_logic_vector(unsigned(pixel_y(4 downto 0)) - unsigned(vrtula2_y(4 downto 0))) & std_logic_vector(unsigned(pixel_x(4 downto 0)) - unsigned(panacek_x(4 downto 0)) +16)) 
						  when (vrtula2_on = '1' and game /= "10") 
						else (others => '0');

	addr_rom1_b <= ---drateeek
						"100" & std_logic_vector(unsigned(pixel_y(4 downto 0)) - unsigned(dratek1_y(4 downto 0))) & std_logic_vector(unsigned(pixel_x(4 downto 0)) - unsigned(dratek1_x(4 downto 0)))
						  when (dratek1_on = '1' and (unsigned(counter_dratek)= 0 or unsigned(counter_dratek)= 5)) else
						"101" & std_logic_vector(unsigned(pixel_y(4 downto 0)) - unsigned(dratek1_y(4 downto 0))) & std_logic_vector(unsigned(pixel_x(4 downto 0)) - unsigned(dratek1_x(4 downto 0)))
						  when (dratek1_on = '1' and (unsigned(counter_dratek)= 1 or unsigned(counter_dratek)= 4 )) else  
						"110" & std_logic_vector(unsigned(pixel_y(4 downto 0)) - unsigned(dratek1_y(4 downto 0))) & std_logic_vector(unsigned(pixel_x(4 downto 0)) - unsigned(dratek1_x(4 downto 0)))
						  when (dratek1_on = '1' and (unsigned(counter_dratek)= 2  or unsigned(counter_dratek)= 3)) else
						"101" & std_logic_vector(unsigned(pixel_y(4 downto 0)) - unsigned(dratek1_y(4 downto 0))) & not std_logic_vector(unsigned(pixel_x(4 downto 0)) - unsigned(dratek1_x(4 downto 0)))
						  when (dratek1_on = '1' and (unsigned(counter_dratek)= 6 or unsigned(counter_dratek)= 9)) else  
						"110" & std_logic_vector(unsigned(pixel_y(4 downto 0)) - unsigned(dratek1_y(4 downto 0))) & not std_logic_vector(unsigned(pixel_x(4 downto 0)) - unsigned(dratek1_x(4 downto 0)))
						  when (dratek1_on = '1' and (unsigned(counter_dratek)= 7 or unsigned(counter_dratek)= 8))
						else
						---drateeek2
						"100" & std_logic_vector(unsigned(pixel_y(4 downto 0)) - unsigned(dratek2_y(4 downto 0))) & std_logic_vector(unsigned(pixel_x(4 downto 0)) - unsigned(dratek2_x(4 downto 0)))
						  when (dratek2_on = '1' and (unsigned(counter_dratek)= 0 or unsigned(counter_dratek)= 5)) else
						"101" & std_logic_vector(unsigned(pixel_y(4 downto 0)) - unsigned(dratek2_y(4 downto 0))) & std_logic_vector(unsigned(pixel_x(4 downto 0)) - unsigned(dratek2_x(4 downto 0)))
						  when (dratek2_on = '1' and (unsigned(counter_dratek)= 1 or unsigned(counter_dratek)= 4 )) else  
						"110" & std_logic_vector(unsigned(pixel_y(4 downto 0)) - unsigned(dratek2_y(4 downto 0))) & std_logic_vector(unsigned(pixel_x(4 downto 0)) - unsigned(dratek2_x(4 downto 0)))
						  when (dratek2_on = '1' and (unsigned(counter_dratek)= 2  or unsigned(counter_dratek)= 3)) else
						"101" & std_logic_vector(unsigned(pixel_y(4 downto 0)) - unsigned(dratek2_y(4 downto 0))) & not std_logic_vector(unsigned(pixel_x(4 downto 0)) - unsigned(dratek2_x(4 downto 0)))
						  when (dratek2_on = '1' and (unsigned(counter_dratek)= 6 or unsigned(counter_dratek)= 9)) else  
						"110" & std_logic_vector(unsigned(pixel_y(4 downto 0)) - unsigned(dratek2_y(4 downto 0))) & not std_logic_vector(unsigned(pixel_x(4 downto 0)) - unsigned(dratek2_x(4 downto 0)))
						  when (dratek2_on = '1' and (unsigned(counter_dratek)= 7 or unsigned(counter_dratek)= 8))
						else (others => '0');
	

	addr_rom2_a <= --hprekazka
						("00" & std_logic_vector(unsigned(pixel_x(4 downto 0)) - unsigned(hprekazka1_x(4 downto 0)) +7) & std_logic_vector(unsigned(pixel_y(4 downto 0)) - unsigned(hprekazka1_y(4 downto 0)) +7)) 
						  when (hprekazka1_on = '1')		  
						else
						  ("00" & std_logic_vector(unsigned(pixel_x(4 downto 0)) - unsigned(hprekazka2_x(4 downto 0)) +7) & std_logic_vector(unsigned(pixel_y(4 downto 0)) - unsigned(hprekazka2_y(4 downto 0)) + 7)) 
						  when (hprekazka2_on = '1')
						else
						--killer1
						  ("01" & std_logic_vector(unsigned(pixel_y(4 downto 0)) - unsigned(killer_y_pos(4 downto 0)) -14 - unsigned(dratek1_y(4 downto 0))) & std_logic_vector(unsigned(pixel_x(4 downto 0)) - unsigned(killer_x_pos(4 downto 0)) +18 - unsigned(dratek1_x(4 downto 0)))) 
						  when (killer1_on = '1' and counter_killer = "00") else
						  ("10" & std_logic_vector(unsigned(pixel_y(4 downto 0)) - unsigned(killer_y_pos(4 downto 0)) -14  - unsigned(dratek1_y(4 downto 0))) & not std_logic_vector(unsigned(pixel_x(4 downto 0)) - unsigned(killer_x_pos(4 downto 0)) +18 - unsigned(dratek1_x(4 downto 0)))) 
						  when (killer1_on = '1' and counter_killer = "01") else
						--killer2
						  ("01" & std_logic_vector(unsigned(pixel_y(4 downto 0)) - unsigned(killer_y_pos(4 downto 0)) -14 - unsigned(dratek2_y(4 downto 0))) & std_logic_vector(unsigned(pixel_x(4 downto 0)) - unsigned(killer_x_pos(4 downto 0)) +18 - unsigned(dratek2_x(4 downto 0)))) 
						  when (killer2_on = '1' and counter_killer = "00") else
						  ("10" & std_logic_vector(unsigned(pixel_y(4 downto 0)) - unsigned(killer_y_pos(4 downto 0)) -14  - unsigned(dratek2_y(4 downto 0))) & not std_logic_vector(unsigned(pixel_x(4 downto 0)) - unsigned(killer_x_pos(4 downto 0)) +18 - unsigned(dratek2_x(4 downto 0)))) 
						  when (killer2_on = '1' and counter_killer = "01") 						
						  
						--vprekazka pri normalni hre
						else
						("00" & std_logic_vector(unsigned(pixel_y(4 downto 0)) - unsigned(vprekazka1_y(4 downto 0)) - unsigned(counter_game)) & std_logic_vector(unsigned(pixel_x(4 downto 0)) - unsigned(vprekazka1_x(4 downto 0)))) 
						  when (vprekazka1_on = '1' and game /= "10")		  
						else
						  ("00" & std_logic_vector(unsigned(pixel_y(4 downto 0)) - unsigned(vprekazka2_y(4 downto 0)) - unsigned(counter_game)) & std_logic_vector(unsigned(pixel_x(4 downto 0)) - unsigned(vprekazka2_x(4 downto 0)))) 
						  when (vprekazka2_on = '1' and game /= "10")
						--vprekazka pri narazeni - opacna rotace
						else
						("00" & std_logic_vector(unsigned(pixel_y(4 downto 0)) - unsigned(vprekazka1_y(4 downto 0)) + unsigned(counter_game_over)) & std_logic_vector(unsigned(pixel_x(4 downto 0)) - unsigned(vprekazka1_x(4 downto 0)))) 
						  when (vprekazka1_on = '1' and game = "10")		  
						else
						  ("00" & std_logic_vector(unsigned(pixel_y(4 downto 0)) - unsigned(vprekazka2_y(4 downto 0)) + unsigned(counter_game_over)) & std_logic_vector(unsigned(pixel_x(4 downto 0)) - unsigned(vprekazka2_x(4 downto 0)))) 
						  when (vprekazka2_on = '1' and game = "10")
						else (others => '0');			  
						
	addr_rom2_b <= "11" & std_logic_vector(unsigned(pixel_y(4 downto 0)) - unsigned(mracek_y(4 downto 0))) & std_logic_vector(unsigned(pixel_x(4 downto 0)) - unsigned( mracek_x(4 downto 0)))
						  when (mracek_on = '1') --to je mrak
						else
						"11" & std_logic_vector(unsigned(pixel_y(4 downto 0)) - unsigned(mracek_2_y(4 downto 0))) & std_logic_vector(unsigned(pixel_x(4 downto 0)) - unsigned( mracek_2_x(4 downto 0)))
						  when (mracek_2_on = '1') --to je mrak
						else (others => '0');

	--64bitove aka databaze 3
	addr_rom3_a <= "00" & std_logic_vector(unsigned(pixel_y(5 downto 0)) - unsigned(strom_y(5 downto 0))) & std_logic_vector(unsigned(pixel_x(5 downto 0)) - unsigned(strom_x(5 downto 0)))
						  when (strom_on = '1')
						else
						  "01" & std_logic_vector(unsigned(pixel_y(5 downto 0)) - unsigned(mrak_y(5 downto 0))) & std_logic_vector(unsigned(pixel_x(5 downto 0)) - unsigned(mrak_x(5 downto 0)))
						  when (mrak_on = '1')
						else
						  "01" & std_logic_vector(unsigned(pixel_y(5 downto 0)) - unsigned(mrak2_y(5 downto 0))) & std_logic_vector(unsigned(pixel_x(5 downto 0)) - unsigned(mrak2_x(5 downto 0)))
						  when (mrak2_on = '1' and unsigned(mrak2_y) >= 0 )  
						else
						  "01" & std_logic_vector(unsigned(pixel_y(5 downto 0)) - unsigned(mrak_2_y(5 downto 0))) & std_logic_vector(unsigned(pixel_x(5 downto 0)) - unsigned(mrak_2_x(5 downto 0)))
						  when (mrak_2_on = '1')
						else
						  "01" & std_logic_vector(unsigned(pixel_y(5 downto 0)) - unsigned(mrak2_2_y(5 downto 0))) & std_logic_vector(unsigned(pixel_x(5 downto 0)) - unsigned(mrak2_2_x(5 downto 0)))
						  when (mrak2_2_on = '1' and unsigned(mrak2_2_y) >= 0 )    
						else (others => '0');

	addr_rom3_b <= "10" & scale_helper1(5 downto 0) & scale_helper2(5 downto 0)
						  when (technika_on = '1') else (others => '0');
	
	
	-----------------
	--showing data and prednosti :D
	-----------------
	db_data_reg <= data_rom4 when (data_rom4(3) = '0' and (jednotky_on = '1' or desitky_on = '1' or stovky_on = '1')) else
						data_rom4 when (data_rom4(3) = '0' and (tit_x_on = '1' or tit_c_on = '1' or tit_o_on = '1' or tit_p_on = '1' or tit_t_on = '1' or tit_e_on = '1' or tit_r_on = '1' or tit_s_on = '1')) else
						data_rom4 when (data_rom4(3) = '0' and (press_p_on = '1' or press_r_on = '1' or press_e_on = '1' or press_s_on = '1' or press_s2_on = '1' or button_on = '1')) else
						data_rom4 when (data_rom4(3) = '0' and (let_g_on = '1' or let_a_on = '1' or let_m_on = '1' or let_o_on = '1' or let_v_on = '1' or let_r_on = '1')) else
						data_rom1_a when (data_rom1_a(3) = '0' and panacek_on = '1') else
						data_rom1_a  when (data_rom1_a(3) = '0' and vrtula1_on = '1') else
						data_rom1_a  when (data_rom1_a(3) = '0' and vrtula2_on = '1') else
						data_rom2_a  when (data_rom2_a(3) = '0' and killer1_on = '1') else
						data_rom2_a  when (data_rom2_a(3) = '0' and killer2_on = '1') else
						data_rom1_b  when (data_rom1_b(3) = '0' and dratek1_on = '1') else
						data_rom1_b  when (data_rom1_b(3) = '0' and dratek2_on = '1') else
						data_rom2_a  when (data_rom2_a(3) = '0' and hprekazka1_on = '1') else
						data_rom2_a  when (data_rom2_a(3) = '0' and hprekazka2_on = '1') else
						data_rom2_a  when (data_rom2_a(3) = '0' and vprekazka1_on = '1') else
						data_rom2_a  when (data_rom2_a(3) = '0' and vprekazka2_on = '1') else
						data_rom3_a  when (data_rom3_a(3) = '0' and strom_on = '1') else
						data_rom3_b  when (data_rom3_b(3) = '0' and technika_on = '1') else
						data_rom2_b  when (data_rom2_b(3) = '0' and (mracek_on = '1' or mracek_2_on = '1')) else --mracek is the last one
						data_rom3_a  when (data_rom3_a(3) = '0' and (mrak_on = '1' or mrak2_on = '1' or mrak_2_on = '1' or mrak2_2_on = '1')) else --mrak is the last one
						"0011"; --jinak pozadi !!!
	
	--------------------------
	--signals if object is on - kterej objekt ma byt zapnutek v tehle chvili podle pixel_x a pixel_y
	--------------------------
	--16 bitove
	jednotky_on <= '1' when game  /= "00" and (unsigned(jednotky_x) <= unsigned(pixel_x)) and ((unsigned(jednotky_x) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_x)) and 
								  (unsigned(jednotky_y) <= unsigned(pixel_y)) and ((unsigned(jednotky_y) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_y)) else '0';
	desitky_on <= '1' when game  /= "00" and (unsigned(desitky_x) <= unsigned(pixel_x)) and ((unsigned(desitky_x) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_x)) and 
								  (unsigned(desitky_y) <= unsigned(pixel_y)) and ((unsigned(desitky_y) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_y)) else '0';
	stovky_on <= '1' when game  /= "00" and (unsigned(stovky_x) <= unsigned(pixel_x)) and ((unsigned(stovky_x) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_x)) and 
								  (unsigned(stovky_y) <= unsigned(pixel_y)) and ((unsigned(stovky_y) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_y)) else '0';
	
	--xcopters on
	tit_x_on <= '1' when (unsigned(tit_x_x) <= unsigned(pixel_x)) and ((unsigned(tit_x_x) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_x)) and 
								  (unsigned(tit_x_y) <= unsigned(pixel_y)) and ((unsigned(tit_x_y) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_y)) else '0';
	tit_c_on <= '1' when (unsigned(tit_c_x) <= unsigned(pixel_x)) and ((unsigned(tit_c_x) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_x)) and 
								  (unsigned(tit_c_y) <= unsigned(pixel_y)) and ((unsigned(tit_c_y) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_y)) else '0';
	tit_o_on <= '1' when (unsigned(tit_o_x) <= unsigned(pixel_x)) and ((unsigned(tit_o_x) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_x)) and 
								  (unsigned(tit_o_y) <= unsigned(pixel_y)) and ((unsigned(tit_o_y) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_y)) else '0';
	tit_p_on <= '1' when (unsigned(tit_p_x) <= unsigned(pixel_x)) and ((unsigned(tit_p_x) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_x)) and 
								  (unsigned(tit_p_y) <= unsigned(pixel_y)) and ((unsigned(tit_p_y) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_y)) else '0';
	tit_t_on <= '1' when (unsigned(tit_t_x) <= unsigned(pixel_x)) and ((unsigned(tit_t_x) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_x)) and 
								  (unsigned(tit_t_y) <= unsigned(pixel_y)) and ((unsigned(tit_t_y) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_y)) else '0';
	tit_e_on <= '1' when (unsigned(tit_e_x) <= unsigned(pixel_x)) and ((unsigned(tit_e_x) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_x)) and 
								  (unsigned(tit_e_y) <= unsigned(pixel_y)) and ((unsigned(tit_e_y) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_y)) else '0';
	tit_r_on <= '1' when (unsigned(tit_r_x) <= unsigned(pixel_x)) and ((unsigned(tit_r_x) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_x)) and 
								  (unsigned(tit_r_y) <= unsigned(pixel_y)) and ((unsigned(tit_r_y) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_y)) else '0';
	tit_s_on <= '1' when (unsigned(tit_s_x) <= unsigned(pixel_x)) and ((unsigned(tit_s_x) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_x)) and 
								  (unsigned(tit_s_y) <= unsigned(pixel_y)) and ((unsigned(tit_s_y) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_y)) else '0';
	
	--press and button
	press_p_on <= '1' when (game = "00" or game = "10") and (unsigned(press_p_x) <= unsigned(pixel_x)) and ((unsigned(press_p_x) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_x)) and 
								  (unsigned(press_p_y) <= unsigned(pixel_y)) and ((unsigned(press_p_y) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_y)) else '0';
	press_r_on <= '1' when (game = "00" or game = "10") and (unsigned(press_r_x) <= unsigned(pixel_x)) and ((unsigned(press_r_x) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_x)) and 
								  (unsigned(press_r_y) <= unsigned(pixel_y)) and ((unsigned(press_r_y) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_y)) else '0';
	press_e_on <= '1' when (game = "00" or game = "10") and 
									--e je jeste pouzite v over je posunuta o 4 pozice do leva + 4*18=72 - 16 = 56
									--e se jeste pouziva v game over, je akorat v jine vysce
									(
										(
											((unsigned(press_e_x) + to_unsigned(64, 10) <= unsigned(pixel_x)) and ((unsigned(press_e_x) + to_unsigned(ROM16_SIZE,10) + to_unsigned(64, 10) ) > unsigned(pixel_x))) 
											and
											((unsigned(press_e_y) - to_unsigned(96, 10) <= unsigned(pixel_y)) and ((unsigned(press_e_y) - to_unsigned(96, 10) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_y)))
											and game = "10"
										)or
										(
											((unsigned(press_e_x) <= unsigned(pixel_x)) and ((unsigned(press_e_x) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_x))) 
											and
											(
												((unsigned(press_e_y) <= unsigned(pixel_y)) and ((unsigned(press_e_y) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_y))) 
												or
												((unsigned(press_e_y) - to_unsigned(96, 10) <= unsigned(pixel_y)) and ((unsigned(press_e_y) - to_unsigned(96, 10) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_y)) and game = "10")
											)
										)
									)
									
								  
								  else '0';
	
	
	press_s_on <= '1' when (game = "00" or game = "10") and (unsigned(press_s_x) <= unsigned(pixel_x)) and ((unsigned(press_s_x) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_x)) and 
								  (unsigned(press_s_y) <= unsigned(pixel_y)) and ((unsigned(press_s_y) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_y)) else '0';
	press_s2_on <= '1' when (game = "00" or game = "10") and (unsigned(press_s2_x) <= unsigned(pixel_x)) and ((unsigned(press_s2_x) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_x)) and 
								  (unsigned(press_s2_y) <= unsigned(pixel_y)) and ((unsigned(press_s2_y) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_y)) else '0';
	button_on <= '1' when (game = "00" or game = "10") and (unsigned(button_x) <= unsigned(pixel_x)) and ((unsigned(button_x) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_x)) and 
								  (unsigned(button_y) <= unsigned(pixel_y)) and ((unsigned(button_y) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_y)) else '0';
	
	--others letters
	let_g_on <= '1' when game = "10" and (unsigned(let_g_x) <= unsigned(pixel_x)) and ((unsigned(let_g_x) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_x)) and 
								  (unsigned(let_g_y) <= unsigned(pixel_y)) and ((unsigned(let_g_y) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_y)) else '0';
	let_a_on <= '1' when game = "10" and (unsigned(let_a_x) <= unsigned(pixel_x)) and ((unsigned(let_a_x) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_x)) and 
									  (unsigned(let_a_y) <= unsigned(pixel_y)) and ((unsigned(let_a_y) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_y)) else '0';
	let_m_on <= '1' when game = "10" and (unsigned(let_m_x) <= unsigned(pixel_x)) and ((unsigned(let_m_x) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_x)) and 
									  (unsigned(let_m_y) <= unsigned(pixel_y)) and ((unsigned(let_m_y) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_y)) else '0';
	let_o_on <= '1' when game = "10" and (unsigned(let_o_x) <= unsigned(pixel_x)) and ((unsigned(let_o_x) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_x)) and 
									  (unsigned(let_o_y) <= unsigned(pixel_y)) and ((unsigned(let_o_y) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_y)) else '0';
	let_v_on <= '1' when game = "10" and (unsigned(let_v_x) <= unsigned(pixel_x)) and ((unsigned(let_v_x) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_x)) and 
									  (unsigned(let_v_y) <= unsigned(pixel_y)) and ((unsigned(let_v_y) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_y)) else '0';
	let_r_on <= '1' when game = "10" and (unsigned(let_r_x) <= unsigned(pixel_x)) and ((unsigned(let_r_x) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_x)) and 
									  (unsigned(let_r_y) <= unsigned(pixel_y)) and ((unsigned(let_r_y) + to_unsigned(ROM16_SIZE,10) ) > unsigned(pixel_y)) else '0';
	---32 bitove
	panacek_on <= '1' when (unsigned(panacek_x) <= unsigned(pixel_x)) and ((unsigned(panacek_x) + to_unsigned(ROM32_SIZE,10) ) > unsigned(pixel_x)) and 
								  (unsigned(panacek_y) <= unsigned(pixel_y)) and ((unsigned(panacek_y) + to_unsigned(ROM32_SIZE,10) ) > unsigned(pixel_y)) else '0';
	vrtula2_on <= '1' when (unsigned(panacek_x) -16 <= unsigned(pixel_x)) and ((unsigned(panacek_x) -16 + to_unsigned(ROM32_SIZE,10) ) > unsigned(pixel_x)) and 
								  (unsigned(vrtula2_y) <= unsigned(pixel_y)) and ((unsigned(vrtula2_y) + to_unsigned(ROM32_SIZE,10) ) > unsigned(pixel_y)) else '0';
	vrtula1_on <= '1' when (unsigned(panacek_x) +16 <= unsigned(pixel_x)) and ((unsigned(panacek_x) +16 + to_unsigned(ROM32_SIZE,10) ) > unsigned(pixel_x)) and 
								  (unsigned(vrtula1_y) <= unsigned(pixel_y)) and ((unsigned(vrtula1_y) + to_unsigned(ROM32_SIZE,10) ) > unsigned(pixel_y)) else '0';
	
	--hprekazka zobrazeni podle nejake logiky
	--57 je pocatecni x pozice a 135 je sirka te dury
	hprekazka1_on <= '1' when (game  /= "00" and game /= "10") and (
										((57 <= unsigned(pixel_x)) and ((57 + (unsigned(random_break1) * to_unsigned(ROM32_SIZE,10)) ) >= unsigned(pixel_x))) or
										(( ((2 + unsigned(random_break1)) * to_unsigned(ROM32_SIZE,10) +137)<= unsigned(pixel_x)) and (  585 >= unsigned(pixel_x)))
									  ) and
								  ((unsigned(hprekazka1_y) <= unsigned(pixel_y)) or (unsigned(hprekazka1_help) <= 18)) and ((unsigned(hprekazka1_y) + 18 ) > unsigned(pixel_y)) else '0';

	hprekazka2_on <= '1' when  (game  /= "00" and game /= "10") and (
										((57 <= unsigned(pixel_x)) and ((57 + (unsigned(random_break2) * to_unsigned(ROM32_SIZE,10)) ) >= unsigned(pixel_x))) or
										(( ((2 + unsigned(random_break2)) * to_unsigned(ROM32_SIZE,10) + 137)<= unsigned(pixel_x)) and (  585 >= unsigned(pixel_x)))
									  ) and
								  ((unsigned(hprekazka2_y) <= unsigned(pixel_y)) or (unsigned(hprekazka2_help) <= 18)) and ((unsigned(hprekazka2_y) + 18 ) > unsigned(pixel_y)) else '0';
		
	vprekazka1_on <= '1' when (unsigned(vprekazka1_x) <= unsigned(pixel_x)) and ((unsigned(vprekazka1_x) + to_unsigned(ROM32_SIZE,10) ) >= unsigned(pixel_x)) else '0';
	vprekazka2_on <= '1' when (unsigned(vprekazka2_x) <= unsigned(pixel_x)) and ((unsigned(vprekazka2_x) + to_unsigned(ROM32_SIZE,10) ) >= unsigned(pixel_x)) else '0';
	mracek_on <= '1' when (unsigned(mracek_x) <= unsigned(pixel_x)) and ((unsigned(mracek_x) + to_unsigned(ROM32_SIZE,10) ) > unsigned(pixel_x)) and 
								  ((unsigned(mracek_y) <= unsigned(pixel_y)) or (unsigned(mracek_help) <= to_unsigned(ROM32_SIZE,10))) and ((unsigned(mracek_y) + to_unsigned(ROM32_SIZE,10) ) > unsigned(pixel_y)) else '0';
	mracek_2_on <= '1' when (unsigned(mracek_2_x) <= unsigned(pixel_x)) and ((unsigned(mracek_2_x) + to_unsigned(ROM32_SIZE,10) ) > unsigned(pixel_x)) and 
								  ((unsigned(mracek_2_y) <= unsigned(pixel_y)) or (unsigned(mracek_2_help) <= to_unsigned(ROM32_SIZE,10))) and ((unsigned(mracek_2_y) + to_unsigned(ROM32_SIZE,10) ) > unsigned(pixel_y)) else '0';
	
	--dratek na vsechny ty behajici srance respektive ty behajici srance
	dratek1_on <= '1' when (game  /= "00" and game /= "10") and ((
									((((unsigned(random_break1)+1) * to_unsigned(ROM32_SIZE,10)) ) <= unsigned(pixel_x)) and
									((((unsigned(random_break1)+1) * to_unsigned(ROM32_SIZE,10)) + to_unsigned(ROM32_SIZE,10) ) > unsigned(pixel_x))
								  ) or 
								  (
								   (((unsigned(random_break1) + 1) * to_unsigned(ROM32_SIZE,10) +160) <= unsigned(pixel_x)) and
									((((unsigned(random_break1) + 1) * to_unsigned(ROM32_SIZE,10) +160) + to_unsigned(ROM32_SIZE,10)) > unsigned(pixel_x))
								  ))and 
									((unsigned(dratek1_y) <= unsigned(pixel_y)) or (unsigned(dratek1_help) <= to_unsigned(ROM32_SIZE,10))) and (unsigned(dratek1_y) + to_unsigned(ROM32_SIZE,10) ) > unsigned(pixel_y)
								  else '0';
	
	killer1_on <= '1' when (game  /= "00" and game /= "10") and ((
									( ((unsigned(random_break1)+1) * to_unsigned(ROM32_SIZE,10)) + unsigned(killer_x_pos) -18 <= unsigned(pixel_x)) and
									(( ((unsigned(random_break1)+1) * to_unsigned(ROM32_SIZE,10)) + unsigned(killer_x_pos) -18 + to_unsigned(ROM32_SIZE,10) ) > unsigned(pixel_x))
								  ) or 
								  (
								   (((unsigned(random_break1)+1) * to_unsigned(ROM32_SIZE,10) +160) + unsigned(killer_x_pos) -18 <= unsigned(pixel_x)) and
									(((unsigned(random_break1)+1) * to_unsigned(ROM32_SIZE,10) +160) + unsigned(killer_x_pos) -18 + to_unsigned(ROM32_SIZE,10) > unsigned(pixel_x))
								  ))and 
									(( unsigned(dratek1_y) + unsigned(killer_y_pos) +14 <= unsigned(pixel_y)) or (unsigned(killer1_help) <= to_unsigned(ROM32_SIZE,10))) and ( unsigned(dratek1_y) + unsigned(killer_y_pos) + to_unsigned(ROM32_SIZE,10) ) +14 > unsigned(pixel_y)
								  else '0';
								  
	killer2_on <= '1' when (game  /= "00" and game /= "10") and ((
									( ((unsigned(random_break2)+1) * to_unsigned(ROM32_SIZE,10)) + unsigned(killer_x_pos) -18 <= unsigned(pixel_x)) and
									(( ((unsigned(random_break2)+1) * to_unsigned(ROM32_SIZE,10)) + unsigned(killer_x_pos) -18 + to_unsigned(ROM32_SIZE,10) ) > unsigned(pixel_x))
								  ) or 
								  (
								   (((unsigned(random_break2)+1) * to_unsigned(ROM32_SIZE,10) + 160) + unsigned(killer_x_pos) -18 <= unsigned(pixel_x)) and
									(((unsigned(random_break2)+1) * to_unsigned(ROM32_SIZE,10) + 160) + unsigned(killer_x_pos) -18 + to_unsigned(ROM32_SIZE,10) > unsigned(pixel_x))
								  ))and 
									(( unsigned(dratek2_y) + unsigned(killer_y_pos) +14 <= unsigned(pixel_y)) or (unsigned(killer2_help) <= to_unsigned(ROM32_SIZE,10))) and ( unsigned(dratek2_y) + unsigned(killer_y_pos) + to_unsigned(ROM32_SIZE,10) ) +14 > unsigned(pixel_y)
								  else '0';

	dratek2_on <= '1' when (game  /= "00" and game /= "10") and ((
									((((unsigned(random_break2)+1) * to_unsigned(ROM32_SIZE,10)) ) <= unsigned(pixel_x)) and
									((((unsigned(random_break2)+1) * to_unsigned(ROM32_SIZE,10)) + to_unsigned(ROM32_SIZE,10) ) > unsigned(pixel_x))
								  ) or 
								  (
								   (((unsigned(random_break2) + 1) * to_unsigned(ROM32_SIZE,10) +160) <= unsigned(pixel_x)) and
									((((unsigned(random_break2) + 1) * to_unsigned(ROM32_SIZE,10) +160) + to_unsigned(ROM32_SIZE,10)) > unsigned(pixel_x))
								  ))and 
									((unsigned(dratek2_y) <= unsigned(pixel_y)) or (unsigned(dratek2_help) <= to_unsigned(ROM32_SIZE,10))) and (unsigned(dratek2_y) + to_unsigned(ROM32_SIZE,10) ) > unsigned(pixel_y)
								  else '0';
	
	--64bitove
	strom_on <= '1' when  
								  (unsigned(strom_y) <= unsigned(pixel_y)) and ((unsigned(strom_y) + to_unsigned(ROM64_SIZE,10)) > unsigned(pixel_y)) else '0';
	mrak_on <= '1' when  (unsigned(mrak_x) <= unsigned(pixel_x)) and ((unsigned(mrak_x) + to_unsigned(ROM64_SIZE,10)) > unsigned(pixel_x)) and 
								  ((unsigned(mrak_y) <= unsigned(pixel_y)) or (unsigned(mrak1_help) <= to_unsigned(ROM64_SIZE,10))) and ((unsigned(mrak_y) + to_unsigned(ROM64_SIZE,10) ) >= unsigned(pixel_y)) else '0';
	mrak2_on <= '1' when  (unsigned(mrak2_x) <= unsigned(pixel_x)) and ((unsigned(mrak2_x) + to_unsigned(ROM64_SIZE,10)) > unsigned(pixel_x)) and 
								  ((unsigned(mrak2_y) <= unsigned(pixel_y)) or (unsigned(mrak2_help) <= to_unsigned(ROM64_SIZE,10))) and ((unsigned(mrak2_y) + to_unsigned(ROM64_SIZE,10) ) >= unsigned(pixel_y)) else '0';
	
	mrak_2_on <= '1' when  (unsigned(mrak_2_x) <= unsigned(pixel_x)) and ((unsigned(mrak_2_x) + to_unsigned(ROM64_SIZE,10)) > unsigned(pixel_x)) and 
								  ((unsigned(mrak_2_y) <= unsigned(pixel_y)) or (unsigned(mrak1_2_help) <= to_unsigned(ROM64_SIZE,10))) and ((unsigned(mrak_2_y) + to_unsigned(ROM64_SIZE,10) ) >= unsigned(pixel_y)) else '0';
	mrak2_2_on <= '1' when (game  /= "00" and (skore /= "000000000000" or game = "10")) and (unsigned(mrak2_2_x) <= unsigned(pixel_x)) and ((unsigned(mrak2_2_x) + to_unsigned(ROM64_SIZE,10)) > unsigned(pixel_x)) and 
								  ((unsigned(mrak2_2_y) <= unsigned(pixel_y)) or (unsigned(mrak2_2_help) <= to_unsigned(ROM64_SIZE,10))) and ((unsigned(mrak2_2_y) + to_unsigned(ROM64_SIZE,10) ) >= unsigned(pixel_y)) else '0';
	
	
	
	technika_on <= '1' when game /= "10" and (unsigned(technika_x) <= unsigned(pixel_x)) and  ((unsigned(technika_x) + (2 * to_unsigned(ROM64_SIZE,10)) ) > unsigned(pixel_x)) and 
								  (unsigned(technika_y) <= unsigned(pixel_y)) and   ((unsigned(technika_y) + (2 * to_unsigned(ROM64_SIZE,10)) ) >= unsigned(pixel_y)) else '0';
	
	
	
	-----------------
	--helpery pro zobrazovani objektu nad obrazovkou, jen pro ty co se pohybujou smerem dolu - jen pro bjekty ktere sepohybuji v ose Y
	-----------------
	mracek_help <= std_logic_vector(to_unsigned(1024,10) - unsigned(mracek_y));
	mrak1_help <= std_logic_vector(to_unsigned(1024,10) - unsigned(mrak_y));
	mrak2_help <= std_logic_vector(to_unsigned(1024,10) - unsigned(mrak2_y));
	mracek_2_help <= std_logic_vector(to_unsigned(1024,10) - unsigned(mracek_2_y));
	mrak1_2_help <= std_logic_vector(to_unsigned(1024,10) - unsigned(mrak_2_y));
	mrak2_2_help <= std_logic_vector(to_unsigned(1024,10) - unsigned(mrak2_2_y));
	killer1_help <= std_logic_vector(to_unsigned(1024,10) - (unsigned(dratek1_y) + unsigned(killer_y_pos) +14));
	killer2_help <= std_logic_vector(to_unsigned(1024,10) - (unsigned(dratek2_y) + unsigned(killer_y_pos) +14));
	dratek1_help <= std_logic_vector(to_unsigned(1024,10) - unsigned(dratek1_y));
	dratek2_help <= std_logic_vector(to_unsigned(1024,10) - unsigned(dratek2_y));
	hprekazka1_help <= std_logic_vector(to_unsigned(1024,10) - unsigned(hprekazka1_y));
	hprekazka2_help <= std_logic_vector(to_unsigned(1024,10) - unsigned(hprekazka2_y));


	
	
	
	-----------------
	--set out data to VGA - konecne se dostavame ven z FPGA na monitor
	-----------------
	process (clk, video_on, pixel_x, pixel_y, tit_x_on, tit_c_on, tit_o_on, tit_p_on, tit_t_on, tit_e_on, tit_r_on, tit_s_on, data_rom4) begin
		if rising_edge(clk) then
			if video_on = '1' then
				--play array
				if unsigned(pixel_x) <= 64 or unsigned(pixel_x) >= 585 then
					rgb_out_reg <= "000";	--plati tu posledni prirazeni takze to je ok
					if tit_x_on = '1' or tit_c_on = '1' or tit_o_on = '1' or tit_p_on = '1' or tit_t_on = '1' or tit_e_on = '1' or tit_r_on = '1' or tit_s_on = '1' then
						if data_rom4(3) = '0' then
							rgb_out_reg <= db_data_reg(2 downto 0);
						end if;
					end if;
				else
					rgb_out_reg <= db_data_reg(2 downto 0);
				end if;
			else
				rgb_out_reg <= "000";
			end if;
		end if;
	end process;

	--set outputs
	rgb <= rgb_out_reg;
	hsync <= hsync_reg;
	vsync <= vsync_reg;

end Behavioral;
