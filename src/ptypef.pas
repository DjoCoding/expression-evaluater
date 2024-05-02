unit PTYPEF;

interface

    function iswhitespace(c: char): boolean;
    function isnumber(c: char): boolean;
    function isoperation(c: char): boolean;
    function isnewline(c: char): boolean;
    function isleftpar(c: char): boolean;
    function isrightpar(c: char): boolean;
    function ispar(c: char): boolean;

    function to_integer(s: string): integer; 
    function to_string(num: integer): string; 

implementation

function iswhitespace(c: char): boolean;

    begin
        iswhitespace := (c = ' '); 
    end;

function isnewline(c: char): boolean;   

    begin
        isnewline := (INTEGER (c) = 10); 
    end;

function isnumber(c: char): boolean;

    begin
        isnumber := (c >= '0') and (c <= '9'); 
    end;

function isoperation(c: char): boolean;

    begin
        isoperation := (c = '+') or (c = '*') or (c = '-') or (c = '/'); 
    end;



function isleftpar(c: char): boolean;

    begin
        isleftpar := (c = '('); 
    end;
    
function isrightpar(c: char): boolean;
    
    begin 
        isrightpar := (c = ')');
    end;

function ispar(c: char): boolean;

    begin
        ispar := isleftpar(c) or isrightpar(c);
    end;
    
function to_integer(s: string): integer;  

    var result: integer;
        c: char;

    begin
        result := 0;     
        for c in s do 
            result := result * 10 + INTEGER(c) - INTEGER('0');
        
        to_integer := result;
    end;

function to_string(num: integer): string; 

    var buffer: string;

    begin
        buffer := '';
        
        if (num = 0) then buffer := '0'
        else 
            while (num <> 0) do 
                begin
                    buffer := CHAR(num mod 10 + INTEGER('0')) + buffer;
                    num := num div 10;  
                end;

        to_string := buffer;
    end;


begin 
end.
