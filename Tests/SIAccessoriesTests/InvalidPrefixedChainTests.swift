import Foundation
import Testing

@testable import SIAccessories

struct InvalidPrefixedChainTests {
    @Test
    func prefixedKilogramShorthandRemainsUnavailable() throws {
        let result = try typecheck(
            """
            import SIAccessories
            let _ = 10.0.mega.kilogram
            """
        )

        #expect(result.terminationStatus != 0)
        #expect(result.standardError.contains("has no member 'kilogram'"))
    }

    @Test
    func kilogramRemainsDirectOnlyWhilePrefixedGramStaysAvailable() throws {
        let kilogram = try 2.0.kilogram
        let prefixedGram = try 2.0.kilo.gram

        let _: Quantity<Double, Kilogram, Linear> = kilogram
        let _: Quantity<Double, SIPrefixedUnit<Gram, Kilo>, Linear> = prefixedGram

        #expect(kilogram.value == 2.0)
        #expect(prefixedGram.converted(to: Kilogram.self).value == kilogram.value)
    }

    private func typecheck(_ source: String) throws -> ProcessResult {
        let packageRoot = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()

        let buildPath = try runProcess(
            executable: "/usr/bin/env",
            arguments: ["swift", "build", "--show-bin-path"],
            currentDirectory: packageRoot
        )

        #expect(buildPath.terminationStatus == 0)

        let modulesPath = buildPath.standardOutput.trimmingCharacters(in: .whitespacesAndNewlines) + "/Modules"
        let temporaryDirectory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)

        try FileManager.default.createDirectory(at: temporaryDirectory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: temporaryDirectory) }

        let sourceFile = temporaryDirectory.appendingPathComponent("InvalidPrefixedChain.swift")
        try source.write(to: sourceFile, atomically: true, encoding: .utf8)

        return try runProcess(
            executable: "/usr/bin/env",
            arguments: ["swiftc", "-typecheck", "-I", modulesPath, sourceFile.path],
            currentDirectory: packageRoot
        )
    }

    private func runProcess(
        executable: String,
        arguments: [String],
        currentDirectory: URL
    ) throws -> ProcessResult {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: executable)
        process.arguments = arguments
        process.currentDirectoryURL = currentDirectory

        let standardOutputPipe = Pipe()
        let standardErrorPipe = Pipe()
        process.standardOutput = standardOutputPipe
        process.standardError = standardErrorPipe

        try process.run()
        process.waitUntilExit()

        let standardOutputData = standardOutputPipe.fileHandleForReading.readDataToEndOfFile()
        let standardErrorData = standardErrorPipe.fileHandleForReading.readDataToEndOfFile()

        return ProcessResult(
            terminationStatus: process.terminationStatus,
            standardOutput: String(decoding: standardOutputData, as: UTF8.self),
            standardError: String(decoding: standardErrorData, as: UTF8.self)
        )
    }
}

private struct ProcessResult {
    let terminationStatus: Int32
    let standardOutput: String
    let standardError: String
}
