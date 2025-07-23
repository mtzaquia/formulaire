//  FormulaireMacro.swift
//  Formulaire
//
//  Created by Macro Generator.
//

import SwiftSyntaxMacros
import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxBuilder

public struct FormulaireMacro: MemberMacro, ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        // Check if the type already conforms to Formulaire
        let alreadyConforms = protocols.contains { proto in
            proto.trimmedDescription == "Formulaire"
        }

        if alreadyConforms {
            return []
        }

        return [
            try ExtensionDeclSyntax(
                "extension \(type.trimmed): Formulaire {}"
            )
        ]
    }

    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        // Determine access level of the attached type
        let accessLevels = ["open", "public", "internal", "private", "fileprivate"]
        let accessLevel = declaration.modifiers.first(where: { mod in
            accessLevels.contains(mod.name.text)
        })?.name.text ?? "internal"

        // Note: If possible, update the inheritance clause of the attached type to add ": Formulaire" if not present.
        // The macro system typically cannot modify the type declaration directly here.
        // This would require a separate macro or a different approach.

        // Collect all stored properties
        let properties = declaration.memberBlock.members.compactMap { member -> VariableDeclSyntax? in
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
            \(accessLevel) static var __allKeyPaths: [PartialKeyPath<Self>] {
                \(arrayLiteral)
            }
            """
        )
        return [keyPathsDecl]
    }
}
