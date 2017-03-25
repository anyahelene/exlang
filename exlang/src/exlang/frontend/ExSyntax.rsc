module exlang::frontend::ExSyntax


// DECLARATIONS

start syntax CompilationUnit
	= Declaration*
	;
	
syntax Declaration
	= ImportDeclaration
	| ModuleDeclaration
	| DataDeclaration ";"
	| OperationDeclaration
	;
	
syntax ImportDeclaration
	= ImportDecl: "import" QualifiedNamePattern ";"
	;
	
syntax ModuleDeclaration
	= IfaceDecl: Modifier* "interface" DeclarationName "{" Declaration* "}"
	| ClassDecl: Modifier* "class" DeclarationName "{" Declaration* "}"
	;
	
syntax DataDeclaration
	= ValDecl: Modifier* "val" DeclarationName DataInitializer
	| VarDecl: Modifier* "var" DeclarationName DataInitializer
	| TypedDecl: Modifier* Type DeclarationName DataInitializer
	;

syntax DataInitializer
	= Init: "=" Expression
	| NoInit:
	;

syntax OperationDeclaration
	= ObsDecl: Modifier* Type? DeclarationName "(" {DataDeclaration ","}* ")" OperationBody
	| MutDecl: Modifier* Type? DeclarationName "!" "(" {DataDeclaration ","}* ")" OperationBody
	;

syntax OperationBody
	= ExprBody: "=" Expression ";"
	| StatBody: "{" Statement* "}"
	| NoBody: ";"
	;
	
syntax Modifier
	= "public"
	| "private"
	| "@" QualifiedName
	;
	
syntax Name
	= ID
	;
	
syntax DeclarationName
	= @category="MetaKeyword" Name
	;
	
syntax QualifiedName
	= {Name "."}+
	;

syntax Expression
	= Var: Name
	| Int: INT
	> Call: Expression "(" {Expression ","}* ")"
	> left Selector: Expression "." Name
	> Mutate: Expression "!"
	> left Equals: Expression "==" Expression
	> right Assign: Expression "=" Expression
	;
	
syntax Variable
	= Var: QualifiedName
	;
	
syntax Type
	= @category="Type" Type:  QualifiedName \ KEYWORDS
	;

syntax Statement
	= Declaration
	| Expression ";"
	| "assert" Expression ";"
	;
	
lexical ID
	= [a-zA-Z_] !<< [a-zA-Z_] [a-zA-Z_0-9]* !>> [a-zA-Z_0-9]
	;
	
keyword KEYWORDS = "var" | "val" | "public" | "private";
	
lexical INT
	= [0-9] !<< [0-9]+ !>> [0-9a-fA-F]
	| [0-9] !<< [0] [x] [0-9a-fA-F]+ !>> [0-9a-fA-F]
	| [0-9] !<< [0] [b] [0-1]+ !>> [0-9a-fA-F]
	| [0-9] !<< [0] [o] [0-7]+ !>> [0-9a-fA-F]
	;
	
layout WHITESPACE
	= [\ \t\n\r\f]* !>> [\ \t\n\r\f]
	;
