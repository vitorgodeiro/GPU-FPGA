library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-----------------------------------------------
entity Line_alg is
	port(
		clock, reset, start : in std_logic;
		x0_param, x1_param, y0_param, y1_param : in std_logic_vector(6 downto 0);
		p_param : in std_logic_vector(11 downto 0);
		addr : out std_logic_vector(13 downto 0);
		wren : out std_logic;
		pixel_i : in std_logic_vector(11 downto 0);
		pixel_o : out std_logic_vector(11 downto 0);
		free : out std_logic;
		estado : out std_logic_vector(3 downto 0)
	);
end Line_alg;
-----------------------------------------------
architecture Line_alg of Line_alg is
	signal fios : std_logic_vector(24 downto 0);
begin
	process (clock)
	begin
		if clock'event and clock = '1' then
			if start = '1' then
				pixel_o <= pixel_i;
			end if;
		end if;
	end process;
	
	LinePC : entity work.Line_PC
	port map( -- 23
		-- IN
		clock => clock,
		reset => reset,
		start => start,
		x0Lx1 => fios(0),
		y0Ly1 => fios(1),
		x0Ex1 => fios(2),
		y0Ey1 => fios(3),
		dxGdy => fios(4),
		e2Gmdx => fios(5),
		e2Ldy => fios(6),
		-- OUT
		x0_load => fios(7),
		y0_load => fios(8),
		x1_load => fios(9),
		y1_load => fios(10),
		dx_load => fios(11),
		dy_load => fios(12),
		sx_load => fios(13),
		sy_load => fios(14),
		e_load => fios(15),
		e2_load => fios(16),
		p_load => fios(17),
		i_load => fios(18),
		wren => wren,	
		x0_select => fios(19),
		y0_select => fios(20),
		sx_select => fios(21),
		sy_select => fios(22),
		e_select => fios(24 downto 23),
		estado => estado,
		free => free
	);
	
	LinePO : entity work.Line_PO
	port map( -- 26
		-- IN
		x0_param => x0_param,
		x1_param => x1_param,
		y0_param => y0_param,
		y1_param => y1_param,
		p_param => p_param,
		x0_load => fios(7),
		y0_load => fios(8),
		x1_load => fios(9),
		y1_load => fios(10),
		dx_load => fios(11),
		dy_load => fios(12),
		sx_load => fios(13),
		sy_load => fios(14),
		e_load => fios(15),
		e2_load => fios(16),
		p_load => fios(17),
		i_load => fios(18),
		clock => clock,
		start => start,
		x0_select => fios(19),
		y0_select => fios(20),
		sx_select => fios(21),
		sy_select => fios(22),
		e_select => fios(24 downto 23),
		-- OUT
		addr => addr,
		x0Lx1 => fios(0),
		y0Ly1 => fios(1),
		x0Ex1 => fios(2),
		y0Ey1 => fios(3),
		dxGdy => fios(4),
		e2Gmdx => fios(5),
		e2Ldy => fios(6)	
	);
end Line_alg;
