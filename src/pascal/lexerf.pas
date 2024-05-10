unit LEXERF;

interface 

    uses PTYPEF, STRING_VIEWF, TOKENIZERF;

    function lex(sv: string_view): token_list;

implementation

function lex(sv: string_view): token_list;

    var tokens: token_list;
        current: token_t;

    begin
        tokens := tokens_init();
        
        while (not sv_end(sv)) do 
            if (isnewline(sv_peek(sv)) or iswhitespace(sv_peek(sv))) then 
                sv_consume(sv)
            else 
                begin 
                    current := get_next_token(sv);
                    if (current = NIL) then 
                        begin
                            remove_tokens(tokens);
                            break;
                        end;
                    add_token(tokens, current);
                end;
        
        lex := tokens;
        current := NIL;
    end;

begin 
end.