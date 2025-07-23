//
//  FormulaireMacros.swift
//  Formulaire
//
//  Created by Mauricio Tremea Zaquia on 20/07/2025.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros
import SwiftSyntax

@main
struct FormulaireMacros: CompilerPlugin {
    var providingMacros: [Macro.Type] = [
        FormulaireMacro.self
    ]
}
