library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-----------------------------------------------------------------------
entity Line_PO is
    port(
        -- IN
        x0_param  : in std_logic_vector( 6 downto 0);
        x1_param  : in std_logic_vector( 6 downto 0);
        y0_param  : in std_logic_vector( 6 downto 0);
        y1_param  : in std_logic_vector( 6 downto 0);
        p_param   : in std_logic_vector(11 downto 0);
        x0_load   : in std_logic;
        y0_load   : in std_logic;
        x1_load   : in std_logic;
        y1_load   : in std_logic;
        dx_load   : in std_logic;
        dy_load   : in std_logic;
        sx_load   : in std_logic;
        sy_load   : in std_logic;
        e_load    : in std_logic;
        e2_load   : in std_logic;
        p_load    : in std_logic;
        i_load    : in std_logic;
        clock     : in std_logic;
        start     : in std_logic;
        x0_select : in std_logic;
        y0_select : in std_logic;
        sx_select : in std_logic;
        sy_select : in std_logic;
        e_select  : in std_logic_vector(1 downto 0);
        -- OUT
        addr      : out std_logic_vector(13 downto 0);
        x0Lx1     : out std_logic; -- L=lass than, G=greater than, E=equal to, m=minus
        y0Ly1     : out std_logic; -- L=lass than, G=greater than, E=equal to, m=minus
        dxGdy     : out std_logic; -- L=lass than, G=greater than, E=equal to, m=minus
        x0Ex1     : out std_logic; -- L=lass than, G=greater than, E=equal to, m=minus
        y0Ey1     : out std_logic; -- L=lass than, G=greater than, E=equal to, m=minus
        e2Gmdx    : out std_logic; -- L=lass than, G=greater than, E=equal to, m=minus
        e2Ldy     : out std_logic-- L=lass than, G=greater than, E=equal to, m=minus
    );
end Line_PO;
-----------------------------------------------------------------------
architecture Line_PO of Line_PO is
    signal x0, x1, y0, y1 : std_logic_vector(6 downto 0);
    signal p : std_logic_vector(11 downto 0);
    signal dx, dy,  e, e2 : std_logic_vector(6 downto 0);
    signal index : std_logic_vector(13 downto 0);
    signal sx, sy : std_logic_vector(6 downto 0);
    signal sxGzero, syGzero : std_logic;
    signal hDy, minusDx : std_logic_vector(6 downto 0);
begin
    addr <= index;
    process (clock)
    begin
        if clock='1' and clock'event then
            ---------------------- OPERACOES ------------------------
            ---------------------------------------------------------
            if p_load='1' then
                p <= p_param;
            end if;
            ---------------------------------------------------------
            if x0_load='1' or start='1' then
                if x0_select='0'  then
                    x0 <= x0_param;
                else
                    x0 <= std_logic_vector( signed(x0) + signed(sx) );
                end if;
            end if;
            ---------------------------------------------------------
            if y0_load='1' or start='1' then
                if y0_select='0' then
                    y0 <= y0_param;
                else
                    y0 <= std_logic_vector( signed(y0) + signed(sy) );
                end if;
            end if;
            ---------------------------------------------------------
            if x1_load='1' or start='1' then
                x1 <= x1_param;
            end if;
            ---------------------------------------------------------
            if y1_load='1' or start='1' then
                y1 <= y1_param;
            end if;
            ---------------------------------------------------------
            if sx_load='1' then
                if sx_select='0' then
                    sx <= "0000001";
                else
                    sx <= "1111111";
                end if;
            end if;
            ---------------------------------------------------------
            if sy_load='1' then
                if sy_select='0' then
                    sy <= "0000001";
                else
                    sy <= "1111111";
                end if;
            end if;
            ---------------------------------------------------------
            if dx_load='1' then
                if sxGzero='1' then
                    dx <= std_logic_vector( signed(x1) - signed(x0) );
                else
                    dx <= std_logic_vector( 0 - (signed(x1) - signed(x0)));
                end if;
            end if;
            ---------------------------------------------------------
            if dy_load='1' then
                if syGzero='1' then
                    dy <= std_logic_vector( signed(y1) - signed(y0) );
                else
                    dy <= std_logic_vector( 0 - (signed(y1) - signed(y0)));
                end if;
            end if;
            ---------------------------------------------------------
            if e_load='1' then
                case e_select is
                    when "00"=>
                        e <= dx(6) & dx(6) & dx(5 downto 1);
                    when "01"=>
                        e <= std_logic_vector( 0 - signed(hdy) );
                    when "10"=>
                        e <= std_logic_vector( signed(e) - signed(dy) );
                    when others=>
                        e <= std_logic_vector( signed(e) + signed(dx) );
                end case;
            end if;
            ---------------------------------------------------------
            if e2_load='1' then
                e2 <= e;
            end if;
            ---------------------------------------------------------
            if i_load='1' then
                index <= std_logic_vector( unsigned( y0 & "0000000" ) + unsigned("0000000" & x0) );
            end if;
            ---------------------------------------------------------
            ---------------------------------------------------------
        end if;
    end process;

	process (dy, dx, x0, x1, y0, y1, e2, minusDx, sx, sy)
	begin
            hDy <= std_logic_vector( '0' & dy(6 downto 1) );
            minusDx <= std_logic_vector( 0 - signed( dx ) );
            ---------------------------------------------------------
            --------------------- COMPARACOES -----------------------
            if unsigned(x0) < unsigned(x1) then
                x0Lx1 <= '1';
            else
                x0Lx1 <= '0';
            end if;
            ---------------------------------------------------------
            if unsigned(y0) < unsigned(y1) then
                y0Ly1 <= '1';
            else
                y0Ly1 <= '0';
            end if;
            ---------------------------------------------------------
            if signed(dx) > signed(dy) then
                dxGdy <= '1';
            else
                dxGdy <= '0';
            end if;
            ---------------------------------------------------------
            if unsigned(x0) = unsigned(x1) then
                x0Ex1 <= '1';
            else
                x0Ex1 <= '0';
            end if;
            ---------------------------------------------------------
            if unsigned(y0) = unsigned(y1) then
                y0Ey1 <= '1';
            else
                y0Ey1 <= '0';
            end if;
            ---------------------------------------------------------
            if signed(e2) > signed(minusDx) then
                e2Gmdx <= '1';
            else
                e2Gmdx <= '0';
            end if;
            ---------------------------------------------------------
            if signed(e2) < signed(dy) then
                e2Ldy <= '1';
            else
                e2Ldy <= '0';
            end if;
            ---------------------------------------------------------
            sxGzero <= not sx(1);
            syGzero <= not sy(1);
	end process;

end Line_PO;
