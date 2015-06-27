library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comandos is
    generic (
        N : integer := 7; -- line coords width
		  M : integer := 7  -- n_cmds
    );
    port (
        clock   : in std_logic;
        reset   : in std_logic;
        start   : in std_logic;
		  units_free : in std_logic;
		  
		  proc_wren : in std_logic;
		  proc_addr : in std_logic_vector(M - 1 downto 0);
		  proc_data_i : in std_logic_vector(15 downto 0);
		  proc_data_o : out std_logic_vector(15 downto 0);
		  
        line_start : out std_logic;
        line_x0 : out std_logic_vector(N - 1 downto 0);
        line_y0 : out std_logic_vector(N - 1 downto 0);
        line_x1 : out std_logic_vector(N - 1 downto 0);
        line_y1 : out std_logic_vector(N - 1 downto 0);
        line_pixel  : out std_logic_vector(11 downto 0)
    );
end comandos;

architecture comandos of comandos is
    type state_t is (idle, read_cmd_and_opers, select_cmd, wait_units_free);
    type opers_t is array (0 to 15) of std_logic_vector(15 downto 0);

    signal state : state_t;
    signal opers : opers_t;

    signal ptr  : std_logic_vector(M - 1 downto 0);
    signal opr  : std_logic_vector(3 downto 0);
    signal oprt : std_logic_vector(3 downto 0);
    signal addr : std_logic_vector(M - 1 downto 0);
	 signal operand : std_logic_vector(15 downto 0);
	 
	 constant DRAW_LINE : std_logic_vector := x"0000";
	 constant END_CMD   : std_logic_vector := x"FFFF";
begin
    line_x0 <= opers(1)(N - 1 downto 0);
    line_y0 <= opers(2)(N - 1 downto 0);
    line_x1 <= opers(3)(N - 1 downto 0);
    line_y1 <= opers(4)(N - 1 downto 0);
    line_pixel <= opers(5)(11 downto 0);

    addr <= std_logic_vector(unsigned(ptr) + unsigned(opr));
	 
    cmd_mem : entity work.dual_memory_bram
    generic map (
        DATA_width => 16,
        ADDR_width => M
    )
    port map (
        a_clock  => clock,
        a_wren   => proc_wren,
        a_addr   => proc_addr,
        a_data_i => proc_data_i,
        a_data_o => proc_data_o,

        b_clock  => clock,
        b_wren   => '0',
        b_addr   => addr,
        b_data_i => x"0000",
        b_data_o => operand
    );
	 
	 line_start <= '1' when opers(0) = DRAW_LINE and state = select_cmd else '0';
	 
    process (clock, reset)
    begin
        if reset = '1' then
            state <= idle;
            ptr <= (others => '0');
				oprt <= "0000";
				opr <= "0000";
        elsif clock'event and clock = '1' then
            case state is
                when idle =>
                    opr <= "0000";
						  oprt <= "0000";
						  ptr <= (others => '0');

                    if start = '1' then 
                        state <= read_cmd_and_opers;
                    end if;

                when read_cmd_and_opers =>
                    opr <= std_logic_vector(unsigned(opr) + 1);
						  oprt <= opr;
						  opers(to_integer(unsigned(oprt))) <= operand;

                    if oprt = "1110" then
                        state <= select_cmd;
                    end if;

                when select_cmd =>
                    case opers(0) is
                        when DRAW_LINE =>
                            ptr <= std_logic_vector(unsigned(ptr) + 6);
                            state <= wait_units_free;
									 
								when others => 
									state <= idle;
                    end case;

                when wait_units_free =>
                    if units_free = '1' then
                        state <= read_cmd_and_opers;
                    end if;
            end case;
        end if;        
    end process;
end comandos;
