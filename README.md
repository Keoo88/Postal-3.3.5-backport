# Postal — WotLK 3.3.5 backport

<p align="center">
  <img src="https://www.wowinterface.com/images/info/mailbox.png" alt="Postal icon" width="64" height="64"/>
</p>

<p align="center">
  <b>Enhanced mailbox support for World of Warcraft 3.3.5a (WotLK).</b>
</p>

<p align="center">
  <a href="#features">Features</a> ·
  <a href="#installation">Installation</a> ·
  <a href="#modules">Modules</a> ·
  <a href="#usage">Usage</a> ·
  <a href="#license">License</a>
</p>

---

## About

**Postal** improves the default mailbox interface with tools for bulk mail
handling, contacts management, autocomplete, mail forwarding, and more.

This repository is a **backport of the original Postal addon to WoW 3.3.5a
(WotLK 3.3.5 client)**. The retail version lives at the author's upstream
project.

## Features

- 📬 **OpenAll** — open all mail of selected types at once (Auction House,
  non-AH with attachments, etc.). Shift-click to override filters.
- ✅ **Select** — checkboxes on every inbox item with bulk open/return buttons.
  Shift-click two boxes to select a range, Ctrl-click to select all from the
  same sender.
- 📋 **BlackBook** — contact list next to the To: field with autocomplete from
  Alts, Recently Mailed, Friends and Guild.
- ⚡ **Express** — Shift-click to take items, Ctrl-click to return mail,
  Alt-click to attach inventory items.
- 🔗 **CarbonCopy** — copy the contents of any mail.
- 🚫 **DoNotWant** — shows a visual indicator whether mail will be returned or
  deleted on expiry.
- 🛡 **TradeBlock** — block trades and guild charter invites while at the
  mailbox.
- 📝 **Wire** — auto-fills the subject line with the coin amount when blank.
- 💰 **Rake** — summary of gold earned from opened mail.
- 📤 **Forward** — forward mail contents to another character.
- 📎 **QuickAttach** — quickly attach trade items; set a default recipient per
  item type.
- ⚙ **Profile system** — separate settings per character or shared profiles
  across alts.

## Installation

1. Download the latest release (or clone this repository).
2. Extract / copy the `Postal` folder into:
   ```
   World of Warcraft\Interface\AddOns\Postal
   ```
3. Make sure the folder is named exactly `Postal` and contains
   `Postal.toc` at its root.
4. Restart the game (or `/reload`) and enable **Postal** in the addon list.

## Modules

Postal is split into independent modules. You can disable any module you don't
need from the Postal settings menu (top-right corner of the mailbox frame).

| Module | Description |
| --- | --- |
| BlackBook | Contact list, Alts tracking, autocomplete |
| CarbonCopy | Copy mail contents |
| DoNotWant | Expiry/return icons on inbox items |
| Express | Keyboard shortcuts (Shift/Ctrl/Alt-click) |
| Forward | Forward mail to another character |
| OpenAll | Bulk-open mail by type with filters |
| QuickAttach | Quick-attach trade items |
| Rake | Gold earned summary |
| Select | Checkboxes + bulk open/return |
| TradeBlock | Block trades at mailbox |
| Wire | Auto-fill subject with coin amount |

## Usage

### Mouse controls

| Input | Action |
| --- | --- |
| **Right-click** the Postal icon (top-right of mailbox) | Open settings menu |
| **Shift-click** an inbox item | Take item/money |
| **Ctrl-click** an inbox item | Return mail |
| **Alt-click** inventory item | Attach to outgoing mail |
| **Shift-click** OpenAll button | Open all mail (ignore filters) |

### Profile system

Each character starts with its own profile. To share settings across alts:

1. Open Postal settings → **Profiles** → **New Profile**
2. Name it (e.g. "Shared by Alts")
3. Log your other characters and switch them to the same profile

## Compatibility

- Built and tested on **WoW 3.3.5a** (Interface `30300`).
- All features tested on Warmane.
- Should work on any WotLK 3.3.5 (a) private server.

## License

Released under the terms of the [LICENSE](LICENSE.txt) file in this repository.

## Credits

- Original addon: **Xinhuan**
- Contributors: Ammo, Rabbit, Grennon, Mikk, oscarucb, Jonny
- WotLK 3.3.5 backport: **Keoo (Warmane)**
- Libraries: LibStub, CallbackHandler-1.0, AceAddon-3.0, AceEvent-3.0,
  AceDB-3.0, AceHook-3.0, AceLocale-3.0
