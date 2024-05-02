unit ASTF;

interface

    uses PTYPEF, TOKENIZERF;

    const COUNT = 5;
        MAX_SIZE = 100;

    type 
        node_t = ^node_type;
        node_type = record 
            left, right: node_t;
            case KIND: TOKEN_KIND of 
                INTEGER_LITERAL: 
                    (value: integer);
                OPERATION:
                    (op: string);
        end;
        

    function INTEGER_node_init(value: integer): node_t;
    function OPERATION_node_init(op: string): node_t;

    procedure tree_remove(var root: node_t);
    procedure dfs(root: node_t);
    procedure print_tree(root: node_t);

    function get_string_value_of_node(node: node_t): string;

implementation

function INTEGER_node_init(value: integer): node_t;

    var result: node_t;

    begin
        new(result);
        result^.KIND := INTEGER_LITERAL;
        result^.value := value;
        result^.left := NIL;
        result^.right := NIL;
        INTEGER_node_init := result;
        result := NIL;
    end;

function OPERATION_node_init(op: string): node_t;

    var result: node_t;

    begin 
        new(result);
        result^.KIND := OPERATION;
        result^.op := op;
        result^.left := NIL;
        result^.right := NIL;
        OPERATION_node_init := result;
        result := NIL;
    end;

function get_string_value_of_node(node: node_t): string;

    begin
        case node^.kind of 
            INTEGER_LITERAL:
                get_string_value_of_node := to_string(node^.value);
            OPERATION: 
                case node^.op of 
                    '+': get_string_value_of_node := 'PLUS';
                    '*': get_string_value_of_node := 'MUL';
                end;
        end;
    end;

procedure tree_remove(var root: node_t);

    var left, right: node_t;

    begin
        if (root = NIL) then exit();

        left := root^.left;
        right := root^.right;

        dispose(root);
        root := NIL; 

        tree_remove(left);
        tree_remove(right);    
    end;

procedure dfs(root: node_t);

    begin
        if (root = NIL) then exit();

        if (root^.kind = INTEGER_LITERAL) then 
            writeln(root^.value)
        else 
            writeln(root^.op);

        dfs(root^.left);
        dfs(root^.right);
    end;

procedure print2D_tree(root: node_t; space: integer);

    var i: integer;

    begin
        if (root = NIL) then exit();

        space := space + count;

        print2D_tree(root^.right, space);

        writeln();

        for i := count to space do 
            write(' ');

        case root^.kind of 
            INTEGER_LITERAL: writeln(root^.value);
            OPERATION: writeln(root^.op);
        end;
    
        print2D_tree(root^.left, space);
    end;

procedure print_tree(root: node_t);

    begin
        print2D_tree(root, 0); 
        writeln();
    end;



begin 
end.