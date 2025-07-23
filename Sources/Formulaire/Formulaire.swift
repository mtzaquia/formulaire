import Foundation
import SwiftUI

@MainActor
public protocol Formulaire: AnyObject, Observable {
    func validate(errorBuilder: ErrorBuilder<Self>)
}

public extension Formulaire {
    func validate(errorBuilder: ErrorBuilder<Self>) {}
}
