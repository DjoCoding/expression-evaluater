unit GRAPHF;

interface 

    uses ASTF;

    procedure generate_graph(root: node_t);

implementation

procedure get_graph(root: node_t);

    begin
        if (root = NIL) then exit();

        
        if (root^.left <> NIL) then 
            writeln(get_string_value_of_node(root), ' -- ', get_string_value_of_node(root^.left));
        
        if (root^.right <> NIL) then 
            writeln(get_string_value_of_node(root), ' -- ', get_string_value_of_node(root^.right));

        
        get_graph(root^.left);
        get_graph(root^.right);
    end;

procedure generate_graph(root: node_t);

    begin
        writeln('digraph {');
        get_graph(root);
        writeln('}'); 
    end;

begin 
end.