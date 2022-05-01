library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CtrlFetch_tb is
end entity;

architecture behavioral of CtrlFetch_tb is

component CtrlFetch is

port ( 
	i_clk:			in std_logic;
	i_reset:			in std_logic;
	-- control path
	i_mode12K:		in std_logic_vector(1 downto 0);
	i_modeAddZA:	in std_logic_vector(1 downto 0);
	i_modePCZ:		in std_logic;
	i_loadPC:		in std_logic;
	i_loadIR:		in std_logic;
	-- data path
	i_K:				in unsigned(15 downto 0);
	i_A:				in unsigned(15 downto 0);
	i_Z:				in unsigned(15 downto 0);
	o_IR:				out unsigned(15 downto 0);
	o_PMDATA:		out unsigned(15 downto 0);
	-- memory interface
	o_PMADDR:		out unsigned(15 downto 0);
	i_PMDATA:		in unsigned(15 downto 0)
);

end component;

signal clk : std_logic := '0'; 
signal reset : std_logic := '0';

signal mode12K : std_logic_vector(1 downto 0) := (others => '0');
signal modeAddZA : std_logic_vector(1 downto 0) := (others => '0');
signal modePCZ : std_logic := '0';
signal loadPC : std_logic := '0';
signal loadIR : std_logic := '0';

signal A : unsigned(15 downto 0) := (others => '0');
signal K : unsigned(15 downto 0) := (others => '0');
signal Z : unsigned(15 downto 0) := (others => '0');

signal IR : unsigned(15 downto 0) := (others => '0');

signal in_PMDATA : unsigned(15 downto 0) := (others => '0');
signal out_PMDATA : unsigned(15 downto 0) := (others => '0');
signal out_PMADDR : unsigned(15 downto 0) := (others => '0');


constant CLK_PERIOD : time := 10 ns;

begin

uut: component CtrlFetch
port map
(
	i_clk => clk,
	i_reset => reset,
	i_mode12K => mode12K,
	i_modePCZ => modePCZ,
	i_modeAddZA => modeAddZA,
	i_loadPC => loadPC,
	i_loadIR => loadIR,
	i_K => K,
	i_A => A,
	i_Z => Z,
	o_IR => IR,
	o_PMDATA => out_PMDATA,
	o_PMADDR => out_PMADDR,
	i_PMDATA => in_PMDATA
);

clk_process: process
begin
	clk <= '0';
	wait for CLK_PERIOD / 2;
	clk <= '1';
	wait for CLK_PERIOD / 2;	
end process;


