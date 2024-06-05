`timescale 1ns/1ns

`define	READ_FROM_FILE		// comment this line if you have problem reading from files 

module single_cycle_mips__tb_isort;

	reg clk = 1;
	always @(clk) clk <= #5 ~clk;

	reg reset;
	initial begin
		reset = 1;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		#1;
		reset = 0;
	end
	
	reg [ 8:0] err_exp = 0;
	reg [ 8:0] err_unsorted = 0;
	reg [31:0] exp_sorted_num [0:95];

	initial begin
		`ifdef READ_FROM_FILE
			$readmemh("E:\\Sharif University of Technology\\4th semester\\Computer Architecture and Microprocessor\\Lab\\7 Single Cycle\\tb__isort\\isort32.hex", cpu.imem.mem_data);
		`endif 
	end
	
	initial begin
		`ifdef READ_FROM_FILE
			$readmemh("E:\\Sharif University of Technology\\4th semester\\Computer Architecture and Microprocessor\\Lab\\7 Single Cycle\\tb__isort\\exp_sorted_numbers.hex", exp_sorted_num);
		`endif
	end
		
	parameter end_pc = 32'h78;		// you might need to change end_pc

	integer i;
	always @(cpu.PC)
		if(cpu.PC == end_pc) begin
         #1;
			for(i=0; i<96; i=i+1) begin
				$write("%x ", cpu.dmem.mem_data[32+i]);
				if(((i+1) % 16) == 0)
					$write("\n");
			end
			for(i=0; i<96; i=i+1) begin
				if (cpu.dmem.mem_data[32+i] < cpu.dmem.mem_data[32+i+1] ||
					cpu.dmem.mem_data[32+i] === 1'bx )
					err_unsorted = err_unsorted + 1;
				if (cpu.dmem.mem_data[32+i] !== exp_sorted_num[i]) begin
					$display("================\n");
					$display(cpu.dmem.mem_data[32+i],"\n");
					$display(exp_sorted_num[i],"\n");
					err_exp = err_exp + 1;
				end
			end
			
			if (err_unsorted)
				$write("\n\n\n %d Numbers are Not Sorted!!!!!!\n", err_unsorted);
			else
				$write("\n\n\n PASS1, All Sorted!\n");
			
			if (err_exp)
				$write("\n Bad!!!!! %d unexpected Numbers found:\n", err_exp);
			else
				$write("\n Pass2, Output Matches the expected Numbers!\n");
			
         if ($time() > 258400)
            $write("\n Hay Hay Hay, It took more than enough to complete !!!\n\n\n");

			$stop;
		end

   single_cycle_mips cpu(
      .clk  ( clk   ),
      .reset( reset )
   );

endmodule

