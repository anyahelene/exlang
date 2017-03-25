module exlang::evaluator::ExValues
import exlang::frontend::ExSyntax;
import String;
import ParseTree;
import IO;

alias Name = str;


public Env env() {
	return [];
}

public bool isDefined(Name name, Env env) {
	return name in env<0>;
}

public list[Type] lookupTypes(Name name, Env env) {
	return env[name]<0>;
}

public list[Value] lookupDefs(Name name, Env env) {
	return env[name]<1>;
}

public Value lookupDef(Name name, Type typ, Env env) {
	rs = env[name,typ]<0>;
	if([r] := rs) {
		return r;
	}
	else if(rs == []) {
		throw "Unknown: <name>:<typ>";
	}
	else {
		throw "Ambiguity: <name>:<typ>";
	}
}

public Value lookupAttrs(Name name, Type typ, Env env) {
	rs = env[name,typ]<1>;
	if([r] := rs) {
		return r;
	}
	else if(rs == []) {
		throw "Unknown: <name>:<typ>";
	}
	else {
		throw "Ambiguity: <name>:<typ>";
	}
}


data Value
	= Int(int i)
	| Real(real r)
	| Object(rel[str,Type,Value] fields)
	| Choice(set[Value] values)
	| Method(Value obj, Operation op)
	| Function(Operation op)
	| Class()
	| Interface()
	;
	
data Operation
	= Operation(lrel[str,Type] params, Type retType, Statement body)
	;
	
data Type
	= IntType()
	| RealType()
	| ObjectType(str name)
	| ChoiceType(set[Type] types)
	| VoidType()
	| OperationType(list[Type] paramTypes, Type retType)
	;

alias Env
	= list[tuple[str name, Type typ, Value def, map[Name,Value] attrs]]
	;
	
	
public tuple[Value,Type,Env] eval((Expression)`<Name varName>`, Env env) {
	n = unparse(varName);
	if(n in env) {
		<v,t> = env[n];
		return <v,t,env>;
	}
	else {
		throw "Unknown variable <varName>";
	}
}

public tuple[Value,Type,Env] eval((Expression)`<INT i>`, Env env) {
	return <Int(toInt(unparse(i))), IntType(), env>;
}

public tuple[Value,Type,Env] eval((Expression)`<Expression e1> == <Expression e2>`, Env env) {
	<v1,t1,env> = eval(e1, env);
	<v2,t2,env> = eval(e2, env);
	return <Bool(v1 == v2), BoolType(), env>;
}

public tuple[Value,Type,Env] eval((Expression)`<Expression e1> = <Expression e2>`, Env env) {
	<v1,t1,env> = evalLValue(e1, env);
	<v2,t2,env> = eval(e2, env);
	
	if(t1 == t2) {
		if((Expression)`<Name varName>` := v1) {
			env[unparse(varName)] = <v2,t2>;
			return <v2, t2, env>;
		}
		else {
			throw "Not a variable: <v1>";
		}
	}
	else {
		throw "Incompatible types: <t1>, <t2>";
	}
}

public tuple[Value,Type,Env] eval((Expression)`<Expression e1>.<Name fieldName>`, Env env) {
	n = unparse(fieldName);
	<v,t> = eval(e1, env);
	
	if(Object(fields) := v) {
		choices = fields[n];
		
		return <Choice(choices<0>), ChoiceType(choices<1>), env>;
	}
	else {
		throw "Selector applied to non-object";
	}
}

public str toString(Int(i)) = "<i>";
public str toString(Real(r)) = "<r>";
public str toString(Object(fields)) = "{<intercalate(", ", ["<n>=<toString(v)>" | <n,_,v> <- fields])>}";
public str toString(Choice(cs)) = "{<intercalate(" | ", [toString(v) | v <- cs])>}";
public str toString(IntType()) = "int";
public str toString(RealType()) = "real";
public str toString(ObjectType(name)) = name;
public str toString(ChoiceType(cs)) = "(<intercalate(" | ", [toString(v) | v <- cs])>)";
public void print(tuple[Value,Type,Env] result) {
	println("<toString(result[0])> : <toString(result[1])>");
}