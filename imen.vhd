library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity imem is
  port (
    addr  : in  std_logic_vector(31 downto 0);
    instr : out std_logic_vector(31 downto 0)
  );
end entity;

architecture rtl of imem is
  type mem_t is array (0 to 255) of std_logic_vector(31 downto 0);
  signal mem : mem_t := (
    0 => x"20010001", -- eksempel maskinkode
    1 => x"20020002",
    others => (others => '0')
  );
begin
  instr <= mem(to_integer(unsigned(addr(9 downto 2)))); -- word‑aligned
end architecture;