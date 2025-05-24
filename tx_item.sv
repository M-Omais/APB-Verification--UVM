class tx_item extends uvm_sequence_item;
    `uvm_object_utils(tx_item)
    function new(string name="tx_item");
        super.new(name);        
    endfunction //new()

    rand bit [7:0] data_in, data_out;    // Random input data
    bit write_en, read_en;         // Random control signals
    bit full, empty;

    virtual function void do_copy(uvm_object rhs);
        tx_item tx_rhs;
        if (!$cast(tx_rhs, rhs)) begin
            `uvm_fatal(get_type_name(), "ILLEGAL ARGUMENT");
        end
        super.do_copy(rhs);
        this.data_in = tx_rhs.data_in;
        this.data_out = tx_rhs.data_out;
        this.write_en = tx_rhs.write_en;
        this.read_en = tx_rhs.read_en;
        this.full = tx_rhs.full;
        this.empty = tx_rhs.empty;
    endfunction

    virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
        tx_item tx_rhs;
        if (!$cast(tx_rhs, rhs)) begin
            `uvm_fatal(get_type_name(), "ILLEGAL ARGUMENT");
        end
        return (super.do_compare(rhs, comparer)) &&
               (data_in === tx_rhs.data_in) && 
               (data_out === tx_rhs.data_out) && 
               (write_en === tx_rhs.write_en) && 
               (read_en === tx_rhs.read_en) && 
               (full === tx_rhs.full) && 
               (empty === tx_rhs.empty); 
    endfunction

    virtual function string convert2string();
        string s;
        
        // Call the base class convert2string first, if it exists
        s = super.convert2string(); 
        
        // Concatenate the formatted string properly
        s = $sformatf("%s\n tx_item values are :", s);  // Adds a header to the string
        
        s = $sformatf("%s\n  data_in : (0x%0x)", s, data_in);   // Format and append data_in
        s = $sformatf("%s\n  data_out : (0x%0x)", s, data_out); // Format and append data_out
        s = $sformatf("%s\n  write_en : (0b%b)", s, write_en); // Format and append write_en
        s = $sformatf("%s\n  read_en : (0b%b)", s, read_en);   // Format and append read_en
        s = $sformatf("%s\n  full : (0b%b)", s, full);         // Format and append full flag
        s = $sformatf("%s\n  empty : (0b%b)", s, empty);       // Format and append empty flag
        
        return s;
    endfunction


    virtual function void do_print(uvm_printer printer); 
        printer.m_string = convert2string(); 
    endfunction

    virtual function void do_pack(uvm_packer packer); 
        // NOT IMPLEMENTED
    endfunction 

    virtual function void do_unpack(uvm_packer packer); 
        // NOT IMPLEMENTED
    endfunction 

    virtual function void do_record(uvm_recorder recorder); 
        // NOT IMPLEMENTED
    endfunction

endclass //tx_item extends uvm_sequence_item