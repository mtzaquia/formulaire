//
//  Copyright (c) 2025 @mtzaquia
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

/// An indirect reference for the key path of a ``Formulaire`` field.
public typealias FieldPath<F: Formulaire, V> = KeyPath<F.Fields, FormulaireField<F, V>>

/// An abstraction of a formulaire field for a given proeprty of a ``Formulaire`` subject.
@dynamicMemberLookup
public struct FormulaireField<Root, Value>: Hashable {
    let label: String
    let keyPath: WritableKeyPath<Root, Value>

    /// **[Internal use]** You do not instantiate this type directly.
    public init(label: String, keyPath: WritableKeyPath<Root, Value>) {
        self.label = label
        self.keyPath = keyPath
    }

    public subscript<Nested>(
        dynamicMember keyPath: KeyPath<Value.Fields, FormulaireField<Value, Nested>>
    ) -> FormulaireField<Root, Nested> where Value: Formulaire {
        let nested = Value.__fields[keyPath: keyPath]
        return FormulaireField<Root, Nested>(
            label: [self.label, nested.label].joined(separator: "."),
            keyPath: self.keyPath.appending(path: nested.keyPath)
        )
    }

    public subscript<Nested, Wrapped>(
        dynamicMember keyPath: KeyPath<Wrapped.Fields, FormulaireField<Wrapped, Nested>>
    ) -> FormulaireField<Root, Nested> where Value == Optional<Wrapped>, Wrapped: Formulaire {
        let nested = Wrapped.__fields[keyPath: keyPath]
        let composed = self.keyPath
            .appending(path: \Wrapped?.forceUnwrapped)
            .appending(path: nested.keyPath)
        return FormulaireField<Root, Nested>(
            label: [self.label, nested.label].joined(separator: "."),
            keyPath: composed
        )
    }
}

private extension Optional {
    var forceUnwrapped: Wrapped {
        get { self! }
        set { self = newValue }
    }
}
