unit TOKENIZERF;

interface 

    uses STRING_VIEWF, PTYPEF;

    type 
        TOKEN_KIND = (LEFT_PAR, RIGHT_PAR, OPERATION, INTEGER_LITERAL, END_TOKEN);

        token_t = ^token_type;

        token_type = record 
            value: string;
            kind: TOKEN_KIND;
            next: token_t;
        end;


        token_list = ^token_list_type;
        token_list_type = record 
            head, tail: token_t;
        end;
    
    function token_init(value: string; kind: TOKEN_KIND): token_t;
    function get_next_token(var sv: string_view): token_t;


    function isleftpar_type(token: token_t): boolean;
    function isrightpar_type(token: token_t): boolean;

    function tokens_init(): token_list;
    procedure add_token(tokens: token_list; token: token_t);
    
    procedure write_tokens(tokens: token_list);

    procedure remove_tokens(var tokens: token_list);

implementation

function token_init(value: string; kind: TOKEN_KIND): token_t;

    var result: token_t;

    begin
        new(result);
        result^.value := value;
        result^.kind := kind;
        result^.next := NIL;
        token_init := result;
        result := NIL; 
    end;

function get_par_type(c: char): TOKEN_KIND;

    begin
        case c of 
            '(': 
                get_par_type := LEFT_PAR;
            ')':
                get_par_type := RIGHT_PAR;
        end; 
    end;

function get_token_type(token: token_t): TOKEN_KIND;

    begin
        get_token_type := token^.kind; 
    end;

function isleftpar_type(token: token_t): boolean;

    begin
        isleftpar_type := (get_token_type(token) = LEFT_PAR);
    end;

function isrightpar_type(token: token_t): boolean;

    begin
        isrightpar_type := (get_token_type(token) = RIGHT_PAR); 
    end;

function get_next_token(var sv: string_view): token_t;

    var buffer: string;

    begin

        if (isoperation(sv_peek(sv))) then 
            begin
                get_next_token := token_init(sv_consume(sv), OPERATION);
                exit(); 
            end;
                    
        if (ispar(sv_peek(sv))) then 
            begin 
                get_next_token := token_init(sv_peek(sv), get_par_type(sv_consume(sv)));
                exit(); 
            end;

        if (isnumber(sv_peek(sv))) then 
            begin 
                buffer := '';
                while ((not sv_end(sv)) and (isnumber(sv_peek(sv)))) do 
                    buffer := buffer + sv_consume(sv);
                
                get_next_token := token_init(buffer, INTEGER_LITERAL);
                exit();
            end;
        
        writeln('ERROR: UNEXPECTED TOKEN FOUND: ', sv_peek(sv));
        get_next_token := NIL;
    end;

function tokens_init(): token_list;

    var result: token_list;

    begin 
        new(result);
        result^.head := NIL;
        result^.tail := NIL;
        tokens_init := result;
        result := NIL;
    end;

procedure add_token(tokens: token_list; token: token_t);

    begin 
        if (tokens^.head = NIL) then 
            begin 
                tokens^.head := token;
                tokens^.tail := token;
            end
        else 
            begin 
                tokens^.tail^.next := token;
                tokens^.tail := token;
            end;
    end;


procedure remove_tokens(var tokens: token_list);

    var current: token_t;

    begin
        if (tokens = NIL) then 
            begin
                current := NIL;
                exit(); 
            end;

        while (tokens^.head <> NIL) do 
            begin
                current := tokens^.head;
                tokens^.head := current^.next;
                dispose(current); 
            end; 

        current := NIL;
        tokens^.tail := NIL;
        tokens := NIL;
    end;

procedure write_token(token: token_t);  

    begin
        if (token <> NIL) then 
            writeln(token^.kind, ' -> ', token^.value); 
    end;

procedure write_tokens(tokens: token_list);

    var current: token_t;

    begin 
        current := tokens^.head;

        while (current <> NIL) do 
            begin
                write_token(current);
                current := current^.next; 
            end;
    end;

begin 
end.