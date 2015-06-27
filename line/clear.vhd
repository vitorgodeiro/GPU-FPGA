library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clear is
	port (
		start : in std_logic;
		wren : out std_logic;
		addr : out std_logic_vector(13 downto 0);
		done : out std_logic
	);
end clear;

architecture clear of clear is
	signal addrR : std_logic_vector(13 downto 0);
	signal addrN : std_logic_vector(13 downto 0);
begin
	addr <= addrR;
	process
	begin
		if clock'event and clock = '1' then
			if start = '1' then
				addrR <= 0;
			else
				addrR <= std_logic_vector( signed(addrR) + 1 );
			end if;
			----------------------------------------------
			if addrR = "11111111111111" then
				done <= '1';
			else
				done <= '0';
			end if;
		end if;
	end process;
end clear;