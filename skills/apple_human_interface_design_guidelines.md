# 🎨 Apple Human Interface Design Guidelines Skills

This document defines the core foundations, spacing metrics, typography rules, accessibility requirements, and platform-specific paradigms for developing applications that align perfectly with Apple's **Human Interface Guidelines (HIG)** and comply fully with our **Obsessive UI Alignment & Visual Balance** guidelines.

---

## 📌 1. Layout, Grids & Margins

Clean layouts establish a sense of structure, hierarchy, and horizontal/vertical balance across all interface views.

### A. Core Layout Principles
* **Read-Flow Dominance**: Place high-priority content near the top-leading corner of a panel or window (adjusted automatically for right-to-left languages).
* **Safe Areas**: Respect system-provided safe areas to avoid clipping interactive elements under physical bezels, camera notches, or software home indicators.
  * **iOS / iPadOS**: Always inset elements to respect standard side margins. Avoid full-screen edge-clipping buttons.
  * **macOS**: Avoid placing critical controls at the very bottom border of a window, as users frequently move window frames partially off-screen.
  * **tvOS**: Inset all primary content by at least **60 pt** vertically and **80 pt** horizontally from the screen borders.
  * **watchOS**: Design views to render edge-to-edge; the physical screen bezel serves as the natural visual frame.

### B. Standard Grids & Alignment Spacing
* **Shared Baselines**: All adjacent elements (e.g. headers in sidebars and main panels) **must align horizontally along a shared grid baseline**.
* **tvOS Two-Column Layout**: Use an unfocused column width of **860 pt**, horizontal grid gap of **40 pt**, and vertical item gaps of at least **100 pt**. Maintain symmetrical peeking offsets for items hanging off-screen.
* **visionOS Hover Separation**: Center-to-center distances between adjacent interactive components must be at least **60 pt** to ensure precise visual hover-targeting and ease of eye-gaze selection.

### C. Reference Display Dimensions
| Device Target | Points (pt) | Scale Factor | Size Classes (Width / Height) |
| :--- | :---: | :---: | :---: |
| **iPhone 17 Pro / 17** | $402 \times 874$ pt | @3x | Compact / Regular |
| **iPhone Pro Max** | $430 \times 932$ pt | @3x | Compact / Regular |
| **iPad Pro 12.9"** | $1024 \times 1366$ pt | @2x | Regular / Regular |
| **iPad Air 11"** | $820 \times 1180$ pt | @2x | Regular / Regular |

---

## ✍️ 2. Typography & Dynamic Type

System fonts are designed for extreme legibility, high contrast, and dynamic resizing across all displays.

### A. Font Families & Optical Adjustments
* **San Francisco (SF)**: Default sans-serif family, including `SF Pro`, `SF Pro Rounded`, `SF Compact` (watchOS complications), and `SF Mono`.
* **New York (NY)**: Elegant system serif font.
* **Optical Sizing**: The system automatically adjusts tracking, line-spacing, and optical font weights depending on size (Display vs. Text configurations).

### B. Size Constraints & Defaults (pt)
| Platform | Default Size | Minimum Size | Primary Metric Weight |
| :--- | :---: | :---: | :--- |
| **iOS / iPadOS** | 17 pt | 11 pt | Bold / Semibold |
| **macOS** | 13 pt | 10 pt | Regular / Medium |
| **visionOS** | 17 pt | 12 pt | Medium / Bold |
| **watchOS** | 16 pt | 12 pt | Semibold |
| **tvOS** | 29 pt | 23 pt | Medium |

### C. Dynamic Type Adaptation
* **No Truncation**: Never let text clip under large Accessibility options. Avoid fixed horizontal width boxes or multi-column layouts under large fonts.
* **Vertical Stacking Fallbacks**: When Dynamic Type scales, dynamically switch horizontal layouts (e.g., standard horizontal metadata rows) to vertical layouts (`VStack`) to accommodate scaled text.
* **visionOS Typography**: Prefer flat 2D typographic labels over extruded 3D models for optimal readability. Use white as the base text color. For labels placed in 3D space, implement **billboarding** (constantly rotating to face the user).

---

## 🎨 3. Color, Transparency & Materials

Colors and materials should feel alive, adapting dynamically to system contexts while preserving high contrast.

### A. Core Practices
* **P3 Color Space**: Standardize on the **Display P3** wide color space (saved as 16-bit per channel PNGs) for maximum vibrancy. Fall back automatically to sRGB.
* **Semantic over Hardcoded**: Avoid hardcoded hex values (e.g., `#333333`). Always utilize semantic tokens (e.g., `.label` or `.secondarySystemBackground` in iOS, `labelColor` in macOS) so elements auto-adapt to appearance toggles.
* **Vibrancy & Materials**: Use system materials (e.g. standard material, thick material, thin material) to blur background elements and elevate foreground readability.
  * **iOS**: Leverages base background tokens (`systemBackground`) and grouped background tokens (`systemGroupedBackground`).
  * **macOS**: Renders dynamic window materials integrating system accent colors and desktop wallpaper tinting.
  * **visionOS**: Incorporates glass materials where physical surroundings bleed through. Limit color exclusively to prominent text buttons or active status highlights.

---

## 🌗 4. Dark Mode Integrations

All applications must support Dark Mode natively without requiring manual in-app toggle settings.

* **Layer Elevation Separation**:
  - **Base Backgrounds**: Dimmer, deeper gray values used for full-screen backplanes.
  - **Elevated Backgrounds**: Brighter gray tones automatically triggered on overlays, modal sheets, cards, and popovers to present a physical sense of layering and depth.
