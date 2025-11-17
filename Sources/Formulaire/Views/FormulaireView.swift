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

import SwiftUI

final class Wrapper<T> {
    var value: T

    init(value: T) {
        self.value = value
    }
}

public struct FormulaireView<F: Formulaire, C: View>: View {
    @Binding private var subject: F
    @FocusState private var focus: String?

    private let builder: (FormulaireBuilder<F>) -> C
    private let renderedFields: Wrapper<[String]> = .init(value: [])

    public var body: some View {
        ScrollViewReader { proxy in
            Form {
                let _ = renderedFields.value.removeAll()

                builder(
                    FormulaireBuilder<F>(
                        formulaire: $subject,
                        focus: $focus,
                        renderedFields: renderedFields
                    )
                )

                let _ = print(renderedFields.value)
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Group {
                        Button(
                            action: { [fields = renderedFields.value] in
                                guard let currentIndex = focus.flatMap({ fields.firstIndex(of: $0) })
                                else { return }

                                if currentIndex - 1 >= 0 {
                                    let previous = fields[currentIndex - 1]
                                    withAnimation(.snappy) {
                                        proxy.scrollTo(previous)
                                    }

                                    focus = previous
                                }
                            },
                            label: {
                                Label("Previous", systemImage: "chevron.up")
                            }
                        )
                        .disabled(focus.flatMap({ renderedFields.value.firstIndex(of: $0) }) == 0)

                        Button(
                            action: { [fields = renderedFields.value] in
                                guard let currentIndex = focus.flatMap({ fields.firstIndex(of: $0) })
                                else { return }

                                if currentIndex + 1 < fields.count {
                                    let next = fields[currentIndex + 1]
                                    withAnimation(.snappy) {
                                        proxy.scrollTo(next)
                                    }

                                    focus = next
                                }
                            },
                            label: {
                                Label("Next", systemImage: "chevron.down")
                            }
                        )
                        .disabled(
                            focus.flatMap({ renderedFields.value.firstIndex(of: $0) }) == renderedFields.value.count - 1
                        )

                        Color.clear.frame(maxWidth: .infinity)

                        Button(
                            action: { focus = nil },
                            label: {
                                Label("Done", systemImage: "checkmark")
                                    .labelStyle(.iconOnly)
                            }
                        )
                        .bold()
                    }
                }
            }
        }
    }

    public init(
        editing subject: Binding<F>,
        @ViewBuilder builder: @escaping (FormulaireBuilder<F>) -> C
    ) {
        self._subject = subject
        self.builder = builder
    }
}
