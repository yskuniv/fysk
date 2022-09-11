class Fysk::Parser

token LAMBDA_EXPRESSION_PERIOD ARGUMENT_DECLARATION_BEGIN_END DEFINITION_SYMBOL ARRAY_BEGIN ARRAY_END BINARY_OPERATOR BINDING_SYMBOL IDENT STRING NUMBER BOOL COMMA WHITESPACE NEWLINE

rule
  program: expression

  expression: lambda_expression
    | unary_expression
    | binary_operation_expression
    | binding_expression
    | function_application_expression

  lambda_expression: ARGUMENT_DECLARATION_BEGIN_END argument_list ARGUMENT_DECLARATION_BEGIN_END definition_list comma_or_newline_separator expression_list LAMBDA_EXPRESSION_PERIOD

  argument_list: IDENT whitespace_separator argument_list
    | IDENT
    |

  definition_list: definition comma_or_newline_separator definition_list
    | definition
    |
  definition: IDENT DEFINITION_SYMBOL expression

  expression_list: expression comma_or_newline_separator expression_list
    | expression

  unary_expression: array | STRING | NUMBER | BOOL

  array: ARRAY_BEGIN array_item_list ARRAY_END
  array_item_list: expression comma_separator array_item_list
    | expression
    |

  binary_operation_expression: unary_expression BINARY_OPERATOR unary_expression

  binding_expression: IDENT BINDING_SYMBOL expression

  function_application_expression: IDENT function_application_parameter_list
  function_application_parameter_list: expression whitespace_separator function_application_parameter_list
    | expression
    |

  comma_or_newline_separator: comma_separator | newline_separator
  comma_separator: COMMA
  whitespace_separator: WHITESPACE
  newline_separator: NEWLINE
end

---- inner
def parse(tokens)
  @q = tokens

  do_parse
end

def next_token
  @q.shift
end
