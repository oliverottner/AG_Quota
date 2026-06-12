//
//  main.swift
//  AGQuota
//
//  Created by Oliver Ottner on 12.06.2026.
//  Copyright © 2026 Oliver Ottner. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.
//

import AppKit
import Foundation
import ServiceManagement

// gRPC-Web / Connect response structures
struct QuotaSummaryResponse: Codable {
    struct ResponseData: Codable {
        let groups: [QuotaGroup]
    }
    let response: ResponseData
}

struct QuotaGroup: Codable {
    let displayName: String
    let buckets: [QuotaBucket]
}

struct QuotaBucket: Codable {
    let bucketId: String
    let displayName: String
    let remainingFraction: Double
    let resetTime: String // ISO 8601 string
    let window: String
}

struct LSConfig {
    let port: Int
    let token: String
}

class HelpWindowController: NSObject {
    let window: NSWindow
    
    init(iconImage: NSImage) {
        let windowWidth: CGFloat = 760
        let windowHeight: CGFloat = 600
        
        let styleMask: NSWindow.StyleMask = [.titled, .closable]
        let rect = NSRect(x: 0, y: 0, width: windowWidth, height: windowHeight)
        
        let win = NSWindow(contentRect: rect, styleMask: styleMask, backing: .buffered, defer: false)
        win.title = "AG Quota Help"
        win.isReleasedWhenClosed = false
        win.level = .floating
        self.window = win
        
        super.init()
        
        guard let contentView = win.contentView else { return }
        
        // --- CENTERED ICON (Top of the window) ---
        let iconSize: CGFloat = 140
        let iconX = (windowWidth - iconSize) / 2 // Centered in the whole window
        let iconY = windowHeight - iconSize - 24
        let imageView = NSImageView(frame: NSRect(x: iconX, y: iconY, width: iconSize, height: iconSize))
        imageView.image = iconImage
        imageView.imageScaling = .scaleProportionallyUpOrDown
        imageView.imageAlignment = .alignCenter
        contentView.addSubview(imageView)
        
        // Both columns start at the same vertical position below the icon
        let contentStartY = iconY - 20
        
        // --- LEFT COLUMN ---
        let leftColX: CGFloat = 20
        let leftColWidth: CGFloat = 340
        
        // 1. Title Field
        let titleField = NSTextField(labelWithString: "How does AG Quota work?")
        titleField.frame = NSRect(x: leftColX, y: contentStartY - 24, width: leftColWidth, height: 24)
        titleField.font = NSFont.boldSystemFont(ofSize: 15)
        titleField.alignment = .left
        titleField.textColor = .labelColor
        contentView.addSubview(titleField)
        
        // 2. Intro Text Field
        let introAttrText = NSMutableAttributedString()
        let introFont = NSFont.systemFont(ofSize: 12)
        let introParagraphStyle = NSMutableParagraphStyle()
        introParagraphStyle.alignment = .left
        introParagraphStyle.lineSpacing = 4
        
        let introText = """
This app retrieves quota data directly from your local Antigravity Language Server running on your Mac.

The app is automatically refreshed every 30 seconds to stay relatively real-time without overwhelming your local server.
"""
        introAttrText.append(NSAttributedString(string: introText, attributes: [
            .font: introFont,
            .foregroundColor: NSColor.labelColor,
            .paragraphStyle: introParagraphStyle
        ]))
        
        let introField = NSTextField(frame: NSRect(x: leftColX, y: titleField.frame.origin.y - 120 - 12, width: leftColWidth, height: 120))
        introField.isEditable = false
        introField.isSelectable = true
        introField.drawsBackground = false
        introField.isBordered = false
        introField.alignment = .left
        introField.cell?.wraps = true
        introField.cell?.isScrollable = false
        introField.attributedStringValue = introAttrText
        contentView.addSubview(introField)
        
        // 3. Copyright Info Field
        let infoAttrText = NSMutableAttributedString()
        let infoFont = NSFont.systemFont(ofSize: 11)
        let infoBoldFont = NSFont.boldSystemFont(ofSize: 11)
        let infoParagraphStyle = NSMutableParagraphStyle()
        infoParagraphStyle.alignment = .left
        infoParagraphStyle.lineSpacing = 5
        
        infoAttrText.append(NSAttributedString(string: "AG Quota\n", attributes: [
            .font: infoBoldFont,
            .foregroundColor: NSColor.labelColor,
            .paragraphStyle: infoParagraphStyle
        ]))
        
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.1.2"
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "18"
        infoAttrText.append(NSAttributedString(string: "Version \(version) (\(build))\nCopyright © 2026 Oliver Ottner\nwww.iservice.at // All rights reserved.\nMade with love in Europe", attributes: [
            .font: infoFont,
            .foregroundColor: NSColor.secondaryLabelColor,
            .paragraphStyle: infoParagraphStyle
        ]))
                let infoField = NSTextField(frame: NSRect(x: leftColX, y: introField.frame.origin.y - 105 - 12, width: leftColWidth, height: 105))
        infoField.isEditable = false
        infoField.isSelectable = true
        infoField.drawsBackground = false
        infoField.isBordered = false
        infoField.alignment = .left
        infoField.cell?.wraps = true
        infoField.cell?.isScrollable = false
        infoField.attributedStringValue = infoAttrText
        contentView.addSubview(infoField)
        
        // --- VERTICAL DIVIDER ---
        // Raised the bottom to y: 90 so it terminates above the centered Close button instead of passing through it,
        // and lowered the top to contentStartY so it doesn't cross the centered icon.
        let divider = NSBox(frame: NSRect(x: 379, y: 90, width: 2, height: contentStartY - 90))
        divider.boxType = .separator
        contentView.addSubview(divider)
        
        // --- RIGHT COLUMN ---
        let rightColX: CGFloat = 400
        let rightColWidth: CGFloat = 340
        
        // 1. Heading Label (Starts at the same Y as the Left Column Title)
        let headingField = NSTextField(labelWithString: "Why are credentials not required?")
        headingField.frame = NSRect(x: rightColX, y: contentStartY - 24, width: rightColWidth, height: 24)
        headingField.font = NSFont.boldSystemFont(ofSize: 15)
        headingField.textColor = .labelColor
        headingField.alignment = .left
        contentView.addSubview(headingField)
        
        // 2. List Text View
        let listParagraphStyle = NSMutableParagraphStyle()
        listParagraphStyle.alignment = .left
        listParagraphStyle.lineSpacing = 4
        listParagraphStyle.paragraphSpacing = 12
        listParagraphStyle.firstLineHeadIndent = 0
        listParagraphStyle.headIndent = 16
        
        let listFont = NSFont.systemFont(ofSize: 12)
        let listBoldFont = NSFont.boldSystemFont(ofSize: 12)
        
        let listAttributes: [NSAttributedString.Key: Any] = [
            .font: listFont,
            .foregroundColor: NSColor.labelColor,
            .paragraphStyle: listParagraphStyle
        ]
        
        let listBoldAttributes: [NSAttributedString.Key: Any] = [
            .font: listBoldFont,
            .foregroundColor: NSColor.labelColor,
            .paragraphStyle: listParagraphStyle
        ]
        
        let listAttrText = NSMutableAttributedString()
        
        listAttrText.append(NSAttributedString(string: "1. ", attributes: listBoldAttributes))
        listAttrText.append(NSAttributedString(string: "Process Scan: The app scans active running processes to find the Antigravity 'language_server'.\n", attributes: listAttributes))
        
        listAttrText.append(NSAttributedString(string: "2. ", attributes: listBoldAttributes))
        listAttrText.append(NSAttributedString(string: "Token Extraction: It extracts the dynamic port number and the active CSRF security token (x-codeium-csrf-token) used by your editor.\n", attributes: listAttributes))
        
        listAttrText.append(NSAttributedString(string: "3. ", attributes: listBoldAttributes))
        listAttrText.append(NSAttributedString(string: "Local Queries: It queries the local endpoint over loopback HTTP (127.0.0.1) using the session token.\n", attributes: listAttributes))
        
        listAttrText.append(NSAttributedString(string: "4. ", attributes: listBoldAttributes))
        listAttrText.append(NSAttributedString(string: "Your credentials (like API keys or passwords) are never requested, stored, or sent over the network.", attributes: listAttributes))
        
        let listTextView = NSTextView(frame: NSRect(x: rightColX, y: headingField.frame.origin.y - 290 - 12, width: rightColWidth, height: 290))
        listTextView.isEditable = false
        listTextView.isSelectable = true
        listTextView.drawsBackground = false
        listTextView.isVerticallyResizable = false
        listTextView.isHorizontallyResizable = false
        listTextView.textContainer?.containerSize = NSSize(width: rightColWidth, height: CGFloat.greatestFiniteMagnitude)
        listTextView.textContainer?.widthTracksTextView = true
        listTextView.textStorage?.setAttributedString(listAttrText)
        contentView.addSubview(listTextView)
        
        // 3. Close Button (centered at the bottom of the window width)
        let closeBtn = GradientCloseButton()
        closeBtn.title = "Close"
        closeBtn.target = self
        closeBtn.action = #selector(closeClicked)
        let closeBtnWidth: CGFloat = 340
        let closeBtnX = (windowWidth - closeBtnWidth) / 2
        closeBtn.frame = NSRect(x: closeBtnX, y: 24, width: closeBtnWidth, height: 45)
        closeBtn.keyEquivalent = "\r"
        contentView.addSubview(closeBtn)
    }
    
