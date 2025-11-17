# Formulaire

A lightweight Swift library for building validated, focus-aware forms using Swift macros and SwiftUI. Formulaire provides helpers to render controls, manage focus, and surface validation errors.

## Instalation

Formulaire is available via Swift Package Manager, and requires `Swift 6.2`.

```swift
dependencies: [
  .package(url: "https://github.com/mtzaquia/formulaire.git", from: "1.0.0"),
],
```

## Usage

### Getting Started

Annotate your form model class with `@Observable` and `@Formulaire`, and provide a `validate()` method. Leave it empty for no validation.

```swift
import Observation
import Formulaire

@Observable @Formulaire
final class SignUpForm {
    var firstName: String = ""
    var lastName: String = ""
    var age: Int = 18
    var wantsNewsletter: Bool = true

    func validate() {
        if firstName.isEmpty {
            addError(MissingRequiredField(), for: \.firstName)
        }

        if lastName.isEmpty {
            addError(MissingRequiredField(), for: \.lastName)
        }
    }
}
```

### Building UI

Formulaire ships with a small set of SwiftUI helpers to wire your form to UI controls while managing focus and errors.

```swift
import Formulaire
import SwiftUI

struct SignUpView: View {
    @State private var form = SignUpForm()

    var body: some View {
        FormulaireView(editing: $form) { form in
            form.textField(for: \.firstName, label: "First name")
            form.textField(for: \.lastName, label: "Last name")
            form.stepper(for: \.age, label: "Age", step: 1, range: 0...120)
            form.toggle(for: \.wantsNewsletter, label: "Receive updates?")

            // Use a default submit button...
            form.submitButton("Create Account") {
                // Handle success
                print("Submitted")
            }

            // ... or handle it with your own logic.
            Button("Done!") { 
                let success = form.validate()
                if success {
                    // handle success
                }
            }
        }
        .padding()
    }
}
```

> [!NOTE]
> You can create your own controls using `form.control(for:focusable:content:)`.

## License

Copyright (c) 2025 @mtzaquia

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
