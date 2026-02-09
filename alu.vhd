library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
  port (
    a      : in  std_logic_vector(31 downto 0);
    b      : in  std_logic_vector(31 downto 0);
    alu_op : in  std_logic_vector(3 downto 0); -- fx 4 bit opcode til ALU
    result : out std_logic_vector(31 downto 0);
    zero   : out std_logic
  );
end entity;

architecture rtl of alu is
begin
  process(a, b, alu_op)
    variable res : signed(31 downto 0);
  begin
    case alu_op is
      when "0000" => res := signed(a) + signed(b);  -- ADD
      when "0001" => res := signed(a) - signed(b);  -- SUB
      when "0010" => res := signed(a) and signed(b);-- AND
      when "0011" => res := signed(a) or  signed(b);-- OR
      -- flere operationer her...
      when others => res := (others => '0');
    end case;

    result <= std_logic_vector(res);
    if res = 0 then
      zero <= '1';
    else
      zero <= '0';
    end if;
  end process;
end architecture;