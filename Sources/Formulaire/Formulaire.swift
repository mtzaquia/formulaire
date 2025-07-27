import Foundation
import SwiftUI

@attached(member, names: named(Fields), named(__fields))
@attached(extension, conformances: Formulaire)
public macro Formulaire() = #externalMacro(module: "FormulaireMacros", type: "FormulaireMacro")

public protocol FieldsProtocol {
    associatedtype Cases: CaseIterable, Hashable
}

@MainActor
public protocol Formulaire: AnyObject {
    func validate(checker: FormulaireChecker<Self>)

    associatedtype Fields: FieldsProtocol
    var __fields: Fields { get }
}

public struct FormulaireField<F: Formulaire, V>: Hashable {
    public let label: F.Fields.Cases
    public let keyPath: WritableKeyPath<F, V>

    public init(label: F.Fields.Cases, keyPath: WritableKeyPath<F, V>) {
        self.label = label
        self.keyPath = keyPath
    }
}
