class Fysk::Parser

prechigh
  left MULTI DIVIDE
  left PLUS MINUS
  right BINDING_SYMBOL
preclow

token
  ARGUMENT_DECLARATION_BEGIN_END LAMBDA_EXPRESSION_PERIOD
  DEFINITION_SYMBOL
  BINDING_SYMBOL COMMA
  FUNCTION_APPLICATION_SYMBOL
  PLUS MINUS MULTI DIVIDE
  ARRAY_BEGIN ARRAY_END
  IDENT STRING NUMBER BOOL
  NEWLINE

rule
  program: expression newline_or_null_separator

  expression: lambda_expression
    | unary_expression
    | binary_expression
    | binding
    | function_application

  lambda_expression: argument_declaration newline_or_null_separator definition_or_expression_list LAMBDA_EXPRESSION_PERIOD
  argument_declaration: ARGUMENT_DECLARATION_BEGIN_END argument_list ARGUMENT_DECLARATION_BEGIN_END
  argument_list: IDENT argument_list
    |
  definition_or_expression_list: definition_or_expression comma_or_newline_separator definition_or_expression_list
    | expression
  definition_or_expression: definition | expression
  definition: IDENT DEFINITION_SYMBOL newline_or_null_separator expression

  unary_expression: array | IDENT | STRING | NUMBER | BOOL

  binary_expression: binary_expression_left_operand binary_operator expression
  binary_expression_left_operand: unary_expression | function_application
  binary_operator: PLUS | MINUS | MULTI | DIVIDE

  binding: IDENT BINDING_SYMBOL expression

  function_application: FUNCTION_APPLICATION_SYMBOL function function_application_parameter_list
  function: IDENT | lambda_expression
  function_application_parameter_list: unary_expression function_application_parameter_list
    |

  array: ARRAY_BEGIN array_item_list ARRAY_END
  array_item_list: expression comma_separator array_item_list
    | expression
    |

  comma_or_newline_separator: comma_separator | newline_separator
  newline_or_null_separator: newline_separator |
  comma_separator: COMMA
  newline_separator: NEWLINE
end

---- inner
require "strscan"

def parse(input)
  @scanner = StringScanner.new(input)

  do_parse
end

def next_token
  return [false, "$"] if @scanner.eos?

  case
  when v = @scanner.scan(/\A[ \t\f]*\//)
    [:ARGUMENT_DECLARATION_BEGIN_END, v.strip]
  when v = @scanner.scan(/\A\s*\./)
    [:LAMBDA_EXPRESSION_PERIOD, v.strip]
  when v = @scanner.scan(/\A[ \t\f]*:/)
    [:DEFINITION_SYMBOL, v.strip]
  when v = @scanner.scan(/\A[ \t\f]*'/)
    [:BINDING_SYMBOL, v.strip]
  when v = @scanner.scan(/\A[ \t\f]*,/)
    [:COMMA, v.strip]
  when v = @scanner.scan(/\A[ \t\f]*@/)
    [:FUNCTION_APPLICATION_SYMBOL, v.strip]
  when v = @scanner.scan(/\A[ \t\f]*\+/)
    [:PLUS, v.strip]
  when v = @scanner.scan(/\A[ \t\f]*-/)
    [:MINUS, v.strip]
  when v = @scanner.scan(/\A[ \t\f]*\*/)
    [:MULTI, v.strip]
  when v = @scanner.scan(/\A[ \t\f]+div\b/)
    [:DIVIDE, v.strip]
  when v = @scanner.scan(/\A[ \t\f]*\[/)
    [:ARRAY_BEGIN, v.strip]
  when v = @scanner.scan(/\A\s*\]/)
    [:ARRAY_END, v.strip]
  when v = @scanner.scan(/\A[ \t\f]*[a-zA-Z_]\w*\b/)
    [:IDENT, v.strip]
  when v = @scanner.scan(/\A[ \t\f]*"[^\r\n]*"/)
    [:STRING, v.strip]
  when v = @scanner.scan(/\A[ \t\f]*\d+/)
    [:NUMBER, v.strip]
  when v = @scanner.scan(/\A[ \t\f]*(?:true|false)/)
    [:BOOL, v.strip]
  when v = @scanner.scan(/\A[ \t\f]*[\r\n]+/)
    [:NEWLINE, v]
  when v = @scanner.scan(/\A\S*\b/)
    raise Racc::ParseError, "unknown token #{v.inspect}"
  end
end
