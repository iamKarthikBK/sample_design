package testbench;

import sample_design :: * ;

module mk_testbench(Empty);
    Reg#(Bit#(2)) status <- mkReg(0);
    Ifc_sample_design dut <- mk_sample_design();
    rule start if (status == 0);
        dut.ma_start(32'hdeadaeef);
        $display("dut: observed %h at input monitor", 32'hdeadaeef);
        status <= 1;
    endrule
    rule done if (status == 1);
        dut.ma_wait();
        status <= 2;
        let temp <- dut.mav_stop();
        $display("dut: observed %h at output monitor", temp);
        $finish(0);
    endrule
endmodule: mk_testbench

endpackage: testbench