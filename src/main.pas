uses EVALUATEF;

procedure main();

    var input: string;

    begin
        repeat  
            write('> ');
            readln(input);
            evaluate_user_input(input);
        until (input = 'q'); 
    end;

begin
    main();
end.
    