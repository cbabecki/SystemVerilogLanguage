// This grammar was converted from the IEEE 1800-2012 LRM specification (Annex A) to an ANTLR4-style EBNF
// https://standards.ieee.org/getieee/1800/download/1800-2012.pdf

grammar SystemVerilog2012;

// A.1 - Source Text
// A.1.1 - Library Source Text
// Not implementing this section as we're only targeting SV source text


// A.1.2 SystemVerilog Source Text
source_text : (timeunits_declaration)? (description)*
            ;

description : module_declaration
            // | udp_declaration
            | interface_declaration
            | program_declaration
            | package_declaration
            | attribute_instance* package_item
            | attribute_instance* bind_directive
            | config_declaration
            ;

module_nonansi_header : attribute_instance* module_keyword lifetime? module_identifier
                        package_import_declaration* parameter_port_list? list_of_ports ';'
                      ;

module_ansi_header : attribute_instance* module_keyword lifetime? module_identifier
                     package_import_declaration* parameter_port_list? list_of_port_declarations? ';'
                   ;

module_declaration : module_nonansi_header timeunits_declaration? module_item* Tendmodule (':' module_identifier)?
                   | module_ansi_header timeunits_declaration? non_port_module_item* Tendmodule (':' module_identifier)?
                   | attribute_instance* module_keyword lifetime? module_identifier '(' '.*' ')' ';'
                        timeunits_declaration? module_item* Tendmodule (':' module_identifier)?
                   | TExtern module_nonansi_header
                   | TExtern module_ansi_header
                   ;

module_keyword : TModule
               | TMacromodule
               ;

interface_declaration : interface_nonansi_header timeunits_declaration? interface_item*
                        TEndinterface (':' interface_identifier)?
                      | interface_ansi_header timeunits_declaration? non_port_interface_item*
                        TEndinterface (':' interface_identifier)?
                      | attribute_instance* TInterface interface_identifier '(' '.*' ')' ';'
                        timeunits_declaration? interface_item* TEndinterface (':' interface_identifier)?
                      | TExtern interface_nonansi_header
                      | TExtern interface_ansi_header
                      ;

interface_nonansi_header : attribute_instance* TInterface lifetime? interface_identifier
                           package_import_declaration* parameter_port_list? list_of_ports ';'
                         ;

interface_ansi_header : attribute_instance? TInterface lifetime? interface_identifier
                        package_import_declaration* parameter_port_list? list_of_port_declarations? ';'
                      ;

program_declaration : program_nonansi_header timeunits_declaration? program_item*
                      TEndprogram (':' program_identifier)?
                    | program_ansi_header timeunits_declaration? non_port_program_item*
                      TEndprogram (':' program_identifier)?
                    | attribute_instance* TProgram program_identifier '(' '.*' ')' ';' ';'
                      timeunits_declaration? program_item* TEndprogram (':' program_identifier)?
                    | TExtern program_nonansi_header
                    | TExtern program_ansi_header
                    ;

program_nonansi_header : attribute_instance* TProgram lifetime? program_identifier package_import_declaration*
                         parameter_port_list? list_of_ports ';'
                       ;

program_ansi_header : attribute_instance* TProgram lifetime? program_identifier package_import_declaration*
                      parameter_port_list? list_of_port_declarations? ';'
                    ;

checker_declaration : TChecker checker_identifier ('(' checker_port_list? ')')? ';'
                      (attribute_instance* checker_or_generate_item)* TEndchecker (':' checker_identifier)?
                    ;

class_declaration : TVirtual? TClass lifetime? class_identifier parameter_port_list?
                    (TExtends class_type ('(' list_of_arguments ')')?)?
                    (TImplements interface_class_type (',' interface_class_type)*)? ';' class_item*
                    TEndclass (':' class_identifier)?
                  ;

interface_class_type : ps_class_identifier parameter_value_assignment?
                     ;

interface_class_declaration : TInterface TClass class_identifier parameter_port_list?
                              (TExtends interface_class_type (',' interface_class_type)*)? ';' interface_class_item*
                              TEndclass (':' class_identifier)?
                            ;

interface_class_item : type_declaration
                     | attribute_instance* interface_class_method
                     | local_parameter_declaration ';'
                     | parameter_declaration ';'
                     | ';'
                     ;

interface_class_method : TPure TVirtual method_prototype ';'
                       ;

package_declaration : attribute_instance* TPackage lifetime? package_identifier ';' timeunits_declaration?
                      (attribute_instance* package_item)* TEndpackage (':' package_identifier)?
                    ;

timeunits_declaration : TTimeunit time_literal ('/' time_literal)? ';'
                      | TTimeprecision time_literal ';'
                      | TTimeunit time_literal ';' TTimeprecision time_literal ';'
                      | TTimeprecision time_literal ';' TTimeunit time_literal ';'
                      ;


// A.1.3 - Module Ports
parameter_port_list : '#' '(' list_of_param_assignments (',' parameter_port_declaration)* ')'
                    | '#' '(' parameter_port_declaration (',' parameter_port_declaration)* ')'
                    | '#' '(' ')'
                    ;

parameter_port_declaration : parameter_declaration
                           | local_parameter_declaration
                           | data_type list_of_param_assignments
                           | TType list_of_type_assignments
                           ;

list_of_ports : '(' port (',' port)* ')'
              ;

list_of_port_declarations : '(' (attribute_instance* ansi_port_declaration
                            (',' attribute_instance* ansi_port_declaration)*)? ')'
                          ;

port_declaration : attribute_instance* inout_declaration
                 | attribute_instance* input_declaration
                 | attribute_instance* output_declaration
                 | attribute_instance* ref_declaration
                 | attribute_instance* interface_port_declaration
                 ;

port : port_expression
     | '.' port_identifier '(' port_expression ')'
     ;

port_expression : (port_reference (',' port_reference)*)*
                ;

port_reference : port_identifier constant_select
               ;

port_direction : TInput
               | TOutput
               | TInout
               | TRef
               ;

net_port_header : port_direction? net_port_type
                ;

variable_port_header : port_direction? variable_port_type
                     ;

interface_port_header : interface_identifier ('.' modport_identifier)?
                      | TInterface ('.' modport_identifier)?
                      ;

ansi_port_declaration : (net_port_header | interface_port_header) port_identifier unpacked_dimension*
                        ('=' constant_expression)?
                      | variable_port_header? port_identifier variable_dimension* ('=' constant_expression)?
                      | port_direction? '.' port_identifier '(' expression? ')'
                      ;


// A.1.4 - Module Items
elaboration_system_task : '$fatal' ('(' finish_number (',' list_of_arguments)? ')')? ';'
                        | '$error' ('(' list_of_arguments ')')? ';'
                        | '$warning' ('(' list_of_arguments ')')? ';'
                        | '$info' ('(' list_of_arguments ')')? ';'
                        ;

finish_number : '0'
              | '1'
              | '2'
              ;

module_common_item : module_or_generate_item_declaration
                   | interface_instantiation
                   | program_instantiation
                   | assertion_item
                   | bind_directive
                   | continuous_assign
                   | net_alias
                   | initial_construct
                   | final_construct
                   | always_construct
                   | loop_generate_construct
                   | conditional_generate_construct
                   | elaboration_system_task
                   ;

module_item : port_declaration ';'
            | non_port_module_item
            ;

module_or_generate_item : attribute_instance* parameter_override
                        // | attribute_instance* gate_instantiation
                        // | attribute_instance* udp_instantiation
                        | attribute_instance* module_instantiation
                        | attribute_instance* module_common_item
                        ;

module_or_generate_item_declaration : package_or_generate_item_declaration
                                    | genvar_declaration
                                    | clocking_declaration
                                    | TDefault TClocking clocking_identifier ';'
                                    | TDefault TDisable TIff expression_or_dist ';'
                                    ;

non_port_module_item : generate_region
                     | module_or_generate_item
                     // | specify_block
                     | attribute_instance* specparam_declaration
                     | program_declaration
                     | module_declaration
                     | interface_declaration
                     | timeunits_declaration
                     ;

parameter_override : TDefparam list_of_defparam_assignments ';'
                   ;

bind_directive : TBind bind_target_scope (':' bind_target_instance_list)? bind_instantiation ';'
               | TBind bind_target_instance bind_instantiation ';'
               ;

bind_target_scope : module_identifier
                  | interface_identifier
                  ;

bind_target_instance : hierarchical_identifier constant_bit_select
                     ;

bind_target_instance_list : bind_target_instance (',' bind_target_instance)*
                          ;

bind_instantiation : program_instantiation
                   | module_instantiation
                   | interface_instantiation
                   | checker_instantiation
                   ;


// A.1.5 - Configuration
config_declaration : TConfig config_identifier ';' (local_parameter_declaration ';')* design_statement
                     config_rule_statement* TEndconfig (':' config_identifier)?
                   ;

design_statement : TDesign ((library_identifier '.')? cell_identifier)* ';'
                 ;

config_rule_statement : default_clause liblist_clause ';'
                      | inst_clause liblist_clause ';'
                      | inst_clause use_clause ';'
                      | cell_clause liblist_clause ';'
                      | cell_clause use_clause ';'
                      ;

default_clause : TDefault
               ;

inst_clause : TInstance inst_name
            ;

inst_name : topmodule_identifier ('.' instance_identifier)*
          ;

cell_clause : TCell (library_identifier '.')? cell_identifier
            ;

liblist_clause : TLiblist library_identifier*
               ;

use_clause : TUse (library_identifier '.')? cell_identifier (':' TConfig)?
           | TUse named_parameter_assignment (',' named_parameter_assignment)* (':' TConfig)?
           | TUse (library_identifier '.')? cell_identifier named_parameter_assignment
             (',' named_parameter_assignment)* (':' TConfig)?
           ;


// A.1.6 - Interface Items
interface_or_generate_item : attribute_instance* module_common_item
                           | attribute_instance* modport_declaration
                           | attribute_instance* extern_tf_declaration
                           ;

extern_tf_declaration : TExtern method_prototype ';'
                      | TExtern TForkjoin task_prototype ';'
                      ;

interface_item : port_declaration ';'
               | non_port_interface_item
               ;

non_port_interface_item : generate_region
                        | interface_or_generate_item
                        | program_declaration
                        | interface_declaration
                        | timeunits_declaration
                        ;


// A.1.7 - Program Items
program_item : port_declaration ';'
             | non_port_program_item
             ;

non_port_program_item : attribute_instance* continuous_assign
                      | attribute_instance* module_or_generate_item_declaration
                      | attribute_instance* initial_construct
                      | attribute_instance* final_construct
                      | attribute_instance* concurrent_assertion_item
                      | timeunits_declaration
                      | program_generate_item
                      ;

program_generate_item : loop_generate_construct
                      | conditional_generate_construct
                      | generate_region
                      | elaboration_system_task
                      ;


// A.1.8 - Checker Items
checker_port_list : checker_port_item (',' checker_port_item)*
                  ;

