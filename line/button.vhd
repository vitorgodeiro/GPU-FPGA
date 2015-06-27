library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity button is
    generic (
        tempo : integer := 2500000
    );
    port (
        clock : in std_logic;
        reset : in std_logic;
        key   : in std_logic;
        dkey  : out std_logic
    );
end button;

architecture button of button is
    signal counter : integer;
begin
    dkey <= '1' when key = '0' and counter = tempo else '0';

    process (clock, reset)
    begin
        if reset = '1' then
            counter <= 0;
        elsif clock'event and clock = '1' then
            if counter = 0 then
                if key = '1' then
                    counter <= counter + 1;
                end if;
            elsif counter < tempo then
                counter <= counter + 1;
            else
                if key = '0' then
                    counter <= 0;
                end if;
            end if;
        end if;
    end process;
end button;
