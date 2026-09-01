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

let center = DistributedNotificationCenter.default()
let observer = center.addObserver(
    forName: Notification.Name("AppleInterfaceThemeChangedNotification"),
    object: nil,
    queue: .main
) { _ in
    syncTheme()
}

syncTheme()

let timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
    let mode = currentMode()
    if mode != lastMode {
        syncTheme()
    }
}

withExtendedLifetime((observer, timer)) {
    RunLoop.main.run()
}