checker_port_item : attribute_instance* checker_port_direction? property_formal_type formal_port_identifier
                    variable_dimension* ('=' property_actual_arg)?
                  ;

checker_port_direction : TInput
                       | TOutput
                       ;

checker_or_generate_item : checker_or_generate_item_declaration
                         | initial_construct
                         | always_construct
                         | final_construct
                         | assertion_item
                         | continuous_assign
                         | checker_generate_item
                         ;

checker_or_generate_item_declaration : TRand? data_declaration
                                     | function_declaration
                                     | checker_declaration
                                     | assertion_item_declaration
                                     | covergroup_declaration
                                     | overload_declaration
                                     | genvar_declaration
                                     | clocking_declaration
                                     | TDefault TClocking clocking_identifier ';'
                                     | TDefault TDisable TIff expression_or_dist ';'
                                     | ';'
                                     ;

checker_generate_item : loop_generate_construct
                      | conditional_generate_construct
                      | generate_region
                      | elaboration_system_task
                      ;


// A.1.9 - Class Items
class_item : attribute_instance* class_property
           | attribute_instance* class_method
           | attribute_instance* class_constraint
           | attribute_instance* class_declaration
           | attribute_instance* covergroup_declaration
           | local_parameter_declaration ';'
           | parameter_declaration ';'
           | ';'
           ;

class_property : property_qualifier* data_declaration
               | TConst class_item_qualifier* data_type const_identifier ('=' constant_expression)? ';'
               ;

class_method : method_qualifier* task_declaration
             | method_qualifier* function_declaration
             | TPure TVirtual class_item_qualifier* method_prototype ';'
             | TExtern method_qualifier* method_prototype ';'
             | method_qualifier* class_constructor_declaration
             | TExtern method_qualifier* class_constructor_prototype
             ;

class_constructor_prototype : TFunction TNew ('(' tf_port_list ')')? ';'
                            ;

class_constraint : constraint_prototype
                 | constraint_declaration
                 ;

class_item_qualifier : TStatic
                     | TProtected
                     | TLocal
                     ;

property_qualifier : random_qualifier
                   | class_item_qualifier
                   ;

random_qualifier : TRand
                 | TRandc
                 ;

method_qualifier : TPure? TVirtual
                 | class_item_qualifier
                 ;

method_prototype : task_prototype
                 | function_prototype
                 ;

class_constructor_declaration : TFunction class_scope? TNew ('(' tf_port_list ')')? ';' block_item_declaration*
                                (TSuper '.' TNew ('(' list_of_arguments ')')? ';')? function_statement_or_null*
                                TEndfunction (':' TNew)?
                              ;


// A.1.10 - Constraints
constraint_declaration : TStatic? TConstraint constraint_identifier constraint_block
                       ;

constraint_block : '{' constraint_block_item* '}'
                 ;

constraint_block_item : TSolve solve_before_list TBefore solve_before_list ';'
                      | constraint_expression
                      ;

solve_before_list : constraint_primary (',' constraint_primary)*
                  ;

constraint_primary : (implicit_class_handle '.' | class_scope)? hierarchical_identifier select
                   ;

constraint_expression : TSoft? expression_or_dist ';'
                      | uniqueness_constraint ';'
                      | expression '->' constraint_set
                      | TIf '(' expression ')' constraint_set (TElse constraint_set)?
                      | TForeach '(' ps_or_hierarchical_array_identifier '[' loop_variables ']' ')' constraint_set
                      | TDisable TSoft constraint_primary ';'
                      ;

uniqueness_constraint : TUnique open_range_list*
                      ;

constraint_set : constraint_expression
               | '{' constraint_expression* '}'
               ;

dist_list : dist_item (',' dist_item)*
          ;

dist_item : value_range dist_weight?
          ;

dist_weight : ':=' expression
            | ':/' expression
            ;

constraint_prototype : constraint_prototype_qualifier? TStatic? TConstraint constraint_identifier ';'
                     ;

constraint_prototype_qualifier : TExtern
                               | TPure
                               ;

extern_constraint_declaration : TStatic TConstraint class_scope constraint_identifier constraint_block
                              ;

identifier_list : identifier (',' identifier)*
                ;


// A.1.11 - Package Items
package_item : package_or_generate_item_declaration
             | anonymous_program
             | package_export_declaration
             | timeunits_declaration
             ;

package_or_generate_item_declaration : net_declaration
                                     | data_declaration
                                     | task_declaration
                                     | function_declaration
                                     | checker_declaration
                                     | dpi_import_export
                                     | extern_constraint_declaration
                                     | class_declaration
                                     | class_constructor_declaration
                                     | local_parameter_declaration ';'
                                     | parameter_declaration ';'
                                     | covergroup_declaration
                                     | overload_declaration
                                     | assertion_item_declaration
                                     | ';'
                                     ;

anonymous_program : TProgram ';' anonymous_program_item* TEndprogram
                  ;

anonymous_program_item : task_declaration
                       | function_declaration
                       | class_declaration
                       | covergroup_declaration
                       | class_constructor_declaration
                       | ';'
                       ;


// A.2 - Declarations
// A.2.1 - Declaration Types
// A.2.1.1 - Module Parameter Declarations
local_parameter_declaration : TLocalparam data_type_or_implicit list_of_param_assignments
                            | TLocalparam TType list_of_type_assignments
                            ;

parameter_declaration : TParameter data_type_or_implicit list_of_param_assignments
                      | TParameter TType list_of_type_assignments
                      ;

specparam_declaration : TSpecparam packed_dimension? list_of_specparam_assignments ';'
                      ;


// A.2.1.2 - Port Declarations
inout_declaration : TInout net_port_type list_of_port_identifiers
                  ;

input_declaration : TInput net_port_type list_of_port_identifiers
                  | TInput variable_port_type list_of_variable_identifiers
                  ;

output_declaration : TOutput net_port_type list_of_port_identifiers
                   | TOutput variable_port_type list_of_variable_port_identifiers
                   ;

interface_port_declaration : interface_identifier list_of_interface_identifiers
                           | interface_identifier '.' modport_identifier list_of_interface_identifiers
                           ;

ref_declaration : TRef variable_port_type list_of_variable_identifiers
                ;


// A.2.1.3 - Type Declarations
data_declaration : TConst? TVar? lifetime? data_type_or_implicit list_of_variable_decl_assignments ';'
                 | type_declaration
                 | package_import_declaration net_type_declaration
                 ;

package_import_declaration : TImport package_import_item (',' package_import_item)* ';'
                           ;

package_import_item : package_identifier '::' identifier | package_identifier '::' '*'
                    ;

package_export_declaration : TExport '*::*' ';'
                           | TExport package_import_item (',' package_import_item)* ';'
                           ;

genvar_declaration : TGenvar list_of_genvar_identifiers ';'
                   ;

net_declaration : net_type (drive_strength | charge_strength)? (TVectored | TScalared)? data_type_or_implicit
                  delay3? list_of_net_decl_assignments ';'
                | net_type_identifier delay_control? list_of_net_decl_assignments ';'
                | TInterconnect implicit_data_type ('#' delay_value)? net_identifier unpacked_dimension*
                  (',' net_identifier unpacked_dimension*)? ';'
                ;

type_declaration : TTypedef data_type type_identifier variable_dimension* ';'
                 | TTypedef interface_instance_identifier constant_bit_select '.' type_identifier type_identifier ';'
                 | TTypedef (TEnum | TStruct | TUnion | TClass | TInterface TClass)? type_identifier ';'
                 ;

net_type_declaration : TNettype data_type net_type_identifier (TWith (package_scope | class_scope)? tf_identifier)? ';'
                     | TNettype (package_scope | class_scope)? net_type_identifier net_type_identifier ';'
                     ;

lifetime : TStatic
         | TAutomatic
         ;


// A.2.2 - Declaration Data Types
// A.2.2.1 - Net and Variable Types
casting_type : simple_type
             | constant_primary
             | signing
             | TString
             | TConst
             ;

data_type : integer_vector_type signing? packed_dimension*
          | integer_atom_type signing?
          | non_integer_type
          | struct_union (TPacked signing?)? (struct_union_member struct_union_member*)* packed_dimension*
          | TEnum enum_base_type? (enum_name_declaration (',' enum_name_declaration)*)* packed_dimension*
          | TString
          | TChandle
          | TVirtual TInterface? interface_identifier parameter_value_assignment? ('.' modport_identifier)?
          | (class_scope | package_scope)? type_identifier packed_dimension*
          | class_type
          | TEvent
          | ps_covergroup_identifier
          | type_reference
          ;

data_type_or_implicit : data_type
                      | implicit_data_type
                      ;

implicit_data_type : signing? packed_dimension*
                   ;

enum_base_type : integer_atom_type signing?
               | integer_vector_type signing? packed_dimension?
               | type_identifier packed_dimension?
               ;

enum_name_declaration : enum_identifier ('[' integral_number (':' integral_number)? ']')? ('=' constant_expression)?
                      ;

class_scope : class_type '::'
            ;

class_type : ps_class_identifier parameter_value_assignment? ('::' class_identifier parameter_value_assignment?)*
           ;

integer_type : integer_vector_type
             | integer_atom_type
             ;

integer_atom_type : TByte
                  | TShortint
                  | TInt
                  | TLongint
                  | TInteger
                  | TTime
                  ;

integer_vector_type : TBit
                    | TLogic
                    | TReg
                    ;

non_integer_type : TShortreal
                 | TReal
                 | TRealtime
                 ;

net_type : TSupply0
         | TSupply1
         | TTri
         | TTriand
         | TTrior
         | TTrireg
         | TTri0
         | TTri1
         | TUwire
         | TWire
         | TWand
         | TWor
         ;

net_port_type : net_type? data_type_or_implicit
              | net_type_identifier
              | TInterconnect implicit_data_type
              ;

variable_port_type : var_data_type
                   ;

var_data_type : data_type
              | TVar data_type_or_implicit
              ;

signing : TSigned
        | TUnsigned
        ;

simple_type : integer_type
            | non_integer_type
            | ps_type_identifier
            | ps_parameter_identifier
            ;

struct_union_member : attribute_instance* random_qualifier? data_type_or_void list_of_variable_decl_assignments ';'
                    ;

data_type_or_void : data_type
                  | TVoid
                  ;

struct_union : TStruct
             | TUnion TTagged?
             ;

type_reference : TType '(' expression ')'
               | TType '(' data_type ')'
               ;


// A.2.2.2 - Strengths
drive_strength : '(' strength0 ',' strength1 ')'
               | '(' strength1 ',' strength0 ')'
               | '(' strength0 ',' THighz1 ')'
               | '(' strength1 ',' THighz0 ')'
               | '(' THighz0 ',' strength1 ')'
               | '(' THighz1 ',' strength0 ')'
               ;

strength0 : TSupply0
          | TStrong0
          | TPull0
          | TWeak0
          ;

