library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dual_memory_bram is
    generic (
        DATA_WIDTH : integer := 32;
        ADDR_WIDTH : integer := 8 -- 2 ^ ADDR_WIDTH addresses
    );
    port (
        a_clock  : in std_logic;
        a_wren   : in std_logic;
        a_addr   : in std_logic_vector(ADDR_WIDTH - 1 downto 0);
        a_data_i : in std_logic_vector(DATA_WIDTH - 1 downto 0);
        a_data_o : out std_logic_vector(DATA_WIDTH - 1 downto 0);

        b_clock  : in std_logic;
        b_wren   : in std_logic;
        b_addr   : in std_logic_vector(ADDR_WIDTH - 1 downto 0);
        b_data_i : in std_logic_vector(DATA_WIDTH - 1 downto 0);
        b_data_o : out std_logic_vector(DATA_WIDTH - 1 downto 0)
    );
end dual_memory_bram;

architecture behavior of dual_memory_bram is
    constant NW : integer := 2 ** ADDR_WIDTH - 1; -- number of words
    type bram_t is array (NW downto 0) of std_logic_vector(DATA_WIDTH - 1 downto 0);

    shared variable bram : bram_t := (
		00 => std_logic_vector(to_unsigned(0, DATA_WIDTH)),-- Linha Principal
		1 => std_logic_vector(to_unsigned(15, DATA_WIDTH)),
		2 => std_logic_vector(to_unsigned(15, DATA_WIDTH)),
		3 => std_logic_vector(to_unsigned(70, DATA_WIDTH)),
		4 => std_logic_vector(to_unsigned(70, DATA_WIDTH)),
		5 => std_logic_vector(to_unsigned(1540, DATA_WIDTH)),
		
		6 => std_logic_vector(to_unsigned(0, DATA_WIDTH)),--1 Parte do triangulo
		7 => std_logic_vector(to_unsigned(63, DATA_WIDTH)),
		8 => std_logic_vector(to_unsigned(78, DATA_WIDTH)),
		9 => std_logic_vector(to_unsigned(78, DATA_WIDTH)),
		10 => std_logic_vector(to_unsigned(78, DATA_WIDTH)),
		11 => std_logic_vector(to_unsigned(1540, DATA_WIDTH)),
		
		12 => std_logic_vector(to_unsigned(00, DATA_WIDTH)), -- 2 Parte do triangulo
		13 => std_logic_vector(to_unsigned(78, DATA_WIDTH)),
		14 => std_logic_vector(to_unsigned(78, DATA_WIDTH)),
		15 => std_logic_vector(to_unsigned(78, DATA_WIDTH)),
		16 => std_logic_vector(to_unsigned(63, DATA_WIDTH)),
		17 => std_logic_vector(to_unsigned(1540, DATA_WIDTH)),

		18 => std_logic_vector(to_unsigned(00, DATA_WIDTH)), -- 3 Parte do triangulo
		19 => std_logic_vector(to_unsigned(78, DATA_WIDTH)),
		20 => std_logic_vector(to_unsigned(63, DATA_WIDTH)),
		21 => std_logic_vector(to_unsigned(63, DATA_WIDTH)),
		22 => std_logic_vector(to_unsigned(78, DATA_WIDTH)),
		23 => std_logic_vector(to_unsigned(1540, DATA_WIDTH)),
																				-- OBS: aux sao as penas da arrow
		24 => std_logic_vector(to_unsigned(00, DATA_WIDTH)), -- aux1 
		25 => std_logic_vector(to_unsigned(20, DATA_WIDTH)),
		26 => std_logic_vector(to_unsigned(20, DATA_WIDTH)),
		27 => std_logic_vector(to_unsigned(20, DATA_WIDTH)),
		28 => std_logic_vector(to_unsigned(10, DATA_WIDTH)),
		29 => std_logic_vector(to_unsigned(1540, DATA_WIDTH)),
		
		30 => std_logic_vector(to_unsigned(00, DATA_WIDTH)), -- aux2 
		31 => std_logic_vector(to_unsigned(20, DATA_WIDTH)),
		32 => std_logic_vector(to_unsigned(20, DATA_WIDTH)),
		33 => std_logic_vector(to_unsigned(10, DATA_WIDTH)),
		34 => std_logic_vector(to_unsigned(20, DATA_WIDTH)),
		35 => std_logic_vector(to_unsigned(1540, DATA_WIDTH)),
		
		36 => std_logic_vector(to_unsigned(00, DATA_WIDTH)), -- aux3
		37 => std_logic_vector(to_unsigned(25, DATA_WIDTH)),
		38 => std_logic_vector(to_unsigned(25, DATA_WIDTH)),
		39 => std_logic_vector(to_unsigned(25, DATA_WIDTH)),
		40 => std_logic_vector(to_unsigned(15, DATA_WIDTH)),
		41 => std_logic_vector(to_unsigned(1540, DATA_WIDTH)),
		
		42 => std_logic_vector(to_unsigned(00, DATA_WIDTH)), -- aux4
		43 => std_logic_vector(to_unsigned(25, DATA_WIDTH)),
		44 => std_logic_vector(to_unsigned(25, DATA_WIDTH)),
		45 => std_logic_vector(to_unsigned(15, DATA_WIDTH)),
		46 => std_logic_vector(to_unsigned(25, DATA_WIDTH)),
		47 => std_logic_vector(to_unsigned(1540, DATA_WIDTH)),
		
--		48 => std_logic_vector(to_unsigned(00, DATA_WIDTH)),  -- aux5
--		49 => std_logic_vector(to_unsigned(30, DATA_WIDTH)),
--		50 => std_logic_vector(to_unsigned(30, DATA_WIDTH)),
--		51 => std_logic_vector(to_unsigned(30, DATA_WIDTH)),
--		52 => std_logic_vector(to_unsigned(20, DATA_WIDTH)),
--		53 => std_logic_vector(to_unsigned(827, DATA_WIDTH)),
--		
--		54 => std_logic_vector(to_unsigned(00, DATA_WIDTH)), -- aux6
--		55 => std_logic_vector(to_unsigned(30, DATA_WIDTH)),
--		56 => std_logic_vector(to_unsigned(30, DATA_WIDTH)),
--		57 => std_logic_vector(to_unsigned(20, DATA_WIDTH)),
--		58 => std_logic_vector(to_unsigned(30, DATA_WIDTH)),
--		59 => std_logic_vector(to_unsigned(827, DATA_WIDTH)),
		
		48 => std_logic_vector(to_unsigned(00, DATA_WIDTH)), -- aux7
		49 => std_logic_vector(to_unsigned(15, DATA_WIDTH)),
		50 => std_logic_vector(to_unsigned(05, DATA_WIDTH)),
		51 => std_logic_vector(to_unsigned(15, DATA_WIDTH)),
		52 => std_logic_vector(to_unsigned(15, DATA_WIDTH)),
		53 => std_logic_vector(to_unsigned(1540, DATA_WIDTH)),
		
		54 => std_logic_vector(to_unsigned(00, DATA_WIDTH)), -- aux8
		55 => std_logic_vector(to_unsigned(5, DATA_WIDTH)),
		56 => std_logic_vector(to_unsigned(15, DATA_WIDTH)),
		57 => std_logic_vector(to_unsigned(15, DATA_WIDTH)),
		58 => std_logic_vector(to_unsigned(15, DATA_WIDTH)),
		59 => std_logic_vector(to_unsigned(1540, DATA_WIDTH)),
		
		60 => std_logic_vector(to_unsigned(00, DATA_WIDTH)), --traço3
		61 => std_logic_vector(to_unsigned(50, DATA_WIDTH)),
		62 => std_logic_vector(to_unsigned(70, DATA_WIDTH)),
		63=> std_logic_vector(to_unsigned(70, DATA_WIDTH)),
		64 => std_logic_vector(to_unsigned(50, DATA_WIDTH)),
		65 => std_logic_vector(to_unsigned(827, DATA_WIDTH)),
		
		66 => std_logic_vector(to_unsigned(00, DATA_WIDTH)),	--traço4
		67 => std_logic_vector(to_unsigned(70, DATA_WIDTH)),
		68 => std_logic_vector(to_unsigned(50, DATA_WIDTH)),
		69 => std_logic_vector(to_unsigned(80, DATA_WIDTH)),
		70 => std_logic_vector(to_unsigned(30, DATA_WIDTH)),
		71 => std_logic_vector(to_unsigned(827, DATA_WIDTH)),
		
		72 => std_logic_vector(to_unsigned(00, DATA_WIDTH)),	--traço5
		73 => std_logic_vector(to_unsigned(80, DATA_WIDTH)),
		74 => std_logic_vector(to_unsigned(30, DATA_WIDTH)),
		75 => std_logic_vector(to_unsigned(70, DATA_WIDTH)),
		76 => std_logic_vector(to_unsigned(05, DATA_WIDTH)),
		77 => std_logic_vector(to_unsigned(827, DATA_WIDTH)),
		
		78 => std_logic_vector(to_unsigned(00, DATA_WIDTH)), -- traço2
		79 => std_logic_vector(to_unsigned(50, DATA_WIDTH)),
		80 => std_logic_vector(to_unsigned(70, DATA_WIDTH)),
		81 => std_logic_vector(to_unsigned(30, DATA_WIDTH)),
		82 => std_logic_vector(to_unsigned(80, DATA_WIDTH)),
		83 => std_logic_vector(to_unsigned(827, DATA_WIDTH)),
		
		84 => std_logic_vector(to_unsigned(00, DATA_WIDTH)), --traço1
		85 => std_logic_vector(to_unsigned(30, DATA_WIDTH)), 
		86 => std_logic_vector(to_unsigned(80, DATA_WIDTH)),
		87 => std_logic_vector(to_unsigned(05, DATA_WIDTH)),
		88 => std_logic_vector(to_unsigned(70, DATA_WIDTH)),
		89 => std_logic_vector(to_unsigned(827, DATA_WIDTH)),
		
		90 => std_logic_vector(to_unsigned(00, DATA_WIDTH)), --Corda
		91 => std_logic_vector(to_unsigned(15, DATA_WIDTH)), 
		92 => std_logic_vector(to_unsigned(15, DATA_WIDTH)),
		93 => std_logic_vector(to_unsigned(5, DATA_WIDTH)),
		94 => std_logic_vector(to_unsigned(70, DATA_WIDTH)),
		95 => std_logic_vector(to_unsigned(827, DATA_WIDTH)),
		
		96 => std_logic_vector(to_unsigned(00, DATA_WIDTH)), --Corda
		97 => std_logic_vector(to_unsigned(15, DATA_WIDTH)), 
		98 => std_logic_vector(to_unsigned(15, DATA_WIDTH)),
		99 => std_logic_vector(to_unsigned(70, DATA_WIDTH)),
		100 => std_logic_vector(to_unsigned(5, DATA_WIDTH)),
		101 => std_logic_vector(to_unsigned(827, DATA_WIDTH)),
		
		102 => (others => '1'),
		others => (others => '0')
	 );
begin
    -- Port A
    process (a_clock)
    begin
        if a_clock'event and a_clock = '1' then
            if a_wren = '1' then
                bram(to_integer(unsigned(a_addr))) := a_data_i;
            end if;

            a_data_o <= bram(to_integer(unsigned(a_addr)));
        end if;
    end process;
     
    -- Port B
    process (b_clock)
    begin
        if b_clock'event and b_clock = '1' then
            if b_wren = '1' then
                bram(to_integer(unsigned(b_addr))) := b_data_i;
            end if;

            b_data_o <= bram(to_integer(unsigned(b_addr)));
        end if;
    end process;

end behavior;

