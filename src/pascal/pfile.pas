unit PFILE;

interface 

    function get_file_size(const filename: string): integer;
    function get_file_content(const filename: string): string;


implementation

function get_file_size(const filename: string): integer;

    var count: integer;
        c: char;
        stream: TEXT;

    begin
        count := 0;

        assign(stream, filename);
        reset(stream);

        while (not eof(stream)) do 
            begin
                read(stream, c);
                inc(count); 
            end;
        
        get_file_size := count;

        close(stream);
    end;

function get_file_content(const filename: string): string;

    var content: string;
        c: char;    
        stream: TEXT;

    begin 
        assign(stream, filename);
        reset(stream);
        content := '';

        while (not eof(stream)) do 
            begin  
                read(stream, c);            
                content := content + c;
            end;
        
        close(stream);

        get_file_content := content;
    end;

begin 
end.