strength1 : TSupply1
          | TStrong1
          | TPull1
          | TWeak1
          ;

charge_strength : '(' TSmall ')'
                | '(' TMedium ')'
                | '(' TLarge ')'
                ;


// A.2.2.3 - Delays
delay3 : '#' delay_value
       | '#' '(' mintypmax_expression (',' mintypmax_expression (',' mintypmax_expression)?)? ')'
       ;

delay2 : '#' delay_value
       | '#' '(' mintypmax_expression (',' mintypmax_expression)? ')'
       ;

delay_value : unsigned_number
            | real_number
            | ps_identifier
            | time_literal
            | T1step
            ;


// A.2.3 - Declaration Lists
list_of_defparam_assignments : defparam_assignment (',' defparam_assignment)*
                             ;

list_of_genvar_identifiers : genvar_identifier (',' genvar_identifier)*
                           ;

list_of_interface_identifiers : interface_identifier unpacked_dimension* (',' interface_identifier unpacked_dimension*)*
                              ;

list_of_net_decl_assignments : net_decl_assignment (',' net_decl_assignment)*
                             ;

list_of_param_assignments : param_assignment (',' param_assignment)*
                          ;

list_of_port_identifiers : port_identifier unpacked_dimension* (',' port_identifier unpacked_dimension*)*
                         ;

list_of_udp_port_identifiers : port_identifier (',' port_identifier)*
                             ;

list_of_specparam_assignments : specparam_assignment (',' specparam_assignment)*
                              ;

list_of_tf_variable_identifiers : port_identifier variable_dimension* ('=' expression)?
                                  (',' port_identifier variable_dimension* ('=' expression)?)*
                                ;

list_of_type_assignments : type_assignment (',' type_assignment)*
                         ;

list_of_variable_decl_assignments : variable_decl_assignment (',' variable_decl_assignment)*
                                  ;

list_of_variable_identifiers : variable_identifier variable_dimension* (',' variable_identifier variable_dimension*)*
                             ;

list_of_variable_port_identifiers : port_identifier variable_dimension* ('=' constant_expression)?
                                    (',' port_identifier variable_dimension* ('=' constant_expression)?)*
                                  ;


// A.2.4 - Declaration Assignments
defparam_assignment : hierarchical_parameter_identifier '=' constant_mintypmax_expression
                    ;

net_decl_assignment : net_identifier unpacked_dimension* ('=' expression)?
                    ;

param_assignment : parameter_identifier unpacked_dimension* ('=' constant_param_expression)?
                 ;

specparam_assignment : specparam_identifier '=' constant_mintypmax_expression
                     | pulse_control_specparam
                     ;

type_assignment : type_identifier ('=' data_type)?
                ;

pulse_control_specparam : TPathpulse '=' '(' reject_limit_value (',' error_limit_value)? ')'
                        // | TPathPulse specify_input_terminal_descriptor '$' specify_output_terminal_descriptor
                          '=' '(' reject_limit_value (',' error_limit_value)? ')'
                        ;

error_limit_value : limit_value
                  ;

reject_limit_value : limit_value
                   ;

limit_value : constant_mintypmax_expression
            ;

variable_decl_assignment : variable_identifier variable_dimension* ('=' expression)?
                         | dynamic_array_variable_identifier unsized_dimension variable_dimension*
                           ('=' dynamic_array_new)?
                         | class_variable_identifier ('=' class_new)?
                         ;

class_new : class_scope? TNew ('(' list_of_arguments ')')?
          | TNew expression
          ;

dynamic_array_new : TNew expression? ('(' expression ')')?
                  ;


// A.2.5 - Declaration Ranges
unpacked_dimension : '[' constant_range ']'
                   | '[' constant_expression ']'
                   ;

packed_dimension : '[' constant_range ']'
                 | unsized_dimension
                 ;

associative_dimension : '[' data_type ']'
                      | '[' '*' ']'
                      ;

variable_dimension : unsized_dimension
                   | unpacked_dimension
                   | associative_dimension
                   | queue_dimension
                   ;

queue_dimension : '[' '$' (':' constant_expression)? ']'
                ;

unsized_dimension : '[' ']'
                  ;


// A.2.6 - Function Declarations
function_data_type_or_implicit : data_type_or_void
                               | implicit_data_type
                               ;

function_declaration : TFunction lifetime? function_body_declaration
                     ;

function_body_declaration : function_data_type_or_implicit (interface_identifier '.' | class_scope)? function_identifier ';'
                            tf_item_declaration* function_statement_or_null* TEndfunction (':' function_identifier)?
                          | function_data_type_or_implicit (interface_identifier '.' | class_scope)? function_identifier '('
                            tf_port_list ')' ';' block_item_declaration* function_statement_or_null* TEndfunction
                            (':' function_identifier)?
                          ;

function_prototype : TFunction data_type_or_void function_identifier ('(' tf_port_list ')')?
                   ;

dpi_import_export : TImport dpi_spec_string dpi_function_import_property? (CIdentifier '=')? dpi_function_proto ';'
                  | TImport dpi_spec_string dpi_task_import_property? (CIdentifier '=')? dpi_task_proto ';'
                  | TExport dpi_spec_string (CIdentifier '=')? TFunction function_identifier ';'
                  | TExport dpi_spec_string (CIdentifier '=')? TTask task_identifier ';'
                  ;

dpi_spec_string : TDPIC
                | TDPI
                ;

dpi_function_import_property : TContext
                             | TPure
                             ;

dpi_task_import_property : TContext
                         ;

dpi_function_proto : function_prototype
                   ;

dpi_task_proto : task_prototype
               ;


// A.2.7 - Task Declarations
task_declaration : TTask lifetime? task_body_declaration
                 ;

task_body_declaration : (interface_identifier '.' | class_scope)? task_identifier ';' tf_item_declaration*
                        statement_or_null* TEndtask (':' task_identifier)?
                      | (interface_identifier '.' | class_scope)? task_identifier '(' tf_port_list ')' ';'
                        block_item_declaration* statement_or_null* TEndtask (':' task_identifier)?
                      ;

tf_item_declaration : block_item_declaration
                    | tf_port_declaration
                    ;

tf_port_list : tf_port_item (',' tf_port_item)*
             ;

tf_port_item : attribute_instance* tf_port_direction? TVar? data_type_or_implicit
               (port_identifier variable_dimension* ('=' expression)?)?
             ;

tf_port_direction : port_direction
                  | TConst TRef
                  ;

tf_port_declaration : attribute_instance* tf_port_direction TVar? data_type_or_implicit list_of_tf_variable_identifiers ';'
                    ;

task_prototype : TTask task_identifier ('(' tf_port_list ')')?
               ;


// A.2.8 - Block Item Declarations
block_item_declaration : attribute_instance* data_declaration
                       | attribute_instance* local_parameter_declaration ';'
                       | attribute_instance* parameter_declaration ';'
                       | attribute_instance* overload_declaration
                       | attribute_instance* let_declaration
                       ;

overload_declaration : TBind overload_operator TFunction data_type function_identifier '(' overload_proto_formals ')' ';'
                     ;

overload_operator : '+'
                  | '++'
                  | '-'
                  | '--'
                  | '*'
                  | '**'
                  | '/'
                  | '%'
                  | '=='
                  | '!='
                  | '<'
                  | '<='
                  | '>'
                  | '>='
                  | '='
                  ;

overload_proto_formals : data_type (',' data_type)*
                       ;


// A.2.9 - Interface Declarations
modport_declaration : TModport modport_item (',' modport_item)* ';'
                    ;

modport_item : modport_identifier '(' modport_ports_declaration (',' modport_ports_declaration)* ')'
             ;

modport_ports_declaration : attribute_instance* modport_simple_ports_declaration
                          | attribute_instance* modport_tf_ports_declaration
                          | attribute_instance* modport_clocking_declaration
                          ;

modport_clocking_declaration : TClocking clocking_identifier
                             ;

modport_simple_ports_declaration : port_direction modport_simple_port (',' modport_simple_port)*
                                 ;

modport_simple_port : port_identifier
                    | '.' port_identifier '(' expression? ')'
                    ;

modport_tf_ports_declaration : import_export modport_tf_port (',' modport_tf_port)*
                             ;

modport_tf_port : method_prototype
                | tf_identifier
                ;

import_export : TImport
              | TExport
              ;


// A.2.10 - Assertion Declarations
concurrent_assertion_item : (block_identifier ':')? concurrent_assertion_statement
                          | checker_instantiation
                          ;

concurrent_assertion_statement : assert_property_statement
                               | assume_property_statement
                               | cover_property_statement
                               | cover_sequence_statement
                               | restrict_property_statement
                               ;

assert_property_statement : TAssert TProperty '(' property_spec ')' action_block
                          ;

assume_property_statement : TAssume TProperty '(' property_spec ')' action_block
                          ;

cover_property_statement : TCover TProperty '(' property_spec ')' statement_or_null
                         ;

expect_property_statement : TExpect '(' property_spec ')' action_block
                          ;

cover_sequence_statement : TCover TSequence '(' clocking_event? (TDisable TIff '(' expression_or_dist ')')? sequence_expr ')'
                           statement_or_null
                         ;

restrict_property_statement : TRestrict TProperty '(' property_spec ')' ';'
                            ;

property_instance : ps_or_hierarchical_property_identifier ('(' property_list_of_arguments ')')?
                  ;

property_list_of_arguments : property_actual_arg? (',' property_actual_arg?)*
                             (',' '.' identifier '(' property_actual_arg? ')')*
                           | '.' identifier '(' property_actual_arg? ')' (',' '.' identifier '(' property_actual_arg? ')')*
                           ;

property_actual_arg : property_expr
                    | sequence_actual_arg
                    ;

assertion_item_declaration : property_declaration
                           | sequence_declaration
                           | let_declaration
                           ;

property_declaration : TProperty property_identifier ('(' property_port_list? ')')? ';'
                       assertion_variable_declaration* property_spec ';'? TEndproperty (':' property_identifier)?
                     ;

property_port_list : property_port_item (',' property_port_item)*
                   ;

property_port_item : attribute_instance* (TLocal property_lvar_port_direction?)? property_formal_type
                     formal_port_identifier variable_dimension* ('=' property_actual_arg)?
                   ;

property_lvar_port_direction : TInput
                             ;

property_formal_type : sequence_formal_type
                     | TProperty
                     ;

property_spec : clocking_event? (TDisable TIff '(' expression_or_dist ')')? property_expr
              ;

