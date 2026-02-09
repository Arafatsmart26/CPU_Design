library ieee;
use ieee.std_logic_1164.all;

entity control_unit is
  port (
    opcode   : in  std_logic_vector(3 downto 0);
    reg_dst  : out std_logic;
    alu_src  : out std_logic;
    mem_to_reg : out std_logic;
    reg_write  : out std_logic;
    mem_read   : out std_logic;
    mem_write  : out std_logic;
    branch     : out std_logic;
    jump       : out std_logic;
    alu_op     : out std_logic_vector(3 downto 0)
  );
end entity;

architecture rtl of control_unit is
begin
  process(opcode)
  begin
    -- sæt standardværdier
    reg_dst   <= '0';
    alu_src   <= '0';
    mem_to_reg<= '0';
    reg_write <= '0';
    mem_read  <= '0';
    mem_write <= '0';
    branch    <= '0';
    jump      <= '0';
    alu_op    <= "0000";

    case opcode is
      when "0000" =>       -- ADD
        reg_dst   <= '1';
        reg_write <= '1';
        alu_op    <= "0000";
      when "0001" =>       -- SUB
        reg_dst   <= '1';
        reg_write <= '1';
        alu_op    <= "0001";
      when "0010" =>       -- LW
        alu_src   <= '1';
        mem_to_reg<= '1';
        reg_write <= '1';
        mem_read  <= '1';
        alu_op    <= "0000"; -- ADD for adresse
      when "0011" =>       -- SW
        alu_src   <= '1';
        mem_write <= '1';
        alu_op    <= "0000";
      when "0100" =>       -- BEQ
        branch    <= '1';
        alu_op    <= "0001"; -- SUB til sammenligning
      when "0101" =>       -- JUMP
        jump      <= '1';
      when others =>
        null;
    end case;
  end process;
end architecture;