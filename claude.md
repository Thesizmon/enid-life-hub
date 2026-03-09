# 🐺 Enid Life Hub — CLAUDE.md

> My Enid-coded life command center 💜  
> GitHub: https://github.com/Thesizmon/enid-life-hub/

---

## Project Overview

A **Progressive Web App (PWA)** personal life dashboard built entirely in vanilla HTML/CSS/JS — no build tools, no frameworks. Each page is a self-contained `.html` file. The app is Enid Sinclair–coded (wolf emoji, hot pink `#E84EA0`, cozy dark vibes). Installable on mobile as a PWA.

---

## Tech Stack

- **Frontend:** Pure HTML, CSS, JS — no frameworks, no npm, no bundler
- **Backend/DB:** Supabase (used in habit tracker, journal, analytics, books)
- **Local Storage:** Used extensively for widget state, finance data, badges, movies
- **PWA:** `manifest.json` + `sw.js` (service worker), installable, standalone display
- **External APIs:**
  - **TMDB (The Movie Database)** — movie search and discovery in `movies.html`
  - **OpenLibrary** — book search (`olSearch`, `olCoverUrl`) in `books.html`
- **Theme color:** `#E84EA0` (hot pink)
- **Background color:** `#FFFBF7`
- **App name:** "Enid's Life Tracker 🐺" / short name "Enid 🐺"
- **Scope/start URL:** `/enid-life-hub/` (GitHub Pages hosted)

---

## File Structure

```
enid-life-hub/
├── index.html             # Main habit/routine tracker (dashboard)
├── finance.html           # Finance tracker (bills, CC, budget periods)
├── journal.html           # Journal with Supabase backend
├── books.html             # Book library (OpenLibrary API + Supabase)
├── movies.html            # Movie watchlist (TMDB API + localStorage)
├── calendar.html          # Calendar/event planner (localStorage)
├── badges.html            # Trophy Room — achievement badges
├── analytics.html         # Habit analytics & heatmaps (Supabase)
├── cards.html             # [3.98MB — too large to view on GitHub, likely a card/study tool]
├── badge_toast_preview.html  # Badge toast UI preview
├── manifest.json          # PWA manifest
└── sw.js                  # Service worker
```

---

## Pages & Features

### `index.html` — 🐺 Enid's Routine Tracker (Main Dashboard)
The heart of the app. A daily habit tracker with:
- **Supabase integration** — reads/writes habit completions
- **Habit lists by day type:**
  - `MORNING_HABITS_WEEKDAY` — weekday morning routine (wake 8AM, no phone, make bed, etc.)
  - `POSTWORK_HABITS` — post-work decompression (change clothes, yoga OR walk w/ orGroup logic, etc.)
  - `WEEKEND_HABITS` — weekend-specific habits
  - `WEEKLY_SHARED` — weekly recurring tasks (finance review, calendar review, etc.)
  - `EVENING_HABITS` — evening wind-down (head home by 10:45PM, home by 11PM, wash face, brush teeth, TV off by 11:20, etc.)
- **`orGroup` logic** — habits can be mutually exclusive (e.g. yoga OR walk — only one needs checked)
- **Day navigation** (`buildDayNav`) — browse past/future days
- **Streak tracking** (`loadStreaks`, `checkResurrection`)
- **Glance card** — overview widget with date, streak chips
- **Weekly review banner** (`renderWeeklyReview`)
- **Widgets on dashboard:** movie widget, book widget, calendar widget
- **Note overlay** — quick daily note/journal entry per habit
- **Reading log overlay** — log pages read from dashboard
- **Pep talk quotes** (`PEP_QUOTES`, `MORNING_QUOTES`)
- **Celebration animations** (`spawnCelebration`, `spawnResurrection`)
- **Push notifications** — service worker notifications, `scheduleNotifications`, `fireNotification`
- **Toast system** (`showToast`)
- **LocalStorage keys:** `enid_books_widget`, `enid_calendar_widget`, `enid_movies_widget`, `enid_seen_badges`
- **Supabase tables used:** `habit_completions`, `custom_habits` (inferred from JS)
- **USER_ID** — hardcoded or set at init for single-user app

