library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
------------------------------------------
entity top_module is
	port (
		clock_50 : in std_logic;
		key      : in std_logic_vector(2 downto 0);
		sw       : in std_logic_vector(9 downto 0);
		vga_hs   : out std_logic;
		vga_vs   : out std_logic;
		vga_r    : out std_logic_vector(3 downto 0);
		vga_g    : out std_logic_vector(3 downto 0);
		vga_b    : out std_logic_vector(3 downto 0)
	);
end top_module;
------------------------------------------

architecture top_module of top_module is
	signal start : std_logic;
	signal nkey  : std_logic_vector(2 downto 0);
begin
	nkey <= not key;

    c3 : entity work.button
    generic map (2500000)
    port map (clock_50, sw(9), nkey(2), start);
	 
	gpu_c : entity work.gpu
	port map (
		clock => clock_50,
		reset => sw(9),
		start => start,
		
		proc_wren => '0',
		proc_addr => "0000000",
		proc_data_i => x"0000",
		proc_data_o => open,

		hs => vga_hs,
		vs => vga_vs,
		r => vga_r,
		g => vga_g,
		b => vga_b
	);
	
	
end top_module;
