import Foundation
import SwiftUI

@attached(member, names: named(Fields), named(__fields))
@attached(extension, conformances: Formulaire)
public macro Formulaire() = #externalMacro(module: "FormulaireMacros", type: "FormulaireMacro")

public protocol FieldsProtocol {
    associatedtype Cases: CaseIterable, Hashable
}

public protocol Formulaire: AnyObject {
    func validate(checker: FormulaireChecker<Self>)

    associatedtype Fields: FieldsProtocol
    static var __fields: Fields { get }
}

public extension Formulaire {
    func validate(checker: FormulaireChecker<Self>) {}
}
