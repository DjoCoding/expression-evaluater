unit PARSERF;

interface

    uses PTYPEF, ERRORF, TOKENIZERF, ASTF;

    type 
        parser_t = ^parser_type;
        parser_type = record 
            tokens: token_list;
            current: token_t;
        end;

    function parser_init(tokens: token_list): parser_t;
    function parser_peek(parser: parser_t): token_t;
    function parser_consume(parser: parser_t): token_t;
    function parser_end(parser: parser_t): boolean;

    function parse_addition(parser: parser_t): node_t;

    function parse(parser: parser_t): node_t;
    procedure parser_remove(var parser: parser_t);

implementation

function parser_init(tokens: token_list): parser_t;

    var result: parser_t;

    begin
        new(result);
        result^.tokens := tokens;
        
        if (tokens <> NIL) then
            result^.current := tokens^.head 
        else 
            result^.current := NIL;
        
        parser_init := result;
        result := NIL; 
    end;

function parser_peek(parser: parser_t): token_t;

    begin
        parser_peek := parser^.current; 
    end;

function parser_consume(parser: parser_t): token_t;
    
    begin 
        parser_consume := parser_peek(parser);
        parser^.current := parser^.current^.next;
    end;

function parser_end(parser: parser_t): boolean;

    begin
        parser_end := (parser^.current = NIL);
    end;

function ismultiplication(parser: parser_t): boolean;

    begin
        ismultiplication := (not parser_end(parser)) and ((parser_peek(parser)^.value = '*') or (parser_peek(parser)^.value = '/')); 
    end;

function isaddition(parser: parser_t): boolean;

    begin 
        isaddition := (not parser_end(parser)) and ((parser_peek(parser)^.value = '+') or (parser_peek(parser)^.value = '-')); 
    end;

function parse_value(parser: parser_t; kind: TOKEN_KIND): node_t;

    begin
        if (parser_end(parser)) then 
            begin
                writeln('EXPECTED TOKEN OF TYPE: ', kind, ' BUT END OF TOKENS FOUND!');
                parse_value := NIL;
                exit(); 
            end;
        
        if (parser_peek(parser)^.kind = kind) then 
            case kind of 
                INTEGER_LITERAL: 
                    begin 
                        parse_value := INTEGER_node_init(to_integer(parser_consume(parser)^.value));
                        exit();
                    end;
                OPERATION: 
                    begin 
                        parse_value := OPERATION_node_init(parser_consume(parser)^.value);
                        exit();
                    end;
            end;
        
        // IF IT'S NOT THE KIND WANTED THEN THROW AN ERROR!

        writeln('EXPECTED TOKEN OF KIND: ', KIND, ' BUT TOKEN OF KIND: ', parser_peek(parser)^.kind, ' FOUND!');
        parse_value := NIL;    
    end;

function parse_paren(parser: parser_t): node_t;

    var left, root, right: node_t;

    begin
        if (parser_end(parser)) then 
            begin
                parse_paren := NIL;
                exit(); 
            end;
        
        if (isleftpar_type(parser_peek(parser))) then 
            begin
                parser_consume(parser); // CONSUMING THE TOKEN '('
                
                left := parse_addition(parser);  // RECURSIVE CALL TO THE SAME FUNCTION TO PARSE OTHER PARENTHESES!


                // IF ERROR FOUND => LEFT = NIL;
                if (left = NIL) then 
                    begin
                        parse_paren := NIL;
                        exit(); 
                    end;

                while not ((parser_end(parser)) or (isrightpar_type(parser_peek(parser)))) do 
                    begin
                        // IF NO OPERATION FOUND, THEN IT SHOULD BE AN ERROR! 
                        root := parse_value(parser, OPERATION);

                        if (root = NIL) then 
                            begin
                                tree_remove(left);

                                parse_paren := NIL;
                                exit(); 
                            end;

                        // PARSING AN ADDITION => RE-CALLING THE PARSE_PAREN IN SOME STAGE OF THE CALL!
                        right := parse_addition(parser);

                        // IF SOME ERROR IS FOUND => RIGHT = NIL;
                        if (right = NIL) then 
                            begin
                                tree_remove(left);
                                tree_remove(root);

                                parse_paren := NIL;
                                exit();
                            end;
                        
                        root^.right := right;
                        root^.left := left;

                        left := root;
                    end;
                
                parser_consume(parser);
                parse_paren := left;
                exit();
            end;

        if (parser_peek(parser)^.kind = INTEGER_LITERAL) then 
            begin
                parse_paren := INTEGER_node_init(to_integer(parser_consume(parser)^.value));
                exit(); 
            end;
        
        writeln('EXPECTED INTGER_LITERAL BUT ', parser_peek(parser)^.value, ' FOUND');

        parse_paren := NIL; 

        left := NIL;
        root := NIL;
        right := NIL;
    end;

function parse_multiplication(parser: parser_t): node_t;

    var left, right, root: node_t;

    begin
        left := parse_paren(parser);

        if (left = NIL) then 
            begin 
                parse_multiplication := NIL;
                exit();
            end;

        while (ismultiplication(parser)) do 
            begin
                root := parse_value(parser, OPERATION);

                right := parse_paren(parser);

                if (right = NIL) then 
                    begin
                        tree_remove(left);
                        tree_remove(root);
                        parse_multiplication := NIL;
                        exit(); 
                    end;
                
                root^.right := right;
                root^.left := left;

                left := root;
            end;

        parse_multiplication := left;
        left := NIL;
        root := NIL;
        right := NIL;
    end;

function parse_addition(parser: parser_t): node_t;

    var left, root, right: node_t;

    begin 
        left := parse_multiplication(parser);

        if (left = NIL) then 
            begin
                parse_addition := NIL;
                exit(); 
            end;
        
        while (isaddition(parser)) do 
            begin
                root := parse_value(parser, OPERATION);

                right := parse_multiplication(parser);

                if (right = NIL) then 
                    begin
                        tree_remove(left);
                        tree_remove(root);
                        parse_addition := NIL;
                        exit(); 
                    end;
                
                root^.right := right;
                root^.left := left;

                left := root;
            end;

        parse_addition := left;
        left := NIL;
        root := NIL;
        right := NIL;
    end;

function parse(parser: parser_t): node_t;

    begin
        parse := parse_addition(parser); 
        if (not parser_end(parser)) then 
            begin
                writeln('EXPECTED OPERATION TOKEN BUT FOUND: ', parser_peek(parser)^.value);
                tree_remove(parse);
                exit(); 
            end;
    end;

// this will remove both the tokens and the parser!
procedure parser_remove(var parser: parser_t);

    begin
        remove_tokens(parser^.tokens);
        parser^.current := NIL;
        dispose(parser);
        parser := NIL; 
    end;


begin 
end.