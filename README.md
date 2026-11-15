# Alpha Omega Ekklesia — Official Mobile Client

Official white-label Flutter application for **Alpha Omega Ekklesia** (Chennai, Tamil Nadu, India), built on top of the reusable **Church Core Platform Engine** (`church_digital_platform_mobile`).

## Church Identity & Profile

| Property | Value |
| :--- | :--- |
| **Church Name** | **Alpha Omega Ekklesia** |
| **Location** | Chennai, Tamil Nadu, India |
| **Tradition** | Anglo-Indian Church Tradition |
| **Clergy / Pastors** | Pastor Larry Joshua Augustus & Pastor Soma Augustus |
| **Giving Method** | Direct UPI Intent & VPA (`larryjoshuaa@oksbi`) |
| **Application ID** | `org.aoekklesia.alpha_omega_ekklesia_mobile` |

## Brand Palette

- **Primary (Midnight Navy)**: `#18284A` (Cross & $\Omega$)
- **Secondary (Celestial Gold)**: `#BA9A45` (Holy Spirit Flame & $\alpha$)
- **Canvas Background**: `#F8FAFC` / `#FFFFFF`

## Core Navigation Surfaces

1. **Home Feed & Pastoral Welcome**: Scripture banner (*Revelation 22:13*), personal greeting from Pastors Larry & Soma Augustus, weekly Anglo-Indian service schedule, and quick actions.
2. **Direct UPI Offerings & Giving**: One-tap preset amounts (`₹200` to `₹5,000`), ministry fund selector, direct `upi://pay` intent launch (`Google Pay`, `PhonePe`, `Paytm`, `BHIM`) to `larryjoshuaa@oksbi`, and manual VPA clipboard copy fallback.
3. **Intercessory Prayer Wall**: Community prayer petitions with interactive `"I'm Praying"` counters and confidential `"Pastoral Care Only"` submission option.
4. **Hymns & Worship Setlists**: Traditional Anglo-Indian hymns and contemporary praise songs with musical keys, tempo/BPM, and full choir lyrics.

## Development & Build

```bash
# Run static analysis
flutter analyze --fatal-infos

# Run unit & widget tests
flutter test

# Build signed Android Release APK
flutter build apk --release
```
