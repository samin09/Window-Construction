% Types of windows to be produced
enum Types_of_windows = { Circular, Rectangle, Square };  

% cost for each type of window circular, rectangular, square
array[Types_of_windows] of int: cost = [10000, 15000, 20000];

% The length(m), breadth(m), area(sq. m), budget(tk), time(hours) parameters given for constructing window
enum Resources = { Length, Breadth, Area, Budget, Time};

% The highest capacity a customer can ask for
array[Resources] of int: capacity = [4000, 2000, 8000, 5000, 10]; 

% customer's constraints
array[Types_of_windows, Resources] of int: consumption = [| 100, 100, 31416, 500, 5
              | 200, 100,2000 , 300, 3
              | 200, 200, 4000 , 200, 8|]; 

%consumption can't be greater than resources
constraint assert(forall (r in Resources, p in Types_of_windows) 
           (consumption[p,r] >= 0), "Error: negative consumption");

% bound on number of Types_of_windows
int: mproducts = max (p in Types_of_windows) 
                     (min (r in Resources where consumption[p,r] > 0) 
                          (capacity[r] div consumption[p,r]));

% Variables: how much should we make of each window type
array[Types_of_windows] of var 0..mproducts: produce;
array[Resources] of var 0..max(capacity): used;

% Production cannot use more than the available Resources:
constraint forall (r in Resources) (     
      used[r] = sum (p in Types_of_windows)(consumption[p, r] * produce[p]) 
);

constraint forall (r in Resources) (     
      used[r] <= capacity[r]
);    

% Maximum number of windows that can be produced within this budget
solve maximize sum (p in Types_of_windows) (cost[p]*produce[p]);

output [ "\(p) = \(produce[p]);\n" | p in Types_of_windows ] ++
       [ "\(r) = \(used[r]);\n" | r in Resources ];
