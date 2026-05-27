# Postal v4.3.0 — WotLK 3.3.5 backport

<p align="center">
  <img src="Postal.png" alt="Postal icon" width="64" height="64"/>
</p>

<p align="center">
  <b>Enhanced mailbox support for World of Warcraft 3.3.5a (WotLK).</b><br>
  <i>Backport of Postal v4.3.0 from WotLK Classic.</i>
</p>

<p align="center">
  <a href="#english">English</a> ·
  <a href="#russian">Русский</a>
</p>

---

<a name="english"></a>
## English

<p align="center">
  <a href="#features">Features</a> ·
  <a href="#installation">Installation</a> ·
  <a href="#modules">Modules</a> ·
  <a href="#usage">Usage</a> ·
  <a href="#license">License</a>
</p>

### About

**Postal** improves the default mailbox interface with tools for bulk mail
handling, contacts management, autocomplete, mail forwarding, and more.

This repository is a **backport of Postal v4.3.0 from WotLK Classic to WoW
3.3.5a (WotLK client)**.

### Features

- 📬 **OpenAll** — open mail of selected types (AH, with attachments, etc.). Shift-click - no filters.
- ✅ **Select** — checkboxes, bulk open/return. Shift - range, Ctrl - all from sender.
- 📋 **BlackBook** — contacts next to To: field, autocomplete from Alts, Friends, Guild.
- ⚡ **Express** — Shift-click - take, Ctrl-click - return, Alt-click - attach from bags.
- 🔗 **CarbonCopy** — copy mail contents.
- 🚫 **DoNotWant** — shows return or delete on expiry.
- 🛡 **TradeBlock** — block trades and guild invites at mailbox.
- 📝 **Wire** — auto-fill subject with coin amount.
- 💰 **Rake** — gold summary from opened mail.
- 📤 **Forward** — forward mail to another character.
- 📎 **QuickAttach** — quick-attach trade items; default recipient per type.
- ⚙ **Profile system** — per-character or shared profiles.

### Installation

1. Download the latest release (or clone this repository).
2. Extract the archive.
3. **Important:** GitHub ZIP extracts as `Postal-3.3.5-backport-master`.
   Rename it to **`Postal`**. WoW requires the folder name to match the addon.
4. Move the `Postal` folder into:
   ```
   \Interface\AddOns\
   ```


### Modules

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

### Usage

| Input | Action |
| --- | --- |
| **Right-click** Postal icon (top-right of mailbox) | Open settings menu |
| **Shift-click** inbox item | Take item/money |
| **Ctrl-click** inbox item | Return mail |
| **Alt-click** inventory item | Attach to outgoing mail |
| **Shift-click** OpenAll button | Open all mail (ignore filters) |

### Changelog (backport)

**v4.3.0** — initial backport (WotLK Classic → 3.3.5a)
- Replaced all `C_Container.*`/`C_Item.*` calls with old API + version guards
- Fixed `GetInboxItem` unpacking (5 returns in all WoW versions)
- Fixed `GetSendMailItem` unpacking (4 returns in WotLK, no `itemID`)
- Fixed `GetContainerItemID` → `GetContainerItemLink` + `strmatch` in WotLK paths
- Fixed Express bag button hooks (WotLK XML stores direct function refs — per-button `RawHookScript` instead of global `RawHook`)
- Fixed Alt+Click auto-send matching (texture+count instead of itemID)
- Fixed QuickAttach type matching (itemType/subType strings from `GetItemInfo` positions 6/7)
- Fixed `xpcall` extra-arg bug (Lua 5.1)
- Fixed Lua 5.1 closure `...` scoping
- Fixed all nil-global guards
- Fixed Forward.lua: `MailEditBox.ScrollBox` → `SendMailBodyEditBox` (Cata+ structure absent in 3.3.5)
- Fixed Wire.lua ruRU locale patterns (double quantifier `%d++`)
- `select(10, GetContainerItemInfo)` → only 7 returns in WotLK
- `locked` check as number `== 1`, not boolean

### Compatibility

- Built and tested on **WoW 3.3.5a** (Interface `30300`).
- Tested on Warmane. Should work on any WotLK 3.3.5(a) private server.

### License

Released under the terms of the [LICENSE](LICENSE.txt) file.

### Credits

- Original addon: **Xinhuan**
- Contributors: Ammo, Rabbit, Grennon, Mikk, oscarucb, Jonny
- WotLK 3.3.5 backport: **Keoo (Warmane)**
- Libraries: LibStub, CallbackHandler-1.0, AceAddon-3.0, AceEvent-3.0,
  AceDB-3.0, AceHook-3.0, AceLocale-3.0

---

<a name="russian"></a>
## Русский

<p align="center">
  <img src="Postal.png" alt="Postal icon" width="64" height="64"/>
</p>

<p align="center">
  <b>Расширенная поддержка почтового ящика для WoW 3.3.5a (WotLK).</b><br>
  <i>Бэкпорт Postal v4.3.0 с WotLK Classic.</i>
</p>

<p align="center">
  <a href="#особенности">Особенности</a> ·
  <a href="#установка">Установка</a> ·
  <a href="#модули">Модули</a> ·
  <a href="#использование">Использование</a> ·
  <a href="#лицензия">Лицензия</a>
