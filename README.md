# Postal v3.6.9c — WotLK 3.3.5 backport

<p align="center">
  <img src="Postal.png" alt="Postal icon" width="64" height="64"/>
</p>

<p align="center">
  <b>Enhanced mailbox support for World of Warcraft 3.3.5a (WotLK).</b><br>
  <i>Backport of Postal v3.6.9c from WotLK Classic.</i>
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

This repository is a **backport of Postal v3.6.9c from WotLK Classic to WoW
3.3.5a (WotLK client)**.

### Features

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

### Installation

1. Download the latest release (or clone this repository).
2. Extract the archive.
3. **Important:** GitHub ZIP extracts as `Postal-3.3.5-backport-master`.
   Rename it to **`Postal`**. WoW requires the folder name to match the addon.
4. Move the `Postal` folder into:
   ```
   World of Warcraft\Interface\AddOns\Postal
   ```
5. Restart the game (or `/reload`) and enable **Postal** in the addon list.

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
  <i>Бэкпорт Postal v3.6.9c с WotLK Classic.</i>
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

Этот репозиторий — **бэкпорт Postal v3.6.9c с WotLK Classic под WoW 3.3.5a (WotLK)**.

### Особенности

- 📬 **OpenAll** — открыть все письма выбранных типов разом (Аукцион,
  не-АХ с вложениями, и т.д.). Shift+клик — игнорировать фильтры.
- ✅ **Select** — чекбоксы на каждом письме + кнопки массового
  открытия/возврата. Shift+клик по двум чекбоксам — выбрать диапазон,
  Ctrl+клик — выбрать все письма от этого отправителя.
- 📋 **BlackBook** — список контактов рядом с полем «Кому»,
  автодополнение из Альтов, Недавних, Друзей и Гильдии.
- ⚡ **Express** — Shift+клик — взять предмет, Ctrl+клик — вернуть письмо,
  Alt+клик — прикрепить предмет из сумки.
- 🔗 **CarbonCopy** — копировать содержимое любого письма.
- 🚫 **DoNotWant** — иконка, показывающая, будет ли письмо возвращено или
  удалено при истечении срока.
- 🛡 **TradeBlock** — блокирует торговлю и приглашения в гильдию у почты.
- 📝 **Wire** — авто-заполнение темы письма суммой денег.
- 💰 **Rake** — сводка заработанного золота из писем.
- 📤 **Forward** — переслать письмо другому персонажу.
- 📎 **QuickAttach** — быстрый доступ к сумкам для прикрепления предметов.
- ⚙ **Система профилей** — отдельные настройки для каждого персонажа или
  общий профиль для альтов.

### Установка

1. Скачайте последний релиз (или клонируйте репозиторий).
2. Распакуйте архив.
3. **Важно:** GitHub ZIP распаковывается в `Postal-3.3.5-backport-master`.
   Переименуйте папку в **`Postal`**. WoW требует точного совпадения имени
   папки с названием аддона.
4. Переместите папку `Postal` в:
   ```
   World of Warcraft\Interface\AddOns\Postal
   ```
5. Перезагрузите игру (или `/reload`) и включите **Postal** в списке
   аддонов.

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
