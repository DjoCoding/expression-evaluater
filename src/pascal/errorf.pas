unit ERRORF;

interface 

    procedure handle_error(err: string; value: char);
    procedure handle_error(err: string);

implementation

procedure handle_error(err: string; value: char);

    begin
        writeln('ERROR: ', err, value); 
    end;

procedure handle_error(err: string);

    begin
        writeln('ERROR: ', err); 
    end;

begin 
end.