* **macOS Desktop Tinting**: Windows under standard accent preferences automatically inherit subtle color tints from the user's active desktop wallpaper. Neutral custom components should leverage dynamic transparency to blend in.
* **Exclusions**: 
  - **visionOS** does not support Dark Mode (glass interfaces utilize natural surrounding lighting).
  - **watchOS** is permanently black-background optimized.

---

## ♿️ 5. Accessibility & Ergonomics (WCAG AA)

Designing for accessibility ensures anyone can navigate the interface with absolute comfort.

### A. Color Contrast Ratios
* **Standard Text (up to 17 pt)**: Minimum contrast ratio of **4.5:1** against the background.
* **Large Text (18 pt+) or Bold Fonts**: Minimum contrast ratio of **3:1**.
* **High Contrast Variants**: Support dedicated high-contrast palettes when the user enables *Increase Contrast*.

### B. Control & Interactive Hit-Targets (pt)
All buttons, icons, and toggles must be easily clickable. Ensure padding scales gracefully:
* **iOS / iPadOS / watchOS**: Minimum **$44 \times 44$ pt** (Default), **$28 \times 28$ pt** (Min absolute hit target).
* **macOS**: Minimum **$28 \times 28$ pt** (Default), **$20 \times 20$ pt** (Min absolute hit target).
* **tvOS**: Minimum **$66 \times 66$ pt** (Default), **$56 \times 56$ pt** (Min absolute hit target).
* **visionOS**: Minimum **$60 \times 60$ pt** (Default), **$28 \times 28$ pt** (Min absolute hit target).

### C. Spacing & Ergonomics
* **Padding Clearances**: Maintain at least **12 pt** of padding around bezeled buttons, and **24 pt** for flat, unbezeled text buttons to secure hit spacing.
* **Input Options**: Ensure complete layout compatibility with *Full Keyboard Access*, *Voice Control*, *Switch Control*, and *Assistive Access*.
* **Motion & Animation Constraints**: Respect the system *Reduce Motion* toggle. Disable depth zooming, replace complex 3D screen morphs with clean cross-fades, and stabilize background focus reference elements.

---

## 🚀 6. Platform-Specific Paradigms

Ensure all designs respect the physical interaction styles of each native platform.

### A. iOS & iPadOS (Handheld Ergonomics)
* **Thumb Zone Dominance**: Place critical interactive items (navigation bars, primary action buttons) in the middle and bottom thirds of the screen. Keep secondary reading metrics at the top.
* **Minimize Input Friction**: Leverage native hardware features (FaceID, Apple Pay, calendar and location sensors) to bypass boring manual typing workflows.

### B. macOS (Stationed Productivity)
* **Information Density**: Deliver clean, multi-column layouts with high data density. Keep nested modal sheets to an absolute minimum.
* **System Integration**: Implement standard system shortcuts, support complete keyboard navigation, and integrate active status elements into the macOS **Menu Bar**.

### C. visionOS (Spatial Computing)
* **Infinite Spatial Canvas**: Launch standard content inside clean window panes in the user's *Shared Space*. Reserve immersion views (*Full Space*) strictly for active games, movie rendering, or deep simulation states.
* **Eye-Gaze Navigation**: Users navigate by looking at elements (hover-targeting) and tap by resting their hands comfortably on their lap. Avoid forcing users to raise their arms.
* **Visual Comfort**: Anchor spatial UI elements within the wearer's comfortable horizontal and vertical field of view to prevent neck strain.

---

## 🛑 7. App Store Review Bottlenecks & Compliance Policy

To secure immediate App Store approval, apps must adhere strictly to physical, functional, and programmatic boundaries set by Apple.

### A. Prohibited Mechanics Audit
Any new concept or feature proposal must be actively audited against App Store Review Guidelines. Flag any proposed mechanisms that bypass sandbox isolation or rely on:
* **Dynamic External Code Loading (Guideline 2.5.2)**: Downloading, installing, or executing external scripts, dynamic libraries, or runtime packages that are not compiled directly into the binary.
* **Private API / System Manipulation**: Attempting to hook into private system classes, bypass sandbox restrictions, or execute OS-level settings modifications.
* **Minimum Functionality (Guideline 4.2)**: Creating simple web wrappers or basic utilities that lack rich, platform-specific user experiences.

### B. Proactive Risk Alerting Policy
If a design, concept, or feature architecture triggers these risk vectors—suggesting we would be blocked from standard App Store reviews (forcing self-hosting, enterprise distribution, or web-only workarounds):
* **Immediately halt work** before writing a single line of code.
* **Present a detailed risk-compliance audit to Oliver**, detailing exactly why it is an App Store trap and outlining compliant design alternatives.

### C. Documented Rejection Traps & Historical Learnings
* **The "Editorial" Trap (Dynamic Code / Web Wrappers)**: Do not propose self-hosting or web-based workarounds for apps that rely on external dynamic code execution (violating Guideline 2.5.2 or 4.2). Apple will reject it. Flag this risk at the **concept stage** before building anything.
* **macOS Background Apps & Menu Bars (Guideline 4 - Design)**: If a macOS app stays running in the background after its main window is closed, it **must** have a Menu Bar item (e.g., `Window > Main Window`) to reopen it. Relying solely on clicking the Dock icon is a guaranteed rejection. If no custom menu is planned, configure the app to quit entirely when the last window is closed (e.g., via `applicationShouldTerminateAfterLastWindowClosed` returning `true`).