property_expr : sequence_expr
              | TStrong '(' sequence_expr ')'
              | TWeak '(' sequence_expr ')'
              | '(' property_expr ')'
              | TNot property_expr
              | property_expr TOr property_expr
              | property_expr TAnd property_expr
              | sequence_expr '|->' property_expr
              | sequence_expr '|=>' property_expr
              | TIf '(' expression_or_dist ')' property_expr (TElse property_expr)?
              | TCase '(' expression_or_dist ')' property_case_item property_case_item* TEndcase
              | sequence_expr '#-#' property_expr
              | sequence_expr '#=#' property_expr
              | TNexttime property_expr
              | TNexttime '[' constant_expression ']' property_expr
              | TSNexttime property_expr
              | TSNexttime '[' constant_expression ']' property_expr
              | TAlways property_expr
              | TAlways '[' cycle_delay_const_range_expression ']' property_expr
              | TSAlways '[' constant_range ']' property_expr
              | TSEventually property_expr
              | TEventually '[' constant_range ']' property_expr
              | TSEventually '[' cycle_delay_const_range_expression ']' property_expr
              | property_expr TUntil property_expr
              | property_expr TSUntil property_expr
              | property_expr TSUntilWith property_expr
              | property_expr TSUntilWith property_expr
              | property_expr TImplies property_expr
              | property_expr TIff property_expr
              | TAcceptOn '(' expression_or_dist ')' property_expr
              | TRejectOn '(' expression_or_dist ')' property_expr
              | TSyncAcceptOn '(' expression_or_dist ')' property_expr
              | TSyncRejectOn '(' expression_or_dist ')' property_expr
              | property_instance
              | clocking_event property_expr
              ;

property_case_item : expression_or_dist (',' expression_or_dist)* ':' property_expr ';'?
                   | TDefault ':'? property_expr ';'?
                   ;

sequence_declaration : TSequence sequence_identifier ('(' sequence_port_list? ')')? ';'
                       assertion_variable_declaration* sequence_expr ';'? TEndsequence (':' sequence_identifier)?
                     ;

sequence_port_list : sequence_port_item (',' sequence_port_item)*
                   ;

sequence_port_item : attribute_instance* (TLocal sequence_lvar_port_direction?)? sequence_formal_type
                     formal_port_identifier variable_dimension* ('=' sequence_actual_arg)?
                   ;

sequence_lvar_port_direction : TInput
                             | TInout
                             | TOutput
                             ;

sequence_formal_type : data_type_or_implicit
                     | TSequence
                     | TUntyped
                     ;

sequence_expr : cycle_delay_range sequence_expr cycle_delay_range sequence_expr*
              | sequence_expr cycle_delay_range sequence_expr cycle_delay_range sequence_expr*
              | expression_or_dist boolean_abbrev?
              | sequence_instance sequence_abbrev?
              | '(' sequence_expr (',' sequence_match_item)* ')' sequence_abbrev?
              | sequence_expr TAnd sequence_expr
              | sequence_expr TIntersect sequence_expr
              | sequence_expr TOr sequence_expr
              | TFirstMatch '(' sequence_expr (',' sequence_match_item)* ')'
              | expression_or_dist TThroughout sequence_expr
              | sequence_expr TWithin sequence_expr
              | clocking_event sequence_expr
              ;

cycle_delay_range : '##' constant_primary
                  | '##' '[' cycle_delay_const_range_expression ']'
                  | '##[*]'
                  | '##[+]'
                  ;

sequence_method_call : sequence_instance '.' method_identifier
                     ;

sequence_match_item : operator_assignment
                    | inc_or_dec_expression
                    | subroutine_call
                    ;

sequence_instance : ps_or_hierarchical_sequence_identifier ('(' sequence_list_of_arguments ')')?
                  ;

sequence_list_of_arguments : sequence_actual_arg? (',' sequence_actual_arg?)*
                             (',' '.' identifier '(' sequence_actual_arg? ')')*
                           | '.' identifier '(' sequence_actual_arg? ')' (',' '.' identifier '(' sequence_actual_arg? ')')*
                           ;

sequence_actual_arg : event_expression
                    | sequence_expr
                    ;

boolean_abbrev : consecutive_repetition
               | non_consecutive_repetition
               | goto_repetition
               ;

sequence_abbrev : consecutive_repetition
                ;

consecutive_repetition : '[*' const_or_range_expression ']'
                       | '[*]'
                       | '[+]'
                       ;

non_consecutive_repetition : '[=' const_or_range_expression ']'
                           ;

goto_repetition : '[->' const_or_range_expression ']'
                ;

const_or_range_expression : constant_expression
                          | cycle_delay_const_range_expression
                          ;

cycle_delay_const_range_expression : constant_expression ':' constant_expression
                                   | constant_expression ':' '$'
                                   ;

expression_or_dist : expression (TDist dist_list*)?
                   ;

assertion_variable_declaration : var_data_type list_of_variable_decl_assignments ';'
                               ;

let_declaration : TLet let_identifier ('(' let_port_list? ')')? '=' expression ';'
                ;

let_identifier : identifier
               ;

let_port_list : let_port_item (',' let_port_item)*
              ;

let_port_item : attribute_instance* let_formal_type formal_port_identifier variable_dimension*
                ('=' expression)?
               ;

let_formal_type : data_type_or_implicit
                | TUntyped
                ;

let_expression : package_scope? let_identifier ('(' let_list_of_arguments ')')?
               ;

let_list_of_arguments : let_actual_arg? (',' let_actual_arg?)* (',' '.' identifier '(' let_actual_arg? ')')*
                      | '.' identifier '(' let_actual_arg? ')' (',' '.' identifier '(' let_actual_arg? ')')*
                      ;

let_actual_arg : expression
               ;

// A.2.11 - Covergroup Declarations
covergroup_declaration : TCovergroup covergroup_identifier ('(' tf_port_list ')')? coverage_event? ';'
                         coverage_spec_or_option* TEndgroup (':' covergroup_identifier)?
                       ;

coverage_spec_or_option : attribute_instance* coverage_spec
                        | attribute_instance* coverage_option ';'
                        ;

coverage_option : TOption '.' member_identifier '=' expression
                | TTypeOption '.' member_identifier '=' constant_expression
                ;

coverage_spec : cover_point
              | cover_cross
              ;

coverage_event : clocking_event
               | TWith TFunction TSample '(' tf_port_list ')'
               | '@@' '(' block_event_expression ')'
               ;

block_event_expression : block_event_expression TOr block_event_expression
                       | TBegin hierarchical_btf_identifier
                       | TEnd hierarchical_btf_identifier
                       ;

hierarchical_btf_identifier : hierarchical_tf_identifier
                            | hierarchical_block_identifier
                            | (hierarchical_identifier '.' | class_scope)? method_identifier
                            ;

cover_point : (data_type_or_implicit cover_point_identifier ':')? TCoverpoint expression
              (TIff '(' expression ')')? bins_or_empty
            ;

bins_or_empty : '{' attribute_instance* (bins_or_options ';')* '}'
              | ';'
              ;

bins_or_options : coverage_option
                | TWildcard? bins_keyword bin_identifier ('[' covergroup_expression? ']')? '='
                  '{' covergroup_range_list '}' (TWith '(' with_covergroup_expression ')')? (TIff '(' expression ')')?
                | TWildcard? bins_keyword bin_identifier ('[' covergroup_expression? ']')? '='
                  cover_point_identifier (TWith '(' with_covergroup_expression ')')? (TIff '(' expression ')')?
                | TWildcard? bins_keyword bin_identifier ('[' covergroup_expression? ']')? '='
                  set_covergroup_expression (TIff '(' expression ')')?
                | TWildcard? bins_keyword bin_identifier ('[' ']')? '='
                  trans_list (TIff '(' expression ')')?
                | bins_keyword bin_identifier ('[' covergroup_expression? ']')? '='
                  TDefault (TIff '(' expression ')')?
                | bins_keyword bin_identifier '=' TDefault TSequence (TIff '(' expression ')')?
                ;

bins_keyword : TBins
             | TIllegalBins
             | TIgnoreBins
             ;


trans_list : '(' trans_set ')' (',' '(' trans_set ')')*
           ;

trans_set : trans_range_list ('=>' trans_range_list)*
          ;

trans_range_list : trans_item
                 | trans_item '[*' repeat_range ']'
                 | trans_item '[->' repeat_range ']'
                 | trans_item '[=' repeat_range ']'
                 ;

trans_item : covergroup_range_list
           ;

repeat_range : covergroup_expression
             | covergroup_expression ':' covergroup_expression
             ;

cover_cross : (cross_identifier ':')? TCross list_of_cross_items (TIff '(' expression ')')? cross_body
            ;

list_of_cross_items : cross_item ',' cross_item (',' cross_item)*
                    ;

cross_item : cover_point_identifier
           | variable_identifier
           ;

cross_body : '{' (cross_body_item ';')* '}'
           | ';'
           ;

cross_body_item : function_declaration
                | bins_selection_or_option ';'
                ;

bins_selection_or_option : attribute_instance* coverage_option
                         | attribute_instance* bins_selection
                         ;

bins_selection : bins_keyword bin_identifier '=' select_expression (TIff '(' expression ')')?
               ;

select_expression : select_condition
                  | '!' select_condition
                  | select_expression '&&' select_expression
                  | select_expression '||' select_expression
                  | '(' select_expression ')'
                  | select_expression TWith '(' with_covergroup_expression ')'
                    (TMatches integer_covergroup_expression)?
                  | cross_identifier
                  | cross_set_expression (TMatches integer_covergroup_expression)?
                  ;

select_condition : TBinsOf '(' bins_expression ')' (TIntersect '{' covergroup_range_list '}')?
                 ;

bins_expression : variable_identifier
                | cover_point_identifier ('.' bin_identifier)?
                ;

covergroup_range_list : covergroup_value_range (',' covergroup_value_range)*
                      ;

covergroup_value_range : covergroup_expression
                       | '[' covergroup_expression ':' covergroup_expression ']'
                       ;

with_covergroup_expression : covergroup_expression
                           ;

set_covergroup_expression : covergroup_expression
                          ;

integer_covergroup_expression : covergroup_expression
                              ;

cross_set_expression : covergroup_expression
                     ;

covergroup_expression : expression
                      ;


// A.3 - Primitive Instances
// skipping for now


// A.4 - Instantiations
// A.4.1 - Instantation
// A.4.1.1 - Module Instantation
module_instantiation : module_identifier parameter_value_assignment? hierarchical_instance
                      (',' hierarchical_instance)* ';'
                     ;

parameter_value_assignment : '#' '(' list_of_parameter_assignments? ')'
                           ;

list_of_parameter_assignments : ordered_parameter_assignment (',' ordered_parameter_assignment)*
                              | named_parameter_assignment (',' named_parameter_assignment)*
                              ;

ordered_parameter_assignment : param_expression
                             ;

named_parameter_assignment : '.' parameter_identifier '(' param_expression? ')'
                           ;

hierarchical_instance : name_of_instance '(' list_of_port_connections ')'
                      ;

name_of_instance : instance_identifier unpacked_dimension*
                 ;

list_of_port_connections : ordered_port_connection (',' ordered_port_connection)*
                         | named_port_connection (',' named_port_connection)*
                         ;

ordered_port_connection : attribute_instance* expression?
                        ;

