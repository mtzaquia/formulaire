import Foundation
import SwiftUI

@attached(member, names: named(validate), named(__allKeyPaths))
@attached(extension, conformances: Formulaire)
public macro Formulaire() = #externalMacro(module: "FormulaireMacros", type: "FormulaireMacro")

@MainActor
public protocol Formulaire: AnyObject, Observable {
    func validate(errorBuilder: ErrorBuilder<Self>)
    
    static var __allKeyPaths: [PartialKeyPath<Self>] { get }
}

public extension Formulaire {
    func validate(errorBuilder: ErrorBuilder<Self>) {}
}
