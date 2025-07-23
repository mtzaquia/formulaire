//  FormulaireMacro.swift
//  Formulaire
//
//  Created by Macro Generator.
//

import SwiftSyntaxMacros
import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxBuilder

public struct FormulaireMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf decl: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        // Collect all stored properties
        let properties = decl.memberBlock.members.compactMap { member -> VariableDeclSyntax? in
            guard let varDecl = member.decl.as(VariableDeclSyntax.self),
                  varDecl.bindings.count == 1,
                  !varDecl.modifiers.contains(where: { $0.name.text == "static" || $0.name.text == "class" }) else { return nil }
            return varDecl
        }
        // Build the array of keyPaths
        let keyPaths = properties.compactMap { varDecl -> String? in
            guard let binding = varDecl.bindings.first,
                  let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text else { return nil }
            return "\\Self." + identifier
        }
        let arrayLiteral = "[" + keyPaths.joined(separator: ", ") + "]"
        let keyPathsDecl = DeclSyntax(stringLiteral:
            """
            public static var __allKeyPaths: [PartialKeyPath<Self>] {
                return \(arrayLiteral)
            }
            """
        )
        return [keyPathsDecl]
    }
}
