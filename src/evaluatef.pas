unit EVALUATEF;

interface

    uses CRT, ASTF, PARSERF, LEXERF, STRING_VIEWF, TOKENIZERF;

    procedure evaluate_user_input(input: string);

implementation


function evaluate(left, right: integer; op: string): integer;

    begin   
        case op of 
            '+': evaluate := left + right;
            '*': evaluate := left * right;
            '/': evaluate := left div right;
            '-': evaluate := left - right;
        end;
    end;

function eval(root: node_t): integer;

    begin
        if (root = NIL) then 
            begin
                eval := 0;
                exit(); 
            end;
        
        if (root^.kind = INTEGER_LITERAL) then 
            begin 
                eval := root^.value;
                exit();
            end;
        
        eval := evaluate(eval(root^.left), eval(root^.right), root^.op);
    end;

procedure evaluate_user_input(input: string);

    var     
        sv: string_view;
        tokens: token_list;
        parser: parser_t;
        root: node_t;
    
    begin
        case input of 
            'q':
                exit();
            'clear':
                begin 
                    clrscr();
                    exit();
                end;
        end;

        sv := convert_string_to_sv(input);
        
        tokens := lex(sv);
        if (tokens = NIL) then exit();

        parser := parser_init(tokens);
        root := parse(parser);

        if (root = NIL) then exit();
        
        writeln(eval(root));
        
        parser_remove(parser);
        tree_remove(root);
    end;

begin 
end.