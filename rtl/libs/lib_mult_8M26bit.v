

module lib_mult8M26 (
				a,
				b,

				x
				);

parameter Na = 8;		// Input bit width for "a"
parameter Nb = 26;		// Input bit width for "b"
parameter Nx = Na + Nb;	// Output bit width for "x"

input	[Na-1:0]	a;
input	[Nb-1:0]	b;

output	[Nx-1:0]	x;

/********************************************************************/
/*                        Original Function							*/
/********************************************************************/

	function [Nx-1:0]	S_MUL;
		input [Na-1:0]	a;
		input [Nb-1:0]	b;
		reg [Na-1:0]	ABSa;
		reg [Nb-1:0]	ABSb;
		reg				SIGN;
		reg [Nx-1:0]	MUL;
		begin
		//absolute element for "a"
			if(a[Na-1])
				ABSa = ~a + 1;	//negative entry
			else
				ABSa = a;		//positive entry
		//absolute element for "b"
			if(b[Nb-1])
				ABSb = ~b + 1;	//negative entry
			else
				ABSb = b;		//positive entry
		//absolute multiplication
			MUL = ABSa * ABSb;
		//sign judgment
			SIGN = a[Na-1]^b[Nb-1];
			if(SIGN)
				S_MUL = ~MUL + 1;	//negative entry
			else
				S_MUL = MUL;		//positive entry
		end
	endfunction

	assign x = S_MUL(a,b);


endmodule