---

### `finance.html` — 💰 Enid's Finance Tracker
Full personal finance tracker. Entirely localStorage-based (`enid_finance_v2`).
- **Period tabs** — multiple bi-weekly/monthly pay periods
- **Bill categories:**
  - **Credit Cards:** Amex CC, Platinum CC, Dell CC, Journey CC, Discover CC, Target CC, Visa Connexus CC
  - **Loans:** OneMain Loan, Car Loan
  - **Cash Advance Apps:** Brigit, Dave, EarnIn, MoneyLion, Tilt
  - **Affirm installments:** Valvoline, A24 Shop, Amazon (Jun), Amazon (Jul 27)
  - **Subscriptions:** Claude AI ($20), Google Drive ($2)
  - **Variable:** Groceries, Gas
  - **KT (Kwik Trip)** — tracked separately
  - **Bowling League** ($50)
- **Balance tracker** (`computeBalance`, `renderBalanceTracker`) — tracks available, running, outstanding, owed, savings
- **Category progress bars** (`computeCatProgress`, `renderCatProgress`)
- **CC Summary** (`computeCCSummary`, `renderCCSummary`) — live APR/interest calculations per card
- **CC balance editing** (`updateCCBalance`)
- **Paid-off section** (`renderPaidOff`)
- **State functions:** getCheck/setCheck, getSpent/setSpent, getSched/setSched, getCleared/setCleared, getStartBal, getBBSActual, getKTActual, getCCBal — all keyed to period+item
- **Key localStorage key:** `enid_finance_v2`

---

### `journal.html` — 🐺 Enid's Journal
- **Supabase backend** (`sbGet`, `sbPatch`, `sbDelete`)
- **Supabase tables:** `journal`, `journal_free`
- **Views:** chronological, calendar view, by-habit filter
- **Features:** search (`onSearch`), tab switching, entry cards, calendar navigation
- **Edit overlay** (`openEdit`, `closeEdit`, `saveEdit`)
- **Delete entry** (`deleteNote`)
- No localStorage — all data in Supabase

---

### `books.html` — 📚 Enid's Library
- **Supabase backend** + **OpenLibrary API** for search/covers
- **Shelves:** Reading, Want to Read, Finished, Abandoned
- **Features:** search OpenLibrary, add book, track reading sessions (pages read + date)
- **Detail view** with reading history (`renderDetailHistory`)
- **Session logging** (`saveSession`, `deleteSession`)
- **LocalStorage widget key:** `enid_books_widget` (syncs to dashboard)
- **Supabase tables:** inferred — books list + `reading_sessions`

---

### `movies.html` — 🎬 Enid's Movie List
- **TMDB API** for search and discover
- **Hype rating system** (`setHype`, `renderModalHype`) — personal excitement level per movie
- **Features:** search, discover, add from discover, toggle watched, delete
- **My list** (`loadMyList`, `saveMyList`) — stored in localStorage
- **LocalStorage key:** `enid_movies_widget` (syncs to dashboard)
- **No Supabase** — fully localStorage

---

### `calendar.html` — 📅 Enid's Calendar
- **Event types:** Event, Appointment, Reminder
- **Repeat support** (`selectRepeat`)
- **Views:** month calendar grid, day panel, agenda view
- **Features:** add/edit/delete events, navigate months, go to today
- **LocalStorage** — all events stored locally (no Supabase)
- **Widget key:** `enid_calendar_widget` (syncs to dashboard)

---

