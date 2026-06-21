# AG Quota Monitor - App Store Optimization (ASO) & Marketing Metadata

This file contains the App Store metadata, descriptions, and promotional text designed to make publishing straightforward.

---

## 1. App Store Metadata

### App Title (Max 30 chars)
AG Quota Monitor

### App Subtitle (Max 30 chars)
Local Token Limits At A Glance

### Promotional Text (Max 170 chars)
Monitor your local Gemini & Claude token quotas in real-time from your menu bar. Zero credentials required, 100% local and secure.

### App Store Keywords (Max 100 chars total, comma-separated)
antigravity,quota,token,limit,gemini,claude,gpt,developer,api,menu bar,local,offline,codeium,monitor

---

## 2. App Store Description (Compelling Long Description)

Stay in the flow and never get interrupted by token limits again! 

**AG Quota Monitor** is a native, ultra-lightweight macOS status bar utility built specifically for developers using Google Antigravity. It sits quietly in your menu bar, providing real-time, color-coded visibility into your rolling weekly and 5-hour token limits for Gemini and Claude/GPT models.

### Key Features:
* **Real-Time Tracking:** Auto-refreshes every 30 seconds so you always know how much quota you have remaining.
* **Color-Coded Status:** Instantly see your status with dynamic coloring: Green (>= 50%), Orange (20% - 50%), and Red (< 20%).
* **Customizable Layouts:** Toggle between a compact percentage-only display and a full layout showing exact reset dates and timeframes.
* **Login Autostart:** Optionally launch at login with a simple click to keep monitoring seamless.
* **100% Offline & Private:** No servers, no tracking, and no external requests.

---

## 3. Privacy, Safety & Security (For Suspicious Users)

It is completely natural to be cautious about utilities interacting with your development tools. **AG Quota Monitor is designed with security as its absolute priority.**

### Why No Credentials Are Required
Unlike other monitoring apps, AG Quota Monitor **does not request, store, or transmit your passwords, API keys, or accounts.** Here is exactly how it works under the hood:
1. **Local Discovery:** Standard builds scan local running processes (`ps` and `lsof`) to discover the port and CSRF token of the Antigravity server running on your Mac.
2. **Sandboxed Compatibility:** If running under macOS Sandbox (like the App Store version), you can enter the port and token manually in the settings window.
3. **Local Loopback Communication:** The app queries the local endpoint over loopback HTTP (`127.0.0.1`) using the active session token. 
4. **Data Stays on Your Mac:** All communications happen entirely offline on your local computer. No network connections are made to the internet. Your quota statistics never leave your device.

---

## 4. Maintenance & Compatibility Commitment

Development tools evolve rapidly, and we are committed to keeping this utility working perfectly.

> [!IMPORTANT]
> **Antigravity Engine Updates:** We actively monitor the Antigravity developer ecosystem. In the event of changes to the local server engine—such as API port configurations, token handshakes, or protocol structure—we will release corresponding updates immediately to keep your quota monitor running smoothly.