stimulus_process: process
begin
	reset <= '1';
	wait for CLK_PERIOD;
	reset <= '0';

	--------------------------------
	in_PMDATA <= "0000000000000000";
	wait for CLK_PERIOD;
	in_PMDATA <= "0000000000000001";
	wait for CLK_PERIOD;	
	in_PMDATA <= "0000000000000010";
	wait for CLK_PERIOD;
	in_PMDATA <= "0000000000000011";
	wait for CLK_PERIOD;
	in_PMDATA <= "0000000000000100";
	wait for CLK_PERIOD;

	in_PMDATA <= "0000000000001000";
	loadIR <= '1';
	wait for CLK_PERIOD;
	loadIR <= '0';
	wait for CLK_PERIOD;

	in_PMDATA <= "0000000000001001";
	loadIR <= '1';
	wait for CLK_PERIOD;
	loadIR <= '0';
	wait for CLK_PERIOD;

	in_PMDATA <= "0000000000001010";
	loadIR <= '1';
	wait for CLK_PERIOD;
	loadIR <= '0';
	wait for CLK_PERIOD;

	in_PMDATA <= "0000000000001011";
	loadIR <= '1';
	wait for CLK_PERIOD;
	loadIR <= '0';
	wait for CLK_PERIOD;

	in_PMDATA <= "0000000000001100";
	loadIR <= '1';
	wait for CLK_PERIOD;
	loadIR <= '0';
	wait for CLK_PERIOD;
	
	--------------------------------	
	modePCZ <= '1';
	Z <= "0000000000000000";
	wait for CLK_PERIOD;
	Z <= "0000000000000001";
	wait for CLK_PERIOD;
	Z <= "0000000000000010";
	wait for CLK_PERIOD;
	Z <= "0000000000000011";
	wait for CLK_PERIOD;
	modePCZ <= '0';
	wait for CLK_PERIOD;
	
	
	--------------------------------
	modeAddZA <= "10";
	Z <= "0000000000000000";
	loadPC <= '1';
	wait for CLK_PERIOD;
	loadPC <= '0';
	wait for CLK_PERIOD;
	
	Z <= "0000000000000001";
	loadPC <= '1';
	wait for CLK_PERIOD;
	loadPC <= '0';	
	wait for CLK_PERIOD;
	
	Z <= "0000000000000010";
	loadPC <= '1';
	wait for CLK_PERIOD;
	loadPC <= '0';	
	wait for CLK_PERIOD;
	
	Z <= "0000000000000011";
	loadPC <= '1';
	wait for CLK_PERIOD;
	loadPC <= '0';	
	wait for CLK_PERIOD;
	
	modeAddZA <= "00";
	wait for CLK_PERIOD;
	
	
	--------------------------------
	modeAddZA <= "11";
	A <= "0000000000000000";
	loadPC <= '1';
	wait for CLK_PERIOD;
	loadPC <= '0';
	wait for CLK_PERIOD;
	
	A <= "0000000000000001";
	loadPC <= '1';
	wait for CLK_PERIOD;
	loadPC <= '0';	
	wait for CLK_PERIOD;
	
	A <= "0000000000000010";
	loadPC <= '1';
	wait for CLK_PERIOD;
	loadPC <= '0';	
	wait for CLK_PERIOD;
	
	A <= "0000000000000011";
	loadPC <= '1';
	wait for CLK_PERIOD;
	loadPC <= '0';	
	wait for CLK_PERIOD;
	
	modeAddZA <= "00";
	wait for CLK_PERIOD;
	
	
	--------------------------------
	modeAddZA <= "00";	
	mode12K <= "00";
	loadPC <= '1';
	wait for CLK_PERIOD;
	loadPC <= '0';
	wait for CLK_PERIOD;
	
	mode12K <= "01";
	loadPC <= '1';
	wait for CLK_PERIOD;
	loadPC <= '0';	
	wait for CLK_PERIOD;
	
	mode12K <= "00";
	loadPC <= '1';
	wait for CLK_PERIOD;
	loadPC <= '0';	
	wait for CLK_PERIOD;
	
	mode12K <= "01";
	loadPC <= '1';
	wait for CLK_PERIOD;
	loadPC <= '0';	
	wait for CLK_PERIOD;
	

	modeAddZA <= "01";
	mode12K <= "00";
	loadPC <= '1';
	wait for CLK_PERIOD;
	loadPC <= '0';
	wait for CLK_PERIOD;
	
	mode12K <= "01";
	loadPC <= '1';
	wait for CLK_PERIOD;
	loadPC <= '0';	
	wait for CLK_PERIOD;
	
	mode12K <= "00";
	loadPC <= '1';
	wait for CLK_PERIOD;
	loadPC <= '0';	
	wait for CLK_PERIOD;
	
	mode12K <= "01";
	loadPC <= '1';
	wait for CLK_PERIOD;
	loadPC <= '0';	
	wait for CLK_PERIOD;
	
	
	--------------------------------
	modeAddZA <= "00";
	mode12K <= "10";
	
	K <= "0000000000000100";	
	loadPC <= '1';
	wait for CLK_PERIOD;
	loadPC <= '0';
	wait for CLK_PERIOD;

	K <= "0000000000001000";
	loadPC <= '1';
	wait for CLK_PERIOD;
	loadPC <= '0';	
	wait for CLK_PERIOD;
	
	mode12K <= "11";
	K <= "0000000000000100";
	loadPC <= '1';
	wait for CLK_PERIOD;
	loadPC <= '0';	
	wait for CLK_PERIOD;
	
	K <= "0000000000001000";
	loadPC <= '1';
	wait for CLK_PERIOD;
	loadPC <= '0';	
	wait for CLK_PERIOD;
	

	modeAddZA <= "01";
	mode12K <= "10";
	
	K <= "0000000000000100";
	loadPC <= '1';
	wait for CLK_PERIOD;
	loadPC <= '0';
	wait for CLK_PERIOD;
	
	K <= "0000000000000100";
	loadPC <= '1';
	wait for CLK_PERIOD;
	loadPC <= '0';	
	wait for CLK_PERIOD;
	
	mode12K <= "11";
	K <= "0000000000001000";
	loadPC <= '1';
	wait for CLK_PERIOD;
	loadPC <= '0';	
	wait for CLK_PERIOD;
	
	K <= "0000000000001000";
	loadPC <= '1';
	wait for CLK_PERIOD;
	loadPC <= '0';	
	wait for CLK_PERIOD;	


	
	wait for 100 ns;
	assert false report "end of simulation" severity failure;
	wait;

end process;

end architecture;