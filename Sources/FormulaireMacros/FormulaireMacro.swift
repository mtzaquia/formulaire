//  FormulaireMacro.swift
//  Formulaire
//
//  Created by Macro Generator.
//

import Foundation
import SwiftSyntaxMacros
import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxBuilder

struct FormulaireDiagnosticMessage: DiagnosticMessage {
    let message: String
    let diagnosticID: MessageID
    let severity: DiagnosticSeverity

    init(message: String, severity: DiagnosticSeverity = .warning) {
        self.message = message
        self.severity = severity
        self.diagnosticID = MessageID(domain: "FormulaireMacro", id: "FormulaireDiagnostic")
    }
}

public struct FormulaireMacro: MemberMacro, ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        // Ensure macro is only applied to classes
        if declaration.as(ClassDeclSyntax.self) == nil {
            context.diagnose(Diagnostic(
                node: Syntax(declaration),
                message: FormulaireDiagnosticMessage(
                    message: "@Formulaire can only be applied to classes.",
                    severity: .error
                )
            ))
            return []
        }

        if let inheritanceClause = declaration.inheritanceClause,
           inheritanceClause.inheritedTypes.contains(
            where: {
                ["Formulaire"].contains($0.type.trimmedDescription)
            }
           )
        {
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
        // Ensure macro is only applied to classes
        if declaration.as(ClassDeclSyntax.self) == nil {
            context.diagnose(Diagnostic(
                node: Syntax(declaration),
                message: FormulaireDiagnosticMessage(
                    message: "@Formulaire can only be applied to classes.",
                    severity: .error
                )
            ))
            return []
        }

        // Determine access level of the attached type
        let accessLevels = ["open", "public", "internal", "private", "fileprivate"]
        let accessLevel = declaration.modifiers.first(where: { mod in
            accessLevels.contains(mod.name.text)
        })?.name.text ?? "internal"

        // Extract the type name from the declaration
        let typeName: String = (declaration.as(ClassDeclSyntax.self)?.identifier.text) ?? "Self"

        // Check if the type is annotated with @Observable
        let hasObservable = declaration.attributes.contains { attr in
            if let attrId = attr.as(AttributeSyntax.self)?.attributeName.as(IdentifierTypeSyntax.self)?.name.text {
                return attrId == "Observable"
            }
            return false
        }
        if !hasObservable {
            context.diagnose(Diagnostic(
                node: Syntax(declaration),
                message: FormulaireDiagnosticMessage(
                    message: "Types using @Formulaire should also be annotated with @Observable.",
                    severity: .warning
                )
            ))
        }

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
        
        // Build the nested Fields struct conforming to FieldsProtocol, with Cases enum
        let fieldsStructProperties = properties.compactMap { varDecl -> String? in
            guard let binding = varDecl.bindings.first,
                  let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text,
                  let typeAnnotation = binding.typeAnnotation?.type.description.trimmingCharacters(in: .whitespacesAndNewlines) else {
                return nil
            }
            return "var \(identifier): FormulaireField<\(typeName), \(typeAnnotation)> { FormulaireField(label: .\(identifier), keyPath: \\\(typeName).\(identifier)) }"
        }.joined(separator: "\n        ")

        let fieldsEnumCases = properties.compactMap { varDecl -> String? in
            guard let binding = varDecl.bindings.first,
                  let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text else {
                return nil
            }
            return "case \(identifier)"
        }.joined(separator: "\n            ")

        let fieldsStructDecl = DeclSyntax(stringLiteral:
            """
            struct Fields: FieldsProtocol {
                enum Cases: String, CaseIterable, Hashable {
                    \(fieldsEnumCases)
                }
                \(fieldsStructProperties)
            }
            
            @ObservationIgnored
            var __fields: Fields = Fields()
            """
        )
        

        return [fieldsStructDecl]
    }
}
