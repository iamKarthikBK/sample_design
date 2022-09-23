package sample_design;

/*doc:interface: provides the interface for sample_design module*/
interface Ifc_sample_design;
    method Action ma_start(Bit#(32) inp_config);
    method Action ma_wait();
    method ActionValue#(Bit#(32)) mav_stop;
endinterface: Ifc_sample_design

/*doc:enum: defines the state enumeration for sample_design module*/
typedef enum {IDLE, COMPUTE, DONE} StateEnumerationType deriving (Bits, Eq);

/*doc:module: implements the sample_design module*/
module mk_sample_design(Ifc_sample_design);

    /*doc:reg: holds a 32-bot value used for computation*/
    Reg#(Bit#(32)) rg_data <- mkReg(0);

    /*doc:reg: holds the state for sample_design module*/
    Reg#(StateEnumerationType) rg_state <- mkReg(IDLE);

    /*doc:rule: adds 1 to rg_data until the value hits 32'hdeadbeef*/
    rule rl_add_one if (rg_state == COMPUTE && rg_data <= 32'hdeadbeef);
        if (rg_data == 32'hdeadbeef) rg_state <= DONE;
        else
        begin
            rg_data <= rg_data + 1;
            $display("sample_design: COMPUTE: rg_data = %h", rg_data + 1);
        end
    endrule: rl_add_one

    method Action ma_start(Bit#(32) inp_config) if (rg_state == IDLE);
        rg_data <= inp_config;
        rg_state <= COMPUTE;
    endmethod: ma_start

    method Action ma_wait() if (rg_state == IDLE || rg_state == DONE);
        noAction;
    endmethod: ma_wait

    method ActionValue#(Bit#(32)) mav_stop () if (rg_state == DONE);
        rg_state <= IDLE;
        return rg_data;
    endmethod: mav_stop
endmodule: mk_sample_design

endpackage: sample_design