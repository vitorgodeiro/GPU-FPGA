library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
------------------------------------------
entity GPU is
	port (
		reset : in std_logic;
		clock : in std_logic;
		start : in std_logic;
		HS : out std_logic;
		VS : out std_logic;
		R  : out std_logic_vector(3 downto 0);
		G  : out std_logic_vector(3 downto 0);
		B  : out std_logic_vector(3 downto 0)
	);
end GPU;
------------------------------------------
architecture GPU of GPU is
	signal height : unsigned(19 downto 0);
	signal widthh  : unsigned(10 downto 0);
	signal hs_temp : std_logic;
	signal vs_temp : std_logic;
	signal video_on_temp : std_logic;
	signal pixel : std_logic_vector(11 downto 0);
	signal vga_addr : std_logic_vector(13 downto 0);
	signal line_wren : std_logic;
	signal line_addr : std_logic_vector(13 downto 0);
	signal line_pixel : std_logic_vector(11 downto 0);
	signal line_x0 : std_logic_vector(6 downto 0);
	signal line_x1 : std_logic_vector(6 downto 0);
	signal line_y0 : std_logic_vector(6 downto 0);
	signal line_y1 : std_logic_vector(6 downto 0);
	
begin
	HS <= hs_temp;
	VS <= vs_temp;
	video_on_temp <= '1' when (widthh >= 336 and widthh <= 463) and (height >= 245440 and height < 378560) else '0'; -- (erro) area visivel
--	R <= "1111"; --pixel(11 downto 8);
--	G <= "1111"; --pixel(7 downto 4);
--	B <= "1111"; --pixel(3 downto 0);
	
	R <= pixel(11 downto	8);
	G <= pixel(7 downto 4);
	B <= pixel(3 downto 0);
	
    framebuffer : entity work.dual_memory_bram
    generic map (
        DATA_width => 12,
        ADDR_width => 14 
    )
    port map (
        a_clock  => clock,
        a_wren   => '0',
        a_addr   => vga_addr,
        a_data_i => "000000000000",
        a_data_o => pixel,

        b_clock  => clock,
        b_wren   => line_wren,
        b_addr   => line_addr,
        b_data_i => "111111111111",
        b_data_o => open
    );
	 
	 line_x0 <= "0001010";
	 line_y0 <= "0001010";
	 line_x1 <= "0010100";
	 line_y1 <= "0001010";
	 
	line_c : entity work.Line_alg
	port map (
		clock => clock,
		reset => reset,
		start => start,
		x0_param => line_x0,
		x1_param => line_x1,
		y0_param => line_y0,
		y1_param => line_y1,
		p_param => line_pixel,
		addr => line_addr,
		wren => line_wren,
		estado => open
	);

	process ( height, widthh, clock )
	begin
		if reset='1' then
			height <= "00000000000000000000";
			widthh <= "00000000000";
			vga_addr <= (others => '0');
		elsif clock='1' and clock'event then
			if height < 692639 then
				height <= height + 1;
			else
				height <= "00000000000000000000";
			end if;
			
			if widthh < 1039 then
				widthh <= widthh + 1;
			else
				widthh <= "00000000000";
			end if;
			--------------------------------------------------
			
			if widthh >= 856 and widthh <= 975 then
				hs_temp <= '1';
			else
				hs_temp <= '0';
			end if;
			
			if height >= 662480 and height <= 668719  then
				vs_temp <= '1';
			else
				vs_temp <= '0';
			end if;
			
			if video_on_temp = '1' then
				vga_addr <= std_logic_vector(unsigned(vga_addr) + 1);
			end if;
		end if;
	end process;
end GPU;
