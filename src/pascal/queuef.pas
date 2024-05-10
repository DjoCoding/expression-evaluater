unit QUEUEF;

interface 

    uses ASTF;

    const MAX_SIZE = 100;
    
    type 
        queue_t = record 
            nodes: array[1..MAX_SIZE] of node_t;
            back: integer;
        end;

    function queue_init(): queue_t;
    function is_empty(queue: queue_t): boolean;
    function is_full(queue: queue_t): boolean;
    procedure enqueue(var queue: queue_t; node: node_t);
    function dequeue(var queue: queue_t): node_t;

implementation

function queue_init(): queue_t;

    begin
        queue_init.back := 0; 
    end;

function is_empty(queue: queue_t): boolean;

    begin 
        is_empty := (queue.back = 0);
    end;
    
function is_full(queue: queue_t): boolean;

    begin
        is_full := (queue.back = MAX_SIZE); 
    end;


procedure enqueue(var queue: queue_t; node: node_t);

    begin 
        if (is_full(queue)) then    
            begin 
                writeln('[QUEUE] QUEUE IS FULL!');
                exit();
            end;
        
        inc(queue.back);
        queue.nodes[queue.back] := node;
    end;

    
function dequeue(var queue: queue_t): node_t;

    var i: integer;

    begin 
        dequeue := queue.nodes[1];
        dec(queue.back);

        for i := 1 to queue.back do 
            queue.nodes[i] := queue.nodes[i + 1];
    end;


begin 
end.