named_port_connection : attribute_instance* '.' port_identifier ('(' expression? ')')?
                      | attribute_instance* '.*'
                      ;


// A.4.1.2 - Interface Instantiation
interface_instantiation : interface_identifier parameter_value_assignment?
                          hierarchical_instance (',' hierarchical_instance)* ';'
                        ;


// A.4.1.3 - Program Instantiation
program_instantiation : program_identifier parameter_value_assignment?
                        hierarchical_instance (',' hierarchical_instance)* ';'
                      ;


// A.4.1.4 - Checker Instantiation
checker_instantiation : ps_checker_identifier name_of_instance '(' list_of_checker_port_connections ')' ';'
                      ;

list_of_checker_port_connections : ordered_checker_port_connection (',' ordered_checker_port_connection)*
                                 | named_checker_port_connection (',' named_checker_port_connection)*
                                 ;

ordered_checker_port_connection : attribute_instance* property_actual_arg?
                                ;

named_checker_port_connection : attribute_instance* '.' formal_port_identifier ('(' property_actual_arg? ')')?
                              | attribute_instance* '.*'
                              ;


// A.4.2 - Generated Instantiation
generate_region : TGenerate generate_item* TEndgenerate
                ;

loop_generate_construct : TFor '(' genvar_initialization ';' genvar_expression ';' genvar_iteration ')' generate_block
                        ;

genvar_initialization : TGenvar? genvar_identifier '=' constant_expression
                      ;

genvar_iteration : genvar_identifier assignment_operator genvar_expression
                 | inc_or_dec_operator genvar_identifier
                 | genvar_identifier inc_or_dec_operator
                 ;

conditional_generate_construct : if_generate_construct
                               | case_generate_construct
                               ;

if_generate_construct : TIf '(' constant_expression ')' generate_block (TElse generate_block)?
                      ;

case_generate_construct : TCase '(' constant_expression ')' case_generate_item case_generate_item* TEndcase
                        ;

case_generate_item : constant_expression (',' constant_expression)* ':' generate_block
                   | TDefault ':'? generate_block
                   ;

generate_block : generate_item
               | (generate_block_identifier ':')? TBegin (':' generate_block_identifier)? generate_item* TEnd
                 (':' generate_block_identifier)?
               ;

generate_item : module_or_generate_item
              | interface_or_generate_item
              | checker_or_generate_item
              ;


// A.5 - UDP Declaration and Instantiation
// Skipping


// A.6 - Behavioral Assignments
// A.6.1 - Continuous Assignment and Net Alias Statements
continuous_assign : TAssign drive_strength? delay3? list_of_net_assignments ';'
                  | TAssign delay_control? list_of_variable_assignments ';'
                  ;

list_of_net_assignments : net_assignment (',' net_assignment)*
                        ;

list_of_variable_assignments : variable_assignment (',' variable_assignment)*
                             ;

net_alias : TAlias net_lvalue '=' net_lvalue ('=' net_lvalue)* ';'
          ;

net_assignment : net_lvalue '=' expression
               ;


// A.6.2 - Procedural Blocks and Assignments
initial_construct : TInitial statement_or_null
                  ;

always_construct : always_keyword statement
                 ;

always_keyword : TAlways
               | TAlwaysComb
               | TAlwaysLatch
               | TAlwaysFF
               ;

final_construct : TFinal function_statement
                ;

blocking_assignment : variable_lvalue '=' delay_or_event_control expression
                    | nonrange_variable_lvalue '=' dynamic_array_new
                    | (implicit_class_handle '.' | class_scope | package_scope) hierarchical_variable_identifier
                      select '!=' class_new
                    | operator_assignment
                    ;

operator_assignment : variable_lvalue assignment_operator expression
                    ;

assignment_operator : '='
                    | '+='
                    | '-='
                    | '*='
                    | '/='
                    | '%='
                    | '&='
                    | '|='
                    | '^='
                    | '<<='
                    | '>>='
                    | '<<<='
                    | '>>>='
                    ;

nonblocking_assignment : variable_lvalue '<=' delay_or_event_control? expression
                       ;

procedural_continuous_assignment : TAssign variable_assignment
                                 | TDeassign variable_lvalue
                                 | TForce variable_assignment
                                 | TForce net_assignment
                                 | TRelease variable_lvalue
                                 | TRelease net_lvalue
                                 ;

variable_assignment : variable_lvalue '=' expression
                    ;


// A.6.3 - Parallel and Sequential Blocks
action_block : statement_or_null
             | statement? TElse statement_or_null
             ;

seq_block : TBegin (':' block_identifier)? block_item_declaration* statement_or_null*
            TEnd (':' block_identifier)?
          ;

par_block : TFork (':' block_identifier)? block_item_declaration* statement_or_null*
            join_keyword (':' block_identifier)?
          ;

join_keyword : TJoin
             | TJoinAny
             | TJoinNone
             ;


// A.6.4 - Statements
statement_or_null : statement
                  | attribute_instance* ';'
                  ;

statement : (block_identifier ':')? attribute_instance* statement_item
          ;

statement_item : blocking_assignment ';'
               | nonblocking_assignment ';'
               | procedural_continuous_assignment ';'
               | case_statement
               | conditional_statement
               | inc_or_dec_expression ';'
               | subroutine_call_statement
               | disable_statement
               | event_trigger
               | loop_statement
               | jump_statement
               | par_block
               | procedural_timing_control_statement
               | seq_block
               | wait_statement
               | procedural_assertion_statement
               | clocking_drive ';'
               | randsequence_statement
               | randcase_statement
               | expect_property_statement
               ;

function_statement : statement
                   ;

function_statement_or_null : function_statement
                           | attribute_instance* ';'
                           ;

variable_identifier_list : variable_identifier (',' variable_identifier)*
                         ;


// A.6.5 - Timing Control Statements
procedural_timing_control_statement : procedural_timing_control statement_or_null
                                    ;

delay_or_event_control : delay_control
                       | event_control
                       | TRepeat '(' expression ')' event_control
                       ;

delay_control : '#' delay_value
              | '#' '(' mintypmax_expression ')'
              ;

event_control : '@' hierarchical_event_identifier
              | '@' '(' event_expression ')'
              | '@*'
              | '@' '(*)'
              | '@' ps_or_hierarchical_sequence_identifier
              ;

event_expression : edge_identifier? expression (TIff expression)?
                 | sequence_instance (TIff expression)?
                 | event_expression TOr event_expression
                 | event_expression ',' event_expression
                 | '(' event_expression ')'
                 ;

procedural_timing_control : delay_control
                          | event_control
                          | cycle_delay
                          ;

jump_statement : TReturn expression? ';'
               | TBreak ';'
               | TContinue ';'
               ;

wait_statement : TWait '(' expression ')' statement_or_null
               | TWait TFork ';'
               | TWaitOrder '(' hierarchical_identifier (',' hierarchical_identifier)* ')' action_block
               ;

event_trigger : '->' hierarchical_event_identifier ';'
              | '->>' delay_or_event_control? hierarchical_event_identifier ';'
              ;

disable_statement : TDisable hierarchical_task_identifier ';'
                  | TDisable hierarchical_block_identifier ';'
                  | TDisable TFork ';'
                  ;


// A.6.6 - Conditional Statements
conditional_statement : unique_priority? TIf '(' cond_predicate ')' statement_or_null
                        (TElse TIf '(' cond_predicate ')' statement_or_null)* (TElse statement_or_null)?
                      ;

unique_priority : TUnique
                | TUnique0
                | TPriority
                ;

cond_predicate : expression_or_cond_pattern ('&&&' expression_or_cond_pattern)*
               ;

expression_or_cond_pattern : expression (TMatches pattern)?
                           ;

// A.6.7 - Case Statements
case_statement : unique_priority? case_keyword '(' case_expression ')' case_item case_item* TEndcase
               | unique_priority? case_keyword '(' case_expression ')' TMatches case_pattern_item
                 case_pattern_item* TEndcase
               | unique_priority? TCase '(' case_expression ')' TInside case_inside_item case_inside_item*
                 TEndcase
               ;

case_keyword : TCase
             | TCasez
             | TCasex
             ;

case_expression : expression
                ;

case_item : case_item_expression (',' case_item_expression)* ':' statement_or_null
          | TDefault ':'? statement_or_null
          ;

case_pattern_item : pattern ('&&&' expression)? ':' statement_or_null
                  | TDefault ':'? statement_or_null
                  ;

case_inside_item : open_range_list ':' statement_or_null
                 |TDefault ':'? statement_or_null
                 ;

case_item_expression : expression
                     ;

randcase_statement : TRandcase randcase_item randcase_item* TEndcase
                   ;

randcase_item : expression ':' statement_or_null
              ;

open_range_list : open_value_range (',' open_value_range)*
                ;

open_value_range : value_range
                 ;


// A.6.7.1 - Patterns
pattern : '.' variable_identifier
        | '.*'
        | constant_expression
        | TTagged member_identifier pattern?
        | '\'{' pattern (',' pattern)* '}'
        | '\'{' member_identifier ':' pattern (',' member_identifier ':' pattern)* '}'
        ;

assignment_pattern : '\'{' expression (',' expression)* '}'
                   | '\'{' structure_pattern_key ':' expression (',' structure_pattern_key ':' expression)* '}'
                   | '\'{' array_pattern_key ':' expression (',' array_pattern_key ':' expression)* '}'
                   | '\'{' constant_expression '{' expression (',' expression)* '}' '}'
                   ;

structure_pattern_key : member_identifier
                      | assignment_pattern_key
                      ;

array_pattern_key : constant_expression
                  | assignment_pattern_key
                  ;

assignment_pattern_key : simple_type
                       | TDefault
                       ;

assignment_pattern_expression : assignment_pattern_expression_type? assignment_pattern
                              ;

assignment_pattern_expression_type : ps_type_identifier
                                   | ps_parameter_identifier
                                   | integer_atom_type
                                   | type_reference
                                   ;

constant_assignment_pattern_expression : assignment_pattern_expression
                                       ;

assignment_pattern_net_lvalue : '\'{' net_lvalue (',' net_lvalue)* '}'
                              ;

assignment_pattern_variable_lvalue : '\'{' variable_lvalue (',' variable_lvalue)* '}'
                                   ;

// A.6.8 - Looping Statements
loop_statement : TForever statement_or_null
               | TRepeat '(' expression ')' statement_or_null
               | TWhile '(' expression ')' statement_or_null
               | TFor '(' for_initialization? ';' expression? ';' for_step? ')' statement_or_null
               | TDo statement_or_null TWhile '(' expression ')' ';'
               | TForeach '(' ps_or_hierarchical_array_identifier '[' loop_variables ']' ')' statement
               ;

for_initialization : list_of_variable_assignments
                   | for_variable_declaration (',' for_variable_declaration)*
                   ;

for_variable_declaration : TVar? data_type variable_identifier '=' expression (',' variable_identifier '=' expression)*
                         ;

