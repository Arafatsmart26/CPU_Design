library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu_core is
  port (
    clk   : in  std_logic;
    reset : in  std_logic
  );
end entity;

architecture rtl of cpu_core is
  signal pc, next_pc, instr : std_logic_vector(31 downto 0);
  signal rd1, rd2, alu_b, alu_res : std_logic_vector(31 downto 0);
  signal zero : std_logic;

  -- control signals
  signal reg_dst, alu_src, mem_to_reg, reg_write,
         mem_read, mem_write, branch, jump : std_logic;
  signal alu_op : std_logic_vector(3 downto 0);

  -- instr fields
  signal opcode : std_logic_vector(3 downto 0);
  signal rs, rt, rd : std_logic_vector(3 downto 0);
  signal imm_ext : std_logic_vector(31 downto 0);

begin
  opcode <= instr(31 downto 28);
  rd     <= instr(27 downto 24);
  rs     <= instr(23 downto 20);
  rt     <= instr(19 downto 16);
  -- simplificeret sign‑extend af de nederste 16 bit:
  imm_ext <= (15 downto 0 => instr(15)) & instr(15 downto 0);

  u_pc: entity work.pc
    port map (
      clk     => clk,
      reset   => reset,
      next_pc => next_pc,
      pc_out  => pc
    );

  u_imem: entity work.imem
    port map (
      addr  => pc,
      instr => instr
    );

  u_ctrl: entity work.control_unit
    port map (
      opcode    => opcode,
      reg_dst   => reg_dst,
      alu_src   => alu_src,
      mem_to_reg=> mem_to_reg,
      reg_write => reg_write,
      mem_read  => mem_read,
      mem_write => mem_write,
      branch    => branch,
      jump      => jump,
      alu_op    => alu_op
    );

  u_rf: entity work.register_file
    port map (
      clk  => clk,
      we   => reg_write,
      ra1  => rs,
      ra2  => rt,
      wa   => (others => '0') when reg_dst = '0' else rd,
      wd   => alu_res, -- simplificeret: skriv altid ALU‑resultat
      rd1  => rd1,
      rd2  => rd2
    );

  alu_b <= imm_ext when alu_src = '1' else rd2;

  u_alu: entity work.alu
    port map (
      a      => rd1,
      b      => alu_b,
      alu_op => alu_op,
      result => alu_res,
      zero   => zero
    );

  -- meget simplificeret pc‑logik (ingen branch/jump implementeret endnu)
  next_pc <= std_logic_vector(unsigned(pc) + 4);

end architecture;