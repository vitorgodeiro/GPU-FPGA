library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
---------------------------------------------------------
entity Line_PC is
    port(
        -- IN
        clock, reset, start : in std_logic;
        x0Lx1, y0Ly1, x0Ex1, y0Ey1, dxGdy, e2Gmdx, e2Ldy : in std_logic;
        -- OUT
        x0_load, y0_load, x1_load, y1_load, dx_load, dy_load, sx_load, sy_load, e_load, e2_load, p_load, i_load, wren : out std_logic;
        x0_select, y0_select, sx_select, sy_select, dx_select, dy_select : out std_logic;
        e_select : out std_logic_vector(1 downto 0);
        estado : out std_logic_vector(3 downto 0);
		  free : out std_logic
    );
end Line_PC;
---------------------------------------------------------
architecture Line_PC of Line_PC is
    signal sel : std_logic_vector(3 downto 0);
    signal fioFinal : std_logic_vector(18 downto 0);
    ---------------( vetor de saida )---------------
    --     Total de 14 estados (0 a 13)
    --    18 bits no fio final
    --    "x0_load, x0_select, x1_load, y0_load, y0_select, y1_load, dx_load, dy_load, sx_load, 
    --    sx_select, sy_load, sy_select, e_load, e_select(2), e2_load, p_load, i_load, img_load"
    --    
    ------------------------------------------------
begin
    x0_load <= fioFinal(0);
    x0_select <= fioFinal(1);
    x1_load <= fioFinal(2);
    y0_load <= fioFinal(3);
    y0_select <= fioFinal(4);
    y1_load <= fioFinal(5);    
    dx_load <= fioFinal(6);
    dy_load <= fioFinal(7);
    sx_load <= fioFinal(8);
    sx_select <= fioFinal(9);
    sy_load <= fioFinal(10);
    sy_select <= fioFinal(11);
    e_load <= fioFinal(12);
    e_select <= fioFinal(14 downto 13);
    e2_load <= fioFinal(15);
    p_load <= fioFinal(16);
    i_load <= fioFinal(17);
    wren <= fioFinal(18);
    estado <= sel;

	free <= '1' when sel = "0000" else '0';
	
    process( clock, reset )
    begin -- x0Lx1, y0Ly1, dxGdy, x0Ex1, y0Ey1, e2Gmdx, e2Ldy
	if reset = '1' then
		sel <= "0000";
        elsif clock='1' and clock'event then            
            case sel is
                when "0000"=> -- E0
                    if start='1' then
                        sel <= "0001";
                    else
                        sel <= "0000";
                    end if;
                when "0001"=> -- E1
                    if x0Lx1 = '1' then
                        sel <= "0010";
                    else
                        sel <= "0011";
                    end if;
                when "0010"=> -- E2
                    if y0Ly1 = '1' then
                        sel <= "0100";
                    else
                        sel <= "0101";
                    end if;
                when "0011"=> -- E3
                    if y0Ly1 = '1' then
                        sel <= "0100";
                    else
                        sel <= "0101";
                    end if;
                when "0100"=> -- E4
                        sel <= "0110";
                when "0101"=> -- E5
                        sel <= "0110";
                when "0110"=> -- E6
                        sel <= "0111";
                when "0111"=> -- E7
                    if dxGdy = '1' then
                        sel <= "1000";
                    else
                        sel <= "1001";
                    end if;
                when "1000"=> -- E8
                    if x0Ex1 = '1' and y0Ey1 = '1' then
                        sel <= "0000";
                    else
                        sel <= "1010";
                    end if;
                when "1001"=> -- E9
                    if x0Ex1 = '1' and y0Ey1 = '1' then
                        sel <= "0000";
                    else
                        sel <= "1010";
                    end if;
                when "1010"=> -- E10
                        sel <= "1011";
                when "1011"=> -- E11
                    sel <= "1100";
                when "1100"=> -- E12
                    if e2Gmdx = '1' then
                        sel <= "1101";
                    else
                        if e2Ldy = '1' then
                            sel <= "1110";
                        else
                            if x0Ex1 = '1' and y0Ey1 = '1' then
                                sel <= "0000";
                            else
                                sel <= "1010";
                            end if;
                        end if;
                    end if;
                when "1101"=> -- E13
                    if e2Ldy = '1' then
                        sel <= "1110";
                    else
                        if x0Ex1 = '1' and y0Ey1 = '1' then
                            sel <= "0000";
                        else
                            sel <= "1010";
                        end if;
                    end if;
                when "1110"=> -- E14
                        sel <="1111";
                when others=> -- E15
                    if x0Ex1 = '1' and y0Ey1 = '1' then
                        sel <= "0000";
                    else
                        sel <= "1010";
                    end if;
            end case;
        end if;
    end process;

    process(sel)
    begin -- x0Lx1, y0Ly1, dxGdy, x0Ex1, y0Ey1, e2Gmdx, e2Ldy
    case sel is
	when "0000"=> -- E0
	    fioFinal <= "0000000000000101101"; -- ok
	when "0001"=> -- E1
	    fioFinal <= "0010000000000000000"; -- ok
	when "0010"=> -- E2
	    fioFinal <= "0000000000100000000"; -- ok
	when "0011"=> -- E3
	    fioFinal <= "0000000001100000000"; -- ok
	when "0100"=> -- E4
	    fioFinal <= "0000000010000000000"; -- ok
	when "0101"=> -- E5
	    fioFinal <= "0000000110000000000"; -- ok
	when "0110"=> -- E6
	    fioFinal <= "0000000000011000000"; -- ok
	when "0111"=> -- E7
	    fioFinal <= "0000000000000000000"; -- ok
	when "1000"=> -- E8
	    fioFinal <= "0000001000000000000"; -- ok
	when "1001"=> -- E9
	    fioFinal <= "0000011000000000000"; -- ok
	when "1010"=> -- E10
	    fioFinal <= "0100000000000000000"; -- ok
	when "1011"=> -- E11
	    fioFinal <= "0001000000000000000"; -- ok
	when "1100"=> -- E12
	    fioFinal <= "1000000000000000000"; -- ok
	when "1101"=> -- E13
	    fioFinal <= "0000101000000000011"; -- ok
	when  "1110"=> -- E14
	    fioFinal <= "0000111000000011000"; -- ok
	when others => -- E15
        fiofinal <= "0000000000000000000"; -- ok
    end case;
    end process;

end Line_PC;
