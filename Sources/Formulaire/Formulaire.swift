import Foundation
import SwiftUI

@attached(member, names: named(__formulaireFields))
@attached(extension, conformances: Formulaire)
public macro Formulaire() = #externalMacro(module: "FormulaireMacros", type: "FormulaireMacro")

@MainActor
public protocol Formulaire: AnyObject {
    func validate(checker: FormulaireChecker<Self>)
    static var __formulaireFields: [FormulaireField<Self>] { get }
}

public struct FormulaireField<F: Formulaire>: Hashable {
    let label: String
    let keyPath: PartialKeyPath<F>

    public init<V>(label: String, keyPath: WritableKeyPath<F, V>) {
        self.label = label
        self.keyPath = keyPath
    }
}
