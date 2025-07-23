// This test uses swift-macro-testing (or MacroTesting) to verify the actual expansion of FormulaireMacro.
// It does not simulate; it asserts macro expansion output.
import MacroTesting
import SwiftSyntaxMacros
import Testing
import FormulaireMacros

@Suite(
    .macros(
        ["Formulaire": FormulaireMacro.self],
        record: .all
    )
)
struct FormulaireMacrosTests {
    @Test func testAllKeyPathsExpansion() {
        assertMacro {
            """
            @Formulaire @Observable
            final class TestStruct {
                var x: Int
                var y: Int
            }
            """
        } diagnostics: {
            """

            """
        } expansion: {
            #"""
            struct TestStruct {
                var x: Int
                var y: Int

                internal static var __allKeyPaths: [PartialKeyPath<Self>] {
                    [\Self.x, \Self.y]
                }
            }

            extension TestStruct: Formulaire {
            }
            """#
        }
    }
}