### `badges.html` — 🏆 Enid's Trophy Room
- **Supabase** for reading habit completion data (`sbGet`)
- **Custom SVG badge art** (wolf, flame, checkmark, sun, moon, paw, journal, star, perfect, weekend, legendary icons)
- **Badge unlock animations** (`launchConfetti`, `queueUnlock`, `showNextUnlock`)
- **Seen badges tracking** via `localStorage` key `enid_seen_badges`
- **Stats computation** (`computeStats`, `computeHabitStats`)
- **Badge list (sample):**
  - Streak badges: First Blood 🔥, Two Week Warrior, The Month, Unstoppable Force, Century Legend 👑
  - Total completions: First Steps, Getting Serious, Triple Digits, Five Hundred Strong, One Thousand 👑
  - Morning routine: Early Riser, Dawn Devotee, Sunrise Queen, 100 Sunrises 👑
  - Evening routine: Night Owl Tamed, Midnight Ritual, Dream Architect, 100 Moons 👑
  - Walk/yoga: Good Boy, Pack Leader, Trail Blazers, Forever Walk Buddies 👑
  - Journal: First Words, Chronicles Begin, The Chronicler, Diamond Day
  - Perfect days: Perfect Week 👑, Weekend Warrior, Sunday Sovereign, Queen of the Weekend 👑

---

### `analytics.html` — 🐺 Enid's Analytics
- **Supabase** (`sbGet`) — reads all habit completion history
- **Visualizations (custom canvas/CSS):**
  - Heatmap (GitHub-style, `renderHeatmap`)
  - Bar chart (`renderBarChart`)
  - Streak board (`renderStreakBoard`)
  - Trend grid (`renderTrend`)
  - Best week (`computeBestWeek`, `renderBestWeek`)
  - Habit correlations (`computeCorrelations`, `renderCorrelations`)
  - "This Time Last Month" comparison (`computeThisTimeLastMonth`)
  - Weekly review container
- **Date range filter** (`setRange`)
- **No localStorage** — all from Supabase

---

### `cards.html` — 🃏 Enid's Wednesday Trading Card Tracker
Tracks both **Wednesday trading card sets** — one already released and one dropping in **late March**. The file is 3.98MB because it includes **base64-encoded images of every single card** embedded directly in the HTML (no external image hosting needed — fully self-contained!).
- Tracks card collection progress across both sets
- Displays card images for each card in the sets
- Covers the released Wednesday set AND the upcoming late-March drop
- Too large to view or edit directly on GitHub's UI — must clone and edit locally
- Do NOT attempt to open or edit this file in GitHub's web editor

---

## Supabase Schema (inferred)

| Table | Used in |
|---|---|
| `habit_completions` | index.html, analytics.html, badges.html |
| `custom_habits` | index.html |
| `journal` | journal.html |
| `journal_free` | journal.html |
| `books` (or similar) | books.html |
| `reading_sessions` | books.html |

- Single-user app — uses a hardcoded `USER_ID`
- Supabase URL/key stored as `SUPA_URL` / `SUPA_KEY` constants in each page

---

## LocalStorage Keys

| Key | Used in |
|---|---|
| `enid_finance_v2` | finance.html — entire finance state |
| `enid_books_widget` | index.html + books.html — dashboard widget |
| `enid_calendar_widget` | index.html + calendar.html — dashboard widget |
| `enid_movies_widget` | index.html + movies.html — dashboard widget |
| `enid_seen_badges` | index.html + badges.html — tracks shown badge toasts |
| `enid_books_v1` | books.html (legacy key) |

---

## Design System

- **Primary color:** `#E84EA0` (hot pink)
- **Theme:** Enid Sinclair aesthetic — warm, cozy, wolf-coded 🐺
- **PWA:** fully installable, `display: standalone`, portrait-primary
- **No external CSS frameworks** — all custom styles inline per file
- **Emoji-heavy UI** — each habit, badge, and section has its own emoji
- **Loading screen:** `#enidLoader` + `#enidLoaderText` — shown during Supabase fetches

---

## Development Notes

- **No build step** — just open `.html` files or serve via GitHub Pages
- **GitHub Pages URL:** `https://thesizmon.github.io/enid-life-hub/`
- **Each page is fully self-contained** — styles, scripts, and markup in one file
- **Supabase credentials** are embedded directly in each file (single-user personal app, not a security concern for this use case)
- **`cards.html` is 3.98MB** — GitHub can't display it; avoid editing directly on GitHub UI
- **`sw.js`** handles push notification scheduling and PWA caching
- **orGroup logic** in habits — when habits share an `orGroup`, checking either one marks the group complete
- **Resurrection mechanic** (`checkResurrection`) — likely allows streak recovery after missing a day