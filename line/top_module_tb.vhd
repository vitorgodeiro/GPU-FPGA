library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_module_tb is
end top_module_tb;

architecture top_module_tb of top_module_tb is
	signal clock_50 : std_logic;
	signal key      : std_logic_vector(2 downto 0);
	signal sw       : std_logic_vector(9 downto 0);
	signal vga_hs   : std_logic;
	signal vga_vs   : std_logic;
	signal vga_r    : std_logic_vector(3 downto 0);
	signal vga_g    : std_logic_vector(3 downto 0);
	signal vga_b    : std_logic_vector(3 downto 0);
begin
	dut : entity work.top_module
	port map (clock_50, key, sw, vga_hs, vga_vs, vga_r, vga_g, vga_b);

	process
	begin
		clock_50 <= '0';
		wait for 10 ns;
		clock_50 <= '1';
		wait for 10 ns;
	end process;	

	process
	begin
		sw(9) <= '1';
		key(2) <= '0';
		wait until clock_50'event and clock_50 = '1';

		sw(9) <= '0';
		wait until clock_50'event and clock_50 = '1';

		key(2) <= '1';
		wait until clock_50'event and clock_50 = '1';

		key(2) <= '0';
		wait until clock_50'event and clock_50 = '1';

		wait;
	end process;
	
end top_module_tb;
