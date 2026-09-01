import Foundation

func currentMode() -> String {
    UserDefaults.standard.string(forKey: "AppleInterfaceStyle") == "Dark" ? "dark" : "light"
}

var lastMode = currentMode()

func syncTheme() {
    lastMode = currentMode()

    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/bin/sh")
    process.arguments = ["-lc", "exec \"$HOME/.local/bin/dotfiles-macos-appearance\" sync"]

    do {
        try process.run()
        process.waitUntilExit()
    } catch {
        FileHandle.standardError.write(Data("dotfiles appearance sync failed: \(error)\n".utf8))
    }
}

syncTheme()

let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
    let mode = currentMode()
    if mode != lastMode {
        syncTheme()
    }
}

withExtendedLifetime(timer) {
    RunLoop.main.run()
}
