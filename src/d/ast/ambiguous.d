module d.ast.ambiguous;

import d.ast.base;
import d.ast.declaration;
import d.ast.expression;
import d.ast.identifier;
import d.ast.type;

class TypeOrExpression : Node, Namespace {
	Type type;
	Expression expression;
	
	this(Type type, Expression expression) in {
		assert(type.location == expression.location, "type and expression must represent parsing of the same source code.");
	} body {
		/*
		if(type.location != expression.location) {
			import sdc.terminal;
			outputCaretDiagnostics(type.location, "type " ~ type.location.toString());
			outputCaretDiagnostics(type.location, "expression " ~ expression.location.toString());
			
			assert(0, "type and expression must represent parsing of the same source code.");
		}
		*/
		super(type.location);
		
		this.type = type;
		this.expression = expression;
		
		import sdc.terminal;
		outputCaretDiagnostics(type.location, "Ambiguity : this can be type or expression.");
	}
	
	override Declaration resolve(Scope s) {
		auto typeDecl = type.resolve(s);
		auto expressionDecl = expression.resolve(s);
		
		if(typeDecl) {
			assert(!expressionDecl, "ambiguous stuff is ambiguous !");
			
			return typeDecl;
		}
		
		return expressionDecl;
	}
}