for_step : for_step_assignment (',' for_step_assignment)*
         ;

for_step_assignment : operator_assignment
                    | inc_or_dec_expression
                    | function_subroutine_call
                    ;

loop_variables : index_variable_identifier? (',' index_variable_identifier?)*
               ;

// A.6.9 - Subroutine Call Statements
subroutine_call_statement : subroutine_call ';'
                          | TVoid '\'' '(' function_subroutine_call ')' ';'
                          ;


// A.6.10 Assertion statements
assertion_item : concurrent_assertion_item
               | deferred_immediate_assertion_item
               ;

deferred_immediate_assertion_item : (block_identifier ':')? deferred_immediate_assertion_statement
                                  ;

procedural_assertion_statement : concurrent_assertion_statement
                               | immediate_assertion_statement
                               | checker_instantiation
                               ;

immediate_assertion_statement : simple_immediate_assertion_statement
                              | deferred_immediate_assertion_statement
                              ;

simple_immediate_assertion_statement : simple_immediate_assert_statement
                                     | simple_immediate_assume_statement
                                     | simple_immediate_cover_statement
                                     ;

simple_immediate_assert_statement : TAssert '(' expression ')' action_block
                                  ;

simple_immediate_assume_statement : TAssume '(' expression ')' action_block
                                  ;

simple_immediate_cover_statement : TCover '(' expression ')' statement_or_null
                                 ;

deferred_immediate_assertion_statement : deferred_immediate_assert_statement
                                       | deferred_immediate_assume_statement
                                       | deferred_immediate_cover_statement
                                       ;

deferred_immediate_assert_statement : TAssert '#0' '(' expression ')' action_block
                                    | TAssert TFinal '(' expression ')' action_block
                                    ;

deferred_immediate_assume_statement : TAssume '#0' '(' expression ')' action_block
                                    | TAssume TFinal '(' expression ')' action_block
                                    ;

deferred_immediate_cover_statement : TCover '#0' '(' expression ')' statement_or_null
                                   | TCover TFinal '(' expression ')' statement_or_null
                                   ;


// A.6.11 Clocking block
clocking_declaration : TDefault? TClocking clocking_identifier? clocking_event ';' clocking_item*
                       TEndclocking (':' clocking_identifier)?
                     | TGlobal TClocking clocking_identifier? clocking_event ';'
                       TEndclocking (':' clocking_identifier)?
                     ;

clocking_event : '@' identifier
               | '@' '(' event_expression ')'
               ;

clocking_item : TDefault default_skew ';'
              | clocking_direction list_of_clocking_decl_assign ';'
              | attribute_instance* assertion_item_declaration
              ;

default_skew : TInput clocking_skew
             | TOutput clocking_skew
             | TInput clocking_skew TOutput clocking_skew
             ;

clocking_direction : TInput clocking_skew?
                   | TOutput clocking_skew?
                   | TInput clocking_skew? TOutput clocking_skew?
                   | TInout
                   ;

list_of_clocking_decl_assign : clocking_decl_assign (',' clocking_decl_assign)*
                             ;

clocking_decl_assign : signal_identifier ('=' expression)?
                     ;

clocking_skew : edge_identifier delay_control?
              | delay_control
              ;

clocking_drive : clockvar_expression '<=' cycle_delay? expression
               ;

cycle_delay : '##' integral_number
            | '##' identifier
            | '##' '(' expression ')'
            ;

clockvar : hierarchical_identifier
         ;

clockvar_expression : clockvar select
                    ;


// A.6.12 - Rand Sequence
randsequence_statement : TRandsequence '(' production_identifier? ')' production+ TEndsequence
                       ;

production : data_type_or_void? production_identifier ('(' tf_port_list ')')? ':' rs_rule ('|' rs_rule)* ';'
           ;

rs_rule : rs_production_list (':=' weight_specification rs_code_block?)?
        ;

rs_production_list : rs_prod rs_prod*
                   | TRand TJoin ('(' expression ')')? production_item production_item production_item*
                   ;

weight_specification : integral_number
                     | ps_identifier '(' expression ')'
                     ;

rs_code_block : '{' data_declaration* statement_or_null* '}'
              ;

rs_prod : production_item
        | rs_code_block
        | rs_if_else
        | rs_repeat
        | rs_case
        ;

production_item : production_identifier ('(' list_of_arguments ')')?
                ;

rs_if_else : TIf '(' expression ')' production_item (TElse production_item)?
           ;

rs_repeat : TRepeat '(' expression ')' production_item
          ;

rs_case : TCase '(' case_expression ')' rs_case_item rs_case_item* TEndcase
        ;

rs_case_item : case_item_expression (',' case_item_expression)* ':' production_item ';'
             | TDefault ':'? production_item ';'
             ;


// A.7 - Specify section
// skipping all of this except for

z_or_x : 'x'
       | 'X'
       | 'z'
       | 'Z'
       ;

// A.7.4 - Specify Path Delays
edge_identifier : TPosedge
                | TNegedge
                | TEdge
                ;

// A.8 - Expressions
// A.8.1 - Concatenations
concatenation : '{' expression (',' expression)* '}'
              ;

constant_concatenation : '{' constant_expression (',' constant_expression)* '}'
                       ;

constant_multiple_concatenation : '{' constant_expression constant_concatenation '}'
                                ;

module_path_concatenation : '{' module_path_expression (',' module_path_expression)* '}'
                          ;

module_path_multiple_concatenation : '{' constant_expression module_path_concatenation '}'
                                   ;

multiple_concatenation : '{' expression concatenation '}'
                       ;

streaming_concatenation : '{' stream_operator slice_size? stream_concatenation '}'
                        ;

stream_operator : '>>'
                | '<<'
                ;

slice_size : simple_type
           | constant_expression
           ;

stream_concatenation : '{' stream_expression (',' stream_expression)* '}'
                     ;

stream_expression : expression (TWith '[' array_range_expression ']')?
                  ;

array_range_expression : expression
                       | expression ':' expression
                       | expression '+:' expression
                       | expression '-:' expression
                       ;

empty_queue : '{' '}'
            ;


// A.8.2 - Subroutine Calls
constant_function_call : function_subroutine_call
                       ;

tf_call : ps_or_hierarchical_tf_identifier attribute_instance* ('(' list_of_arguments ')')?
        ;

system_tf_call : SystemTFIdentifier ('(' list_of_arguments ')')?
               | SystemTFIdentifier '(' data_type (',' expression)? ')'
               ;

subroutine_call : tf_call
                | system_tf_call
                | method_call
                | 'std::' randomize_call
                ;

function_subroutine_call : subroutine_call
                         ;

list_of_arguments : expression? (',' expression?)* (',' '.' identifier '(' expression? ')')*
                  | '.' identifier '(' expression? ')' (',' '.' identifier '(' expression? ')')*
                  ;

method_call : method_call_root '.' method_call_body
            ;

method_call_body : method_identifier attribute_instance* ('(' list_of_arguments ')')?
                 | built_in_method_call
                 ;

built_in_method_call : array_manipulation_call
                     | randomize_call
                     ;

array_manipulation_call : array_method_name attribute_instance* ('(' list_of_arguments ')')?
                          (TWith '(' expression ')')?
                        ;

randomize_call : TRandomize attribute_instance* ('(' (variable_identifier_list | TNull)? ')')?
                 (TWith ('(' identifier_list? ')')? constraint_block )?
               ;

method_call_root : primary
                 | implicit_class_handle
                 ;

array_method_name : method_identifier
                  | 'unique'
                  | 'and'
                  | 'or'
                  | 'xor'
                  ;


// A.8.3 - Expressions
inc_or_dec_expression : inc_or_dec_operator attribute_instance* variable_lvalue
                      | variable_lvalue attribute_instance* inc_or_dec_operator
                      ;

conditional_expression : cond_predicate '?' attribute_instance* expression ':' expression
                       ;

constant_expression : constant_primary
                    | unary_operator attribute_instance* constant_primary
                    | constant_expression binary_operator attribute_instance* constant_expression
                    | constant_expression '?' attribute_instance* constant_expression ':' constant_expression
                    ;

constant_mintypmax_expression : constant_expression
                              | constant_expression ':' constant_expression ':' constant_expression
                              ;

constant_param_expression : constant_mintypmax_expression
                          | data_type
                          | '$'
                          ;

param_expression : mintypmax_expression
                 | data_type
                 | '$'
                 ;

constant_range_expression : constant_expression
                          | constant_part_select_range
                          ;

constant_part_select_range : constant_range
                           | constant_indexed_range
                           ;

constant_range : constant_expression ':' constant_expression
               ;

constant_indexed_range : constant_expression '+:' constant_expression
                       | constant_expression '-:' constant_expression
                       ;

expression : (primary | unary_operator attribute_instance* primary | inc_or_dec_expression | '(' operator_assignment ')' | tagged_union_expression)
             (binary_operator attribute_instance* expression | conditional_expression | inside_expression)*
           ;

tagged_union_expression : TTagged member_identifier expression?
                        ;

inside_expression : expression TInside '{' open_range_list '}'
                  ;

value_range : expression
            | '[' expression ':' expression ']'
            ;

mintypmax_expression : expression
                     | expression ':' expression ':' expression
                     ;

module_path_expression : (module_path_primary | unary_module_path_operator attribute_instance* module_path_primary)
                         (binary_module_path_operator attribute_instance* module_path_expression | '?' attribute_instance* module_path_expression ':' module_path_expression)*
                       ;

module_path_mintypmax_expression : module_path_expression
                                 | module_path_expression ':' module_path_expression ':' module_path_expression
                                 ;

part_select_range : constant_range
                  | indexed_range
                  ;

indexed_range : expression '+:' constant_expression
              | expression '-:' constant_expression
              ;

genvar_expression : constant_expression
                  ;


// A.8.4 - Primaries
constant_primary : ( primary_literal
                   | ps_parameter_identifier constant_select
                   | specparam_identifier ('[' constant_range_expression ']')?
                   | genvar_identifier
                   | formal_port_identifier constant_select
                   | (package_scope | class_scope)? enum_identifier
                   | constant_concatenation ('[' constant_range_expression ']')?
                   | constant_multiple_concatenation ('[' constant_range_expression ']')?
                   | constant_function_call
                   | constant_let_expression
                   | '(' constant_mintypmax_expression ')'
                   | constant_assignment_pattern_expression
                   | type_reference
                   ) constant_cast*
                 ;


module_path_primary : number
                    | identifier
                    | module_path_concatenation
                    | module_path_multiple_concatenation
                    | function_subroutine_call
                    | '(' module_path_mintypmax_expression ')'
                    ;

primary : ( primary_literal
          | (class_qualifier | package_scope) hierarchical_identifier select
          | empty_queue
          | concatenation ('[' range_expression ']')?
          | multiple_concatenation ('[' range_expression ']')?
          | let_expression
          | '(' mintypmax_expression ')'
          | assignment_pattern_expression
          | streaming_concatenation
          | sequence_method_call
          | TThis
          | '$'
          | TNull
          ) (function_subroutine_call | cast)*
        ;

