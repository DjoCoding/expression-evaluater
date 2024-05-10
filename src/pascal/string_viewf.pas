unit STRING_VIEWF;

interface 

    type 
        string_view = record 
            content: string;
            size: integer;
            current: integer;
        end;
    
    function convert_string_to_sv(s: string): string_view;
    function sv_peek(sv: string_view): char;
    function sv_consume(var sv: string_view): char;
    function sv_end(sv: string_view): boolean;


implementation

function convert_string_to_sv(s: string): string_view;

    var result: string_view;

    begin
        result.content := s;
        result.size := length(s);
        result.current := 1;

        convert_string_to_sv := result; 
    end;

function sv_peek(sv: string_view): char;

    begin
        sv_peek := sv.content[sv.current]; 
    end;

function sv_consume(var sv: string_view): char;

    begin   
        sv_consume := sv_peek(sv);
        inc(sv.current); 
    end;

function sv_end(sv: string_view): boolean;

    begin   
        sv_end := (sv.current = sv.size + 1); 
    end;

begin 
end.