</p>

### Об аддоне

**Postal** расширяет стандартный почтовый интерфейс: массовая работа с
письмами, список контактов, автодополнение имён, пересылка писем и многое
другое.

Этот репозиторий — **бэкпорт Postal v4.3.0 с WotLK Classic под WoW 3.3.5a (WotLK)**.

### Особенности

- 📬 **OpenAll** — массовое открытие писем по типу (аукцион, с вложениями...). Shift - без фильтров.
- ✅ **Select** — отмечайте письма флажками, открывайте или возвращайте разом. Shift - выделить диапазон, Ctrl - все от адресата.
- 📋 **BlackBook** — список контактов рядом с полем «Кому», подсказки из альтов, друзей, гильдии.
- ⚡ **Express** — Shift - забрать вложение, Ctrl - вернуть письмо, Alt - прикрепить предмет из сумки.
- 🔗 **CarbonCopy** — копирует содержимое любого письма.
- 🚫 **DoNotWant** — показывает, вернётся письмо или удалится по сроку.
- 🛡 **TradeBlock** — блокирует обмен и приглашения в гильдию у почты.
- 📝 **Wire** — сам заполняет тему письма суммой денег.
- 💰 **Rake** — сколько золота получено из писем.
- 📤 **Forward** — переслать письмо другому персонажу.
- 📎 **QuickAttach** — быстро прикрепить хозтовары из сумок. Можно указать получателя по умолчанию.
- ⚙ **Профили** — отдельные настройки для каждого персонажа или общий профиль для всех.

### Установка

1. Скачайте последний релиз (или клонируйте репозиторий).
2. Распакуйте архив.
3. **Важно:** GitHub ZIP распаковывается в `Postal-3.3.5-backport-master`.
   Переименуйте папку в **`Postal`**. WoW требует точного совпадения имени
   папки с названием аддона.
4. Переместите папку `Postal` в:
   ```
   \Interface\AddOns\
   ```


### Модули

| Модуль | Описание |
| --- | --- |
| BlackBook | Список контактов, альты, автодополнение |
| CarbonCopy | Копирование содержимого письма |
| DoNotWant | Иконки срока давности писем |
| Express | Горячие клавиши (Shift/Ctrl/Alt+клик) |
| Forward | Пересылка письма другому персонажу |
| OpenAll | Массовое открытие писем с фильтрами |
| QuickAttach | Быстрое прикрепление предметов |
| Rake | Сводка заработанного золота |
| Select | Чекбоксы + массовое открытие/возврат |
| TradeBlock | Блокировка торговли у почты |
| Wire | Авто-заполнение темы суммой денег |

### Использование

| Действие | Результат |
| --- | --- |
| **Правый клик** по иконке Postal (справа сверху у почты) | Меню настроек |
| **Shift+клик** по письму | Взять предмет/деньги |
| **Ctrl+клик** по письму | Вернуть письмо |
| **Alt+клик** по предмету в сумке | Прикрепить к письму |
| **Shift+клик** по кнопке OpenAll | Открыть все письма (без фильтров) |

### Список изменений (бэкпорт)

**v4.3.0** — первый бэкпорт (WotLK Classic → 3.3.5a)
- Все `C_Container.*`/`C_Item.*` заменены на старый API + guards
- Исправлена распаковка `GetInboxItem` (5 значений во всех версиях WoW)
- Исправлена распаковка `GetSendMailItem` (4 значения в WotLK, нет `itemID`)
- `GetContainerItemID` → `GetContainerItemLink` + `strmatch` в WotLK
- Исправлены хуки кнопок сумок (WotLK XML хранит прямые ссылки — `RawHookScript` на каждую кнопку)
- Исправлено авто-отправление Alt+Click (сравнение texture+count вместо itemID)
- Исправлено QuickAttach сопоставление типов (itemType/subType из `GetItemInfo` позиции 6/7)
- Исправлен баг `xpcall` с лишними аргументами (Lua 5.1)
- Исправлена область видимости `...` в замыканиях Lua 5.1
- Исправлены все nil-global guards
- Исправлен Forward.lua: `MailEditBox.ScrollBox` → `SendMailBodyEditBox`
- Исправлены ruRU паттерны в Wire.lua (двойной квантификатор `%d++`)
- `select(10, GetContainerItemInfo)` → всего 7 значений в WotLK
- `locked` проверка как число `== 1`, не boolean

### Совместимость

- Собрано и протестировано на **WoW 3.3.5a** (Interface `30300`).
- Протестировано на Warmane. Должно работать на любом WotLK 3.3.5(a) сервере.

### Лицензия

Распространяется на условиях файла [LICENSE](LICENSE.txt).

### Благодарности

- Оригинальный аддон: **Xinhuan**
- Участники: Ammo, Rabbit, Grennon, Mikk, oscarucb, Jonny
- Бэкпорт под WotLK 3.3.5: **Keoo (Warmane)**
- Библиотеки: LibStub, CallbackHandler-1.0, AceAddon-3.0, AceEvent-3.0,
  AceDB-3.0, AceHook-3.0, AceLocale-3.0
