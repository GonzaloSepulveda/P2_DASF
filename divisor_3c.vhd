library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity divisor_3 is
    port(
        clk         : in  std_logic;
        ena         : in  std_logic;  -- Reset asíncrono (activo en '0')
        f_div_5     : out std_logic;  -- Salida de 5MHz (100MHz/20)
        f_div_2_5   : out std_logic;  -- Salida de 2.5MHz (100MHz/40)
        f_div_1     : out std_logic   -- Salida de 1MHz (100MHz/100)
    );
end entity divisor_3;

architecture Behavioral of divisor_3 is
    -- Contadores para los diferentes divisores
    signal count20 : unsigned(4 downto 0) := (others => '0');  -- Mod 20
    signal count40 : unsigned(5 downto 0) := (others => '0');  -- Mod 40
    signal count100 : unsigned(6 downto 0) := (others => '0'); -- Mod 100

    signal pulse_5   : std_logic := '0';
    signal pulse_2_5 : std_logic := '0';  
    signal pulse_1   : std_logic := '0';

begin
    -- Proceso del contador de módulo 20 para generar 5MHz
    process(clk, ena)
    begin 
        if ena = '0' then
            count20 <= (others => '0');
            pulse_5 <= '1';
        elsif rising_edge(clk) then 
            count20 <= count20 + 1;
            if count20 = "10011" then  -- 19 en binario (reinicia en 20)
                count20 <= (others => '0');
                pulse_5 <= '1';
            else
                pulse_5 <= '0';
            end if;
        end if;
    end process;

    -- Proceso del contador de módulo 40 para generar 2.5MHz
    process(clk, ena)
    begin 
        if ena = '0' then
            count40 <= (others => '0');
            pulse_2_5 <= '1';
        elsif rising_edge(clk) then 
            count40 <= count40 + 1;
            if count40 = "100111" then  -- 39 en binario (reinicia en 40)
                count40 <= (others => '0');
                pulse_2_5 <= '1';
            else
                pulse_2_5 <= '0';
            end if;
        end if;
    end process;
    
    -- Proceso del contador de módulo 100 para generar 1MHz
    process(clk, ena)
    begin 
        if ena = '0' then
            count100 <= (others => '0');
            pulse_1 <= '1';
        elsif rising_edge(clk) then 
            count100 <= count100 + 1;
            if count100 = "1100011" then  -- 99 en binario (reinicia en 100)
                count100 <= (others => '0');
                pulse_1 <= '1';
            else
                pulse_1 <= '0';
            end if;
        end if;
    end process;

    -- Asignaciones de salida
    f_div_5  <= pulse_5;
    f_div_2_5 <= pulse_2_5;
    f_div_1  <= pulse_1;

end Behavioral;