class_qualifier : 'local::'? (implicit_class_handle '.' | class_scope)?
                ;

range_expression : expression
                 | part_select_range
                 ;

primary_literal : number
                | time_literal
                | unbased_unsized_literal
                | StringLiteral
                ;

time_literal : unsigned_number time_unit
             | fixed_point_number time_unit
             ;

time_unit : 's'
          | 'ms'
          | 'us'
          | 'ns'
          | 'ps'
          | 'fs'
          ;

implicit_class_handle : TThis
                      | TSuper
                      | TThis '.' TSuper
                      ;

bit_select : ('[' expression ']')*
           ;

select : (('.' member_identifier bit_select)? '.' member_identifier)? bit_select ('[' part_select_range ']')?
       ;

nonrange_select : (('.' member_identifier bit_select)* '.' member_identifier)? bit_select
                ;

constant_bit_select : ('[' constant_expression ']')*
                    ;

constant_select : (('.' member_identifier constant_bit_select)* '.' member_identifier)? constant_bit_select
                  ('[' constant_part_select_range ']')?
            ;

constant_cast : casting_type '\'' '(' constant_expression ')'
              ;

constant_let_expression : let_expression
                        ;

cast : casting_type '\'' '(' expression ')'
     ;


// A.8.5 Expression left-side values
net_lvalue : ps_or_hierarchical_net_identifier constant_select
           | '{' net_lvalue (',' net_lvalue)* '}'
           | assignment_pattern_expression_type? assignment_pattern_net_lvalue
           ;

variable_lvalue : (implicit_class_handle '.' | package_scope)? hierarchical_variable_identifier select
                | '{' variable_lvalue (',' variable_lvalue)* '}'
                | assignment_pattern_expression_type? assignment_pattern_variable_lvalue
                | streaming_concatenation
                ;

nonrange_variable_lvalue : (implicit_class_handle '.' | package_scope)? hierarchical_variable_identifier nonrange_select
                         ;


// A.8.6 - Operators
unary_operator : '+'
               | '-'
               | '!'
               | '~'
               | '&'
               | '~&'
               | '|'
               | '~|'
               | '^'
               | '~^'
               | '^~'
               ;

binary_operator : '+'
                | '-'
                | '*'
                | '/'
                | '%'
                | '=='
                | '!='
                | '==='
                | '!=='
                | '==?'
                | '!=?'
                | '&&'
                | '||'
                | '**'
                | '<'
                | '<='
                | '>'
                | '>='
                | '&'
                | '|'
                | '^'
                | '^~'
                | '~^'
                | '>>'
                | '<<'
                | '>>>'
                | '<<<'
                | '->'
                | '<->'
                ;

inc_or_dec_operator : '++'
                    | '--'
                    ;

unary_module_path_operator : '!'
                           | '~'
                           | '&'
                           | '~&'
                           | '|'
                           | '~|'
                           | '^'
                           | '~^'
                           | '^~'
                           ;

binary_module_path_operator : '=='
                            | '!='
                            | '&&'
                            | '||'
                            | '&'
                            | '|'
                            | '^'
                            | '^~'
                            | '~^'
                            ;


// A.8.7 - Numbers

number : integral_number
       | real_number
       ;

integral_number : decimal_number
                | octal_number
                | binary_number
                | hex_number
                ;

decimal_number : unsigned_number
               | size? decimal_base unsigned_number
               | size? decimal_base x_digit '_'*
               | size? decimal_base z_digit '_'*
               ;

binary_number : size? binary_base binary_value
              ;

octal_number : size? octal_base octal_value
             ;

hex_number : size? hex_base hex_value
           ;

sign : '+'
     | '-'
     ;

size : non_zero_unsigned_number
     ;

non_zero_unsigned_number : non_zero_decimal_digit ('_' | decimal_digit)*
                         ;

real_number : fixed_point_number
            | unsigned_number ('.' unsigned_number)? exp sign? unsigned_number
            ;

fixed_point_number : unsigned_number '.' unsigned_number
                   ;

exp : 'e'
    | 'E'
    ;

unsigned_number : decimal_digit ('_' | decimal_digit)*
                ;

binary_value : binary_digit ('_' | binary_digit)*
             ;

octal_value : octal_digit ('_' | octal_digit)*
            ;

hex_value : hex_digit ('_' | hex_digit)*
          ;

decimal_base : '\'' ('s' | 'S')? ('d' | 'D')
             ;

binary_base : '\'' ('s' | 'S')? ('b' | 'B')
            ;

octal_base : '\'' ('s' | 'S')? ('o' | 'O')
           ;

hex_base : '\'' ('s' | 'S')? ('h' | 'H')
         ;

non_zero_decimal_digit : '1'
                       | '2'
                       | '3'
                       | '4'
                       | '5'
                       | '6'
                       | '7'
                       | '8'
                       | '9'
                       ;

decimal_digit : '0'
              | '1'
              | '2'
              | '3'
              | '4'
              | '5'
              | '6'
              | '7'
              | '8'
              | '9'
              ;

binary_digit : x_digit
             | z_digit
             | '0'
             | '1'
             ;

octal_digit : x_digit
            | z_digit
            | '0'
            | '1'
            | '2'
            | '3'
            | '4'
            | '5'
            | '6'
            | '7'
            ;

hex_digit : x_digit
          | z_digit
          | '0'
          | '1'
          | '2'
          | '3'
          | '4'
          | '5'
          | '6'
          | '7'
          | '8'
          | '9'
          | 'a'
          | 'b'
          | 'c'
          | 'd'
          | 'e'
          | 'f'
          | 'A'
          | 'B'
          | 'C'
          | 'D'
          | 'E'
          | 'F'
          ;

x_digit : 'x'
        | 'X'
        ;

z_digit : 'z'
        | 'Z'
        | '?'
        ;

unbased_unsized_literal : '\'0'
                        | '\'1'
                        | '\'' z_or_x
                        ;


