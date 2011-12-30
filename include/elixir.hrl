-define(ELIXIR_WRAP_CALL(Line, Module, Method, Args),
  { call, Line,
    { remote, Line, { atom, Line, Module }, { atom, Line, Method} },
    Args
  }).

-define(ELIXIR_ATOM_CONCAT(Atoms), list_to_atom(lists:concat(Atoms))).

-record(elixir_scope, {
  assign=false,                             %% when true, new variables can be defined in that subtree
  guard=false,                              %% when true, we are inside a guard
  noref=false,                              %% when true, don't resolve references
  noname=false,                             %% when true, don't add new names. used by try.
  macro=[],                                 %% the current macro being transformed
  function=[],                              %% the current function
  module={0,nil},                           %% the current module
  vars=dict:new(),                          %% a dict of defined variables and their alias
  temp_vars=[],                             %% a list of all variables defined in a particular assign
  clause_vars=dict:new(),                   %% a dict of all variables defined in a particular clause
  counter=0,                                %% a counter for the variables defined
  filename="nofile",                        %% the current scope filename
  refer=[                                   %% an orddict with references by new -> old names
    {'::Elixir::Macros','::Elixir::Macros'}
  ],
  imports=[                                 %% a list with macros imported by module
    {
      '::Elixir::Macros',
      try
        '::Elixir::Macros':'__macros__'()
      catch
        error:undef -> []
      end
    }
  ],
  scheduled=[]}).                           %% scheduled modules to be loaded