    @objc func closeClicked() {
        NSApplication.shared.stopModal()
        window.close()
    }
    
    func show() {
        window.makeKeyAndOrderFront(nil)
        window.center()
        NSApplication.shared.runModal(for: window)
    }
}

class GradientCloseButton: NSButton {
    override func draw(_ dirtyRect: NSRect) {
        let colors = [
            NSColor(red: 220/255.0, green: 20/255.0, blue: 20/255.0, alpha: 1.0), // Red
            NSColor(red: 245/255.0, green: 100/255.0, blue: 20/255.0, alpha: 1.0), // Orange
            NSColor(red: 245/255.0, green: 210/255.0, blue: 20/255.0, alpha: 1.0)  // Yellow
        ]
        
        // Draw main gradient
        let path = NSBezierPath(roundedRect: bounds, xRadius: 8, yRadius: 8)
        NSGraphicsContext.current?.saveGraphicsState()
        path.addClip()
        if let gradient = NSGradient(colors: colors) {
            gradient.draw(in: bounds, angle: 270)
        }
        NSGraphicsContext.current?.restoreGraphicsState()
        
        // Overlay for highlighted state
        if self.isHighlighted {
            NSColor.black.withAlphaComponent(0.2).setFill()
            let highlightPath = NSBezierPath(roundedRect: bounds, xRadius: 8, yRadius: 8)
            highlightPath.fill()
        }
        
        // Draw text
        let text = self.title
        let font = NSFont.boldSystemFont(ofSize: 15) // Slightly larger text to match button
        
        let shadow = NSShadow()
        shadow.shadowColor = NSColor.black.withAlphaComponent(0.6)
        shadow.shadowOffset = NSSize(width: 0, height: -1.5)
        shadow.shadowBlurRadius = 2.0
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: NSColor.white,
            .shadow: shadow
        ]
        