// A.8.8 - Strings
StringLiteral : '\"' ('\\'. | [^\\"])* '\"'
              ;

// A.9 - General
// A.9.1 - Attributes
attribute_instance : '(*' attr_spec (',' attr_spec)* '*)'
                   ;

attr_spec : attr_name ('=' constant_expression)?
          ;

attr_name : identifier
          ;


// A.9.2 - Comments
// comment : one_line_comment
//         | block_comment
//         ;
//
// one_line_comment : '//' comment_text new_line_char
//                  ;
//
// block_comment : '/*' comment_text '*/'
//               ;
//
// comment_text :  Any_ASCII_character*
//              ;


// A.9.3 - Identifiers
array_identifier : identifier
                 ;

block_identifier : identifier
                 ;

bin_identifier : identifier
               ;

cell_identifier : identifier
                ;

checker_identifier : identifier
                   ;

class_identifier : identifier
                 ;

class_variable_identifier : variable_identifier
                          ;

clocking_identifier : identifier
                    ;

config_identifier : identifier
                  ;

const_identifier : identifier
                 ;

constraint_identifier : identifier
                      ;

covergroup_identifier : identifier
                      ;

covergroup_variable_identifier : variable_identifier
                               ;

cover_point_identifier : identifier
                      ;

cross_identifier : identifier
                 ;

dynamic_array_variable_identifier : variable_identifier
                                  ;

enum_identifier : identifier
                ;

// escaped_identifier : '\' { any_printable_ASCII_character_except_white_space } WhiteSpace
//                    ;

formal_identifier : identifier
                  ;

formal_port_identifier : identifier
                       ;

function_identifier : identifier
                    ;

generate_block_identifier : identifier
                          ;

genvar_identifier : identifier
                  ;

hierarchical_array_identifier : hierarchical_identifier
                              ;

hierarchical_block_identifier : hierarchical_identifier
                              ;

hierarchical_event_identifier : hierarchical_identifier
                              ;

hierarchical_identifier : ('$root' '.')? (identifier constant_bit_select '.')* identifier
                        ;

hierarchical_net_identifier : hierarchical_identifier
                            ;

hierarchical_parameter_identifier : hierarchical_identifier
                                  ;

hierarchical_property_identifier : hierarchical_identifier
                                 ;

hierarchical_sequence_identifier : hierarchical_identifier
                                 ;

hierarchical_task_identifier : hierarchical_identifier
                             ;

hierarchical_tf_identifier : hierarchical_identifier
                           ;

hierarchical_variable_identifier : hierarchical_identifier
                                 ;

identifier : SimpleIdentifier
//            | escaped_identifier
           ;

index_variable_identifier : identifier
                          ;

interface_identifier : identifier
                     ;

interface_instance_identifier : identifier
                              ;

inout_port_identifier : identifier
                      ;

input_port_identifier : identifier
                      ;

instance_identifier : identifier
                    ;

library_identifier : identifier
                   ;

member_identifier : identifier
                  ;

method_identifier : identifier
                  ;

modport_identifier : identifier
                   ;

module_identifier : identifier
                  ;

net_identifier : identifier
               ;

net_type_identifier : identifier
                    ;

output_port_identifier : identifier
                       ;

package_identifier : identifier
                  ;

package_scope : package_identifier '::'
              | '$unit::'
              ;

parameter_identifier : identifier
                     ;

port_identifier : identifier
                ;

production_identifier : identifier
                      ;

program_identifier : identifier
                   ;

property_identifier : identifier
                    ;

ps_class_identifier : package_scope? class_identifier
                    ;

ps_covergroup_identifier : package_scope? covergroup_identifier
                         ;

ps_checker_identifier : package_scope? checker_identifier
                      ;

ps_identifier : package_scope? identifier
              ;

ps_or_hierarchical_array_identifier : implicit_class_handle '.' hierarchical_array_identifier
                                    | class_scope hierarchical_array_identifier
                                    | package_scope hierarchical_array_identifier
                                    | hierarchical_array_identifier
                                    ;

ps_or_hierarchical_net_identifier : package_scope? net_identifier
                                  | hierarchical_net_identifier
                                  ;

ps_or_hierarchical_property_identifier : package_scope? property_identifier
                                       | hierarchical_property_identifier
                                       ;

ps_or_hierarchical_sequence_identifier : package_scope? sequence_identifier
                                       | hierarchical_sequence_identifier
                                       ;

ps_or_hierarchical_tf_identifier : package_scope? tf_identifier
                                 | hierarchical_tf_identifier
                                 ;

ps_parameter_identifier : package_scope parameter_identifier
                        | class_scope parameter_identifier
                        | parameter_identifier
                        | (generate_block_identifier ('[' constant_expression ']')? '.')* parameter_identifier
                        ;

ps_type_identifier : 'local::' type_identifier
                   | package_scope type_identifier
                   | type_identifier
                   ;

sequence_identifier : identifier
                    ;

signal_identifier : identifier
                  ;

specparam_identifier : identifier
                     ;

task_identifier : identifier
                ;

tf_identifier : identifier
              ;

terminal_identifier : identifier
                    ;

topmodule_identifier : identifier
                     ;

type_identifier : identifier
                ;

udp_identifier : identifier
               ;

variable_identifier : identifier
                    ;


// Keyword/Literal Tokenization
WhiteSpace : [ \t\r\n] -> Skip
           ;

T1step : '1step'
       ;

TAcceptOn : 'accept_on'
          ;

TAlias : 'alias'
       ;

TAlwaysComb : 'always_comb'
            ;

TAlwaysFF : 'always_ff'
          ;

TAlwaysLatch : 'always_latch'
             ;

TAlways : 'always'
        ;

TAnd : 'and'
     ;

TAssert : 'assert'
        ;

TAssign : 'assign'
        ;

TAssume : 'assume'
        ;

TAutomatic : 'automatic'
           ;

TBefore : 'before'
        ;

TBegin : 'begin'
       ;

TBind : 'bind'
      ;

TBinsOf : 'binsof'
        ;

TBins : 'bins'
      ;

TBit : 'bit'
     ;

TBreak : 'break'
       ;

TBufif0 : 'bufif0'
        ;

TBufif1 : 'bufif1'
        ;

TBuf : 'buf'
     ;

TByte : 'byte'
      ;

TCase : 'case'
      ;

TCasex : 'casex'
       ;

TCasez : 'casez'
       ;

TCell : 'cell'
      ;

TChandle : 'chandle'
         ;

TChecker : 'checker'
         ;

TClass : 'class'
       ;

TClocking : 'clocking'
          ;

TCmos : 'cmos'
      ;

TConfig : 'config'
        ;

TConstraint : 'constraint'
            ;

TConst : 'const'
       ;

TContext : 'context'
         ;

TContinue : 'continue'
          ;

TCovergroup : 'covergroup'
            ;

TCoverpoint : 'coverpoint'
            ;

TCover : 'cover'
       ;

TCross : 'cross'
       ;

TDeassign : 'deassign'
          ;

TDefault : 'default'
         ;

TDefparam : 'defparam'
          ;

TDesign : 'design'
        ;

TDisable : 'disable'
         ;

TDist : 'dist'
      ;

TDo : 'do'
    ;

TDPI : '"DPI"'
     ;

TDPIC : '"DPI-C"'
      ;

TEdge : 'edge'
      ;

TElse : 'else'
      ;

TEndcase : 'endcase'
         ;

TEndchecker : 'endchecker'
            ;

TEndclass : 'endclass'
          ;

TEndclocking : 'endclocking'
             ;

TEndconfig : 'endconfig'
           ;

TEndfunction : 'endfunction'
             ;

TEndgenerate : 'endgenerate'
             ;

TEndgroup : 'endgroup'
          ;

TEndinterface : 'endinterface'
              ;

Tendmodule : 'endmodule'
           ;

TEndpackage : 'endpackage'
            ;

TEndprimitive : 'endprimitive'
              ;

TEndprogram : 'endprogram'
            ;

TEndproperty : 'endproperty'
             ;

TEndspecify : 'endspecify'
            ;

TEndsequence : 'endsequence'
             ;

TEndtable : 'endtable'
          ;

TEndtask : 'endtask'
         ;

TEnd : 'end'
     ;

TEnum : 'enum'
      ;

TEventually : 'eventually'
            ;

TEvent : 'event'
       ;

TExpect : 'expect'
        ;

TExport : 'export'
        ;

TExtends : 'extends'
         ;

TExtern : 'extern'
        ;

TFinal : 'final'
       ;

TFirstMatch : 'first_match'
            ;

TForce : 'force'
       ;

TForeach : 'foreach'
         ;

TForever : 'forever'
         ;

TForkjoin : 'forkjoin'
          ;

TFork : 'fork'
      ;

TFor : 'for'
     ;

TFunction : 'function'
          ;

TGenerate : 'generate'
          ;

TGenvar : 'genvar'
        ;

TGlobal : 'global'
        ;

THighz0 : 'highz0'
        ;

THighz1 : 'highz1'
        ;

TIff : 'iff'
     ;

TIfnone : 'ifnone'
        ;

TIf : 'if'
    ;

TIgnoreBins : 'ignore_bins'
            ;

TIllegalBins : 'illegal_bins'
             ;

TImplements : 'implements'
            ;

TImplies : 'implies'
         ;

TImport : 'import'
        ;

TIncdir : 'incdir'
        ;

TInclude : 'include'
         ;

TInitial : 'initial'
         ;

TInout : 'inout'
       ;

TInput : 'input'
       ;

TInside : 'inside'
        ;

TInstance : 'instance'
          ;

TInteger : 'integer'
         ;

TInterconnect : 'interconnect'
              ;

TInterface : 'interface'
           ;

TIntersect : 'intersect'
           ;

TInt : 'int'
     ;

TJoinAny : 'join_any'
         ;

TJoinNone : 'join_none'
          ;

TJoin : 'join'
      ;

TLarge : 'large'
       ;

TLet : 'let'
     ;

TLiblist : 'liblist'
         ;

TLibrary : 'library'
         ;

TLocal : 'local'
       ;

TLocalparam : 'localparam'
            ;

TLogic : 'logic'
       ;

TLongint : 'longint'
         ;

TMacromodule : 'macromodule'
             ;

TMatches : 'matches'
         ;

TMedium : 'medium'
        ;

TModport : 'modport'
         ;

TModule : 'module'
        ;

TNand : 'nand'
      ;

TNegedge : 'negedge'
         ;

TNettype : 'nettype'
         ;

TNew : 'new'
     ;

TNexttime : 'nexttime'
          ;

TNmos : 'nmos'
      ;

TNor : 'nor'
     ;

TNoshowcancelled : 'noshowcancelled'
                 ;

TNotif0 : 'notif0'
        ;

TNotif1 : 'notif1'
        ;

TNot : 'not'
     ;

TNull : 'null'
      ;

TOption : 'option'
        ;

TOr : 'or'
    ;

TOutput : 'output'
        ;

TPackage : 'package'
         ;

TPacked : 'packed'
        ;

TParameter : 'parameter'
           ;

TPathpulse : 'PATHPULSE$'
           ;

TPmos : 'pmos'
      ;

TPosedge : 'posedge'
         ;

TPrimitive : 'primitive'
           ;

TPriority : 'priority'
          ;

TProgram : 'program'
         ;

TProperty : 'property'
          ;

TProtected : 'protected'
           ;

TPull0 : 'pull0'
       ;

TPull1 : 'pull1'
       ;

TPulldown : 'pulldown'
          ;

TPullup : 'pullup'
        ;

TPulsestyleOndetect : 'pulsestyle_ondetect'
                    ;

TPulsestyleOnevent : 'pulsestyle_onevent'
                   ;

TPure : 'pure'
      ;

TRandcase : 'randcase'
          ;

TRandc : 'randc'
       ;

TRandsequence : 'randsequence'
              ;

TRandomize : 'randomize'
           ;

TRand : 'rand'
      ;

TRcmos : 'rcmos'
       ;

TReal : 'real'
      ;

TRealtime : 'realtime'
          ;

TRef : 'ref'
     ;

TReg : 'reg'
     ;

TRejectOn : 'reject_on'
          ;

TRelease : 'release'
         ;

TRepeat : 'repeat'
        ;

TRestrict : 'restrict'
          ;

TReturn : 'return'
        ;

TRnmos : 'rnmos'
       ;

TRpmos : 'rpmos'
       ;

TRtranif0 : 'rtranif0'
          ;

TRtranif1 : 'rtranif1'
          ;

TRtran : 'rtran'
       ;

TSample : 'sample'
        ;

TSAlways : 's_always'
         ;

TSEventually : 's_eventually'
              ;

TSNexttime : 's_nexttime'
           ;

TSUntil : 's_until'
        ;

TSUntilWith : 's_until_with'
            ;

TScalared : 'scalared'
          ;

TSequence : 'sequence'
          ;

TShortint : 'shortint'
          ;

TShortreal : 'shortreal'
           ;

TShowcancelled : 'showcancelled'
               ;

TSigned : 'signed'
        ;

TSmall : 'small'
       ;

TSoft : 'soft'
      ;

TSolve : 'solve'
       ;

TSpecify : 'specify'
         ;

TSpecparam : 'specparam'
           ;

TStatic : 'static'
        ;

TString : 'string'
        ;

TStrong0 : 'strong0'
         ;

TStrong1 : 'strong1'
         ;

TStrong : 'strong'
        ;

TStruct : 'struct'
        ;

TSuper : 'super'
       ;

TSupply0 : 'supply0'
         ;

TSupply1 : 'supply1'
         ;

TSyncAcceptOn : 'sync_accept_on'
              ;

TSyncRejectOn : 'sync_reject_on'
              ;

TTable : 'table'
       ;

TTagged : 'tagged'
        ;

TTask : 'task'
      ;

TThis : 'this'
      ;

TThroughout : 'throughout'
            ;

TTime : 'time'
      ;

TTimeprecision : 'timeprecision'
               ;

TTimeunit : 'timeunit'
          ;

TTranif0 : 'tranif0'
         ;

TTranif1 : 'tranif1'
         ;

TTran : 'tran'
      ;

TTri0 : 'tri0'
      ;

TTri1 : 'tri1'
      ;

TTriand : 'triand'
        ;

TTrior : 'trior'
       ;

TTrireg : 'trireg'
        ;

TTri : 'tri'
     ;

TTypedef : 'typedef'
         ;

TTypeOption : 'type_option'
            ;

TType : 'type'
      ;

TUnion : 'union'
       ;

TUnique0 : 'unique0'
         ;

TUnique : 'unique'
        ;

TUnsigned : 'unsigned'
          ;

TUntilWith : 'until_with'
           ;

TUntil : 'until'
       ;

TUntyped : 'untyped'
         ;

TUse : 'use'
     ;

TUwire : 'uwire'
       ;

TVar : 'var'
     ;

TVectored : 'vectored'
          ;

TVirtual : 'virtual'
         ;

TVoid : 'void'
      ;

TWaitOrder : 'wait_order'
           ;

TWait : 'wait'
      ;

TWand : 'wand'
      ;

TWeak0 : 'weak0'
       ;

TWeak1 : 'weak1'
       ;

TWeak : 'weak'
      ;

TWhile : 'while'
       ;

TWildcard : 'wildcard'
          ;

TWire : 'wire'
      ;

TWithin : 'within'
        ;

TWith : 'with'
      ;

TWor : 'wor'
     ;

TXnor : 'xnor'
      ;

TXor : 'xor'
     ;

SystemTFIdentifier : '$'[a-zA-Z0-9_$][a-zA-Z0-9_$]*
                   ;

SimpleIdentifier : [a-zA-Z_][a-zA-Z0-9_$]*
                 ;

CIdentifier : [a-zA-Z_][a-zA-Z0-9_]*
            ;
