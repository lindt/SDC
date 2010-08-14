/**
 * Copyright 2010 Bernard Helyer
 * This file is part of SDC. SDC is licensed under the GPL.
 * See LICENCE or sdc.d for more details.
 */
module sdc.gen.base;

import sdc.compilererror;
import ast = sdc.ast.all;
import sdc.gen.sdcmodule;
import sdc.gen.declaration;


Module genModule(ast.Module astModule)
{
    auto mod = new Module(astModule.tstream.filename);
    try {
        realGenModule(astModule, mod);
    } catch (CompilerError e) {
        mod.dispose();
        throw e;
    }
    return mod;
}

void realGenModule(ast.Module astModule, Module mod)
{
    // Declare all data structures.
    foreach (declDef; astModule.declarationDefinitions) if (declDef.type == ast.DeclarationDefinitionType.Declaration) {
        auto decl = cast(ast.Declaration) declDef.node;
        if (decl.type == ast.DeclarationType.Variable) {
            declareVariableDeclaration(cast(ast.VariableDeclaration) decl.node, mod);
        }
    }
    
    // Declare functions.
    foreach (declDef; astModule.declarationDefinitions) {
        declareDeclarationDefinition(declDef, mod);
    }
    
    // Generate the code for the functions.
    foreach (declDef; astModule.declarationDefinitions) {
        genDeclarationDefinition(declDef, mod);
    }
}

void declareDeclarationDefinition(ast.DeclarationDefinition declDef, Module mod)
{
    switch (declDef.type) {
    case ast.DeclarationDefinitionType.Declaration:
        declareDeclaration(cast(ast.Declaration) declDef.node, mod);
        break;
    default:
        error(declDef.location, "ICE: unhandled DeclarationDefinition.");
    }
}

void genDeclarationDefinition(ast.DeclarationDefinition declDef, Module mod)
{
    switch (declDef.type) {
    case ast.DeclarationDefinitionType.Declaration:
        genDeclaration(cast(ast.Declaration) declDef.node, mod);
        break;
    default:
        error(declDef.location, "ICE: unhandled DeclarationDefinition.");
    }
}