        let textSize = text.size(withAttributes: attributes)
        let textRect = NSRect(
            x: (bounds.width - textSize.width) / 2,
            y: (bounds.height - textSize.height) / 2,
            width: textSize.width,
            height: textSize.height
        )
        text.draw(in: textRect, withAttributes: attributes)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var timer: Timer?
    var helpWindowController: HelpWindowController?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Register default preferences
        UserDefaults.standard.register(defaults: [
            "showGemini": true,
            "showClaude": true,
            "showRefreshTime": true,
            "showTimeframe": true
        ])
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            button.attributedTitle = NSAttributedString(string: " AG Quota: Loading... ")
            button.action = #selector(menuClicked)
            button.target = self
        }
        
        setupMenu()
        
        // Refresh every 30 seconds to be relatively real-time
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            self?.refreshQuota()
        }
        
        refreshQuota()
    }
    
    func setupMenu() {
        let menu = NSMenu()
        
        let geminiItem = NSMenuItem(title: "Gemini", action: #selector(toggleGemini), keyEquivalent: "")
        geminiItem.target = self
        geminiItem.state = UserDefaults.standard.bool(forKey: "showGemini") ? .on : .off
        menu.addItem(geminiItem)
        
        let claudeItem = NSMenuItem(title: "Claude/GPT", action: #selector(toggleClaude), keyEquivalent: "")
        claudeItem.target = self
        claudeItem.state = UserDefaults.standard.bool(forKey: "showClaude") ? .on : .off
        menu.addItem(claudeItem)
        
        let refreshItem = NSMenuItem(title: "Show Refresh", action: #selector(toggleShowRefresh), keyEquivalent: "")
        refreshItem.target = self
        refreshItem.state = UserDefaults.standard.bool(forKey: "showRefreshTime") ? .on : .off
        menu.addItem(refreshItem)
        
        let timeframeItem = NSMenuItem(title: "Timeframe", action: #selector(toggleTimeframe), keyEquivalent: "")
        timeframeItem.target = self
        timeframeItem.state = UserDefaults.standard.bool(forKey: "showTimeframe") ? .on : .off
        menu.addItem(timeframeItem)
        
        let autostartItem = NSMenuItem(title: "Autostart with System", action: #selector(toggleAutostart), keyEquivalent: "")
        autostartItem.target = self
        autostartItem.state = (SMAppService.mainApp.status == .enabled) ? .on : .off
        menu.addItem(autostartItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let howItem = NSMenuItem(title: "How?", action: #selector(showHowPopup), keyEquivalent: "")
        howItem.target = self
        menu.addItem(howItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let quitItem = NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q")
        menu.addItem(quitItem)
        
        statusItem.menu = menu
    }
    
    @objc func menuClicked() {
        // App status items with custom menus handle clicks automatically
    }
    
    @objc func toggleGemini(_ sender: NSMenuItem) {
        let newValue = !UserDefaults.standard.bool(forKey: "showGemini")
        UserDefaults.standard.set(newValue, forKey: "showGemini")
        sender.state = newValue ? .on : .off
        refreshQuota()
    }
    
    @objc func toggleClaude(_ sender: NSMenuItem) {
        let newValue = !UserDefaults.standard.bool(forKey: "showClaude")
        UserDefaults.standard.set(newValue, forKey: "showClaude")
        sender.state = newValue ? .on : .off
        refreshQuota()
    }
    
    @objc func toggleShowRefresh(_ sender: NSMenuItem) {
        let newValue = !UserDefaults.standard.bool(forKey: "showRefreshTime")
        UserDefaults.standard.set(newValue, forKey: "showRefreshTime")
        sender.state = newValue ? .on : .off
        refreshQuota()
    }
    
    @objc func toggleTimeframe(_ sender: NSMenuItem) {
        let newValue = !UserDefaults.standard.bool(forKey: "showTimeframe")
        UserDefaults.standard.set(newValue, forKey: "showTimeframe")
        sender.state = newValue ? .on : .off
        refreshQuota()
    }
    
    @objc func toggleAutostart(_ sender: NSMenuItem) {
        let service = SMAppService.mainApp
        if service.status == .enabled {
            do {
                try service.unregister()
                sender.state = .off
            } catch {
                print("Failed to unregister autostart: \(error)")
            }
        } else {
            do {
                try service.register()
                sender.state = .on
            } catch {
                print("Failed to register autostart: \(error)")
            }
        }
    }
    
    @objc func showHowPopup() {
        // Bring app to front so the window is displayed on top of other windows
        NSApplication.shared.activate(ignoringOtherApps: true)
        
        let icon = NSApp.applicationIconImage ?? NSImage()
        let controller = HelpWindowController(iconImage: icon)
        self.helpWindowController = controller
        controller.show()
        self.helpWindowController = nil
    }
    
    @objc func refreshQuota() {
        fetchQuota { [weak self] attrText in
            DispatchQueue.main.async {
                if let button = self?.statusItem.button {
                    button.attributedTitle = attrText
                }
            }
        }
    }
    
    @objc func quitApp() {
        NSApplication.shared.terminate(nil)
    }
    
    func getLSConfig() -> LSConfig? {
        // 1. Run ps aux to find the running language_server
        let psProcess = Process()
        psProcess.executableURL = URL(fileURLWithPath: "/bin/ps")
        psProcess.arguments = ["aux"]
        
        let psPipe = Pipe()
        psProcess.standardOutput = psPipe
        
        do {
            try psProcess.run()
            
            // Read data first to avoid blocking when output exceeds OS pipe buffer size
            let psData = psPipe.fileHandleForReading.readDataToEndOfFile()
            psProcess.waitUntilExit()
            
            guard let psOutput = String(data: psData, encoding: .utf8) else { return nil }
            
            let lines = psOutput.split(separator: "\n")
            for line in lines {
                if line.contains("language_server") && line.contains("--csrf_token") {
                    let lineStr = String(line)
                    let nsLine = lineStr as NSString
                    let tokenPattern = "--csrf_token\\s+([a-f0-9-]+)"
                    let tokenRegex = try NSRegularExpression(pattern: tokenPattern)
                    guard let tokenMatch = tokenRegex.firstMatch(in: lineStr, options: [], range: NSRange(location: 0, length: nsLine.length)) else {
                        continue
                    }
                    let token = nsLine.substring(with: tokenMatch.range(at: 1))
                    
                    let pidPattern = "^\\s*\\S+\\s+(\\d+)"
                    let pidRegex = try NSRegularExpression(pattern: pidPattern)
                    guard let pidMatch = pidRegex.firstMatch(in: lineStr, options: [], range: NSRange(location: 0, length: nsLine.length)) else {
                        continue
                    }
                    let pid = nsLine.substring(with: pidMatch.range(at: 1))
                    
                    if let port = getLSPort(pid: pid) {
                        return LSConfig(port: port, token: token)
                    }
                }
            }
        } catch {
            print("Error retrieving LS config: \(error)")
        }
        return nil
    }
    
    func getLSPort(pid: String) -> Int? {
        let lsofProcess = Process()
        lsofProcess.executableURL = URL(fileURLWithPath: "/usr/sbin/lsof")
        // Added "-a" to logically AND the process and network filters, preventing massive logs and hangs
        lsofProcess.arguments = ["-a", "-n", "-P", "-p", pid, "-i", "-sTCP:LISTEN"]
        
        let lsofPipe = Pipe()
        lsofProcess.standardOutput = lsofPipe
        
        do {
            try lsofProcess.run()
            
            // Read data first to avoid blocking when output exceeds OS pipe buffer size
            let lsofData = lsofPipe.fileHandleForReading.readDataToEndOfFile()
            lsofProcess.waitUntilExit()
            
            guard let lsofOutput = String(data: lsofData, encoding: .utf8) else { return nil }
            
            let lines = lsofOutput.split(separator: "\n")
            var ports: [Int] = []
            for line in lines {
                let lineStr = String(line)
                let nsLine = lineStr as NSString
                let portPattern = ":(\\d+)\\s+\\(LISTEN\\)"
                let portRegex = try NSRegularExpression(pattern: portPattern)
                if let portMatch = portRegex.firstMatch(in: lineStr, options: [], range: NSRange(location: 0, length: nsLine.length)) {
                    if let port = Int(nsLine.substring(with: portMatch.range(at: 1))) {
                        ports.append(port)
                    }
                }
            }
            
            ports.sort()
            return ports.last // The higher port is HTTP, which we use to bypass SSL validation
        } catch {
            print("Error retrieving port: \(error)")
        }
        return nil
    }
    
    func fetchQuota(completion: @escaping (NSAttributedString) -> Void) {
        guard let config = getLSConfig() else {
            completion(NSAttributedString(string: " AG Quota: Off "))
            return
        }
        
        let urlString = "http://127.0.0.1:\(config.port)/exa.language_server_pb.LanguageServerService/RetrieveUserQuotaSummary"
        guard let url = URL(string: urlString) else {
            completion(NSAttributedString(string: " AG Quota: Err Url "))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(config.token, forHTTPHeaderField: "x-codeium-csrf-token")
        request.httpBody = "{}".data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Fetch error: \(error)")
                completion(NSAttributedString(string: " AG Quota: Err "))
                return
            }
            
            guard let data = data else {
                completion(NSAttributedString(string: " AG Quota: No Data "))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let quotaResponse = try decoder.decode(QuotaSummaryResponse.self, from: data)
                let formattedText = self.formatQuotaSummary(quotaResponse)
                completion(formattedText)
            } catch {
                print("Decoding error: \(error)")
                completion(NSAttributedString(string: " AG Quota: Parse Err "))
            }
        }
        task.resume()
    }
    
    func formatQuotaSummary(_ summary: QuotaSummaryResponse) -> NSAttributedString {
        let showGemini = UserDefaults.standard.bool(forKey: "showGemini")
        let showClaude = UserDefaults.standard.bool(forKey: "showClaude")
        let showRefreshTime = UserDefaults.standard.bool(forKey: "showRefreshTime")
        let showTimeframe = UserDefaults.standard.bool(forKey: "showTimeframe")
        
        if !showGemini && !showClaude {
            return NSAttributedString(string: " AG Quota ")
        }
        
        var geminiBody = showTimeframe ? " Week - ?% // Five Hour - ?%" : " ?% // ?%"
        var claudeBody = showTimeframe ? " Week - ?% // Five Hour - ?%" : " ?% // ?%"
        
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]
        
        let weeklyFormatter = DateFormatter()
        weeklyFormatter.locale = Locale(identifier: "de_DE")
        weeklyFormatter.dateFormat = "d MMMM" // German month names like "Juni"
        
        let fiveHourFormatter = DateFormatter()
        fiveHourFormatter.dateFormat = "HH:mm"
        
        for group in summary.response.groups {
            var weeklyPct = "?%"
            var weeklyTime = ""
            var fiveHourPct = "?%"
            var fiveHourTime = ""
            
            for bucket in group.buckets {
                let pct = Int(round(bucket.remainingFraction * 100))
                let pctStr = "\(pct)%"
                
                var timeStr = ""
                if showRefreshTime, let date = isoFormatter.date(from: bucket.resetTime) {
                    if bucket.window == "weekly" {
                        timeStr = " (\(weeklyFormatter.string(from: date)))"
                    } else if bucket.window == "5h" {
                        timeStr = " (\(fiveHourFormatter.string(from: date)))"
                    }
                }
                
                if bucket.window == "weekly" {
                    weeklyPct = pctStr
                    weeklyTime = timeStr
                } else if bucket.window == "5h" {
                    fiveHourPct = pctStr
                    fiveHourTime = timeStr
                }
            }
            
            let weekLabel = showTimeframe ? "Week - " : ""
            let fiveHourLabel = showTimeframe ? "Five Hour - " : ""
            let bodyStr = " \(weekLabel)\(weeklyPct)\(weeklyTime) // \(fiveHourLabel)\(fiveHourPct)\(fiveHourTime)"
            if group.displayName.contains("Gemini") {
                geminiBody = bodyStr
            } else if group.displayName.contains("Claude") || group.displayName.contains("GPT") {
                claudeBody = bodyStr
            }
        }
        
        let font = NSFont.systemFont(ofSize: NSFont.systemFontSize)
        let boldFont = NSFont.boldSystemFont(ofSize: NSFont.systemFontSize)
        
        let attributedString = NSMutableAttributedString()
        
        if showGemini {
            attributedString.append(NSAttributedString(string: "  GEMINI*", attributes: [.font: boldFont]))
            attributedString.append(NSAttributedString(string: geminiBody, attributes: [.font: font]))
        }
        
        if showGemini && showClaude {
            attributedString.append(NSAttributedString(string: "   ", attributes: [.font: font]))
        }
        
        if showClaude {
            let prefix = showGemini ? "" : "  "
            attributedString.append(NSAttributedString(string: "\(prefix)CLAUDE/GPT*", attributes: [.font: boldFont]))
            attributedString.append(NSAttributedString(string: claudeBody, attributes: [.font: font]))
        }
        
        attributedString.append(NSAttributedString(string: "  ", attributes: [.font: font]))
        
        return attributedString
    }
}

// Start Application
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.accessory)
app.run()
