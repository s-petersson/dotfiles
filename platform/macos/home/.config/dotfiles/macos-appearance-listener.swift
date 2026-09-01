import Foundation

func syncTheme() {
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

withExtendedLifetime(observer) {
    RunLoop.main.run()
}
