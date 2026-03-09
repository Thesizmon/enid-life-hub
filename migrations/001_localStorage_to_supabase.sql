-- ============================================================
-- Migration 001: localStorage → Supabase
-- Run this in the Supabase SQL Editor before deploying the
-- updated HTML files.
-- All tables use TEXT user_id = 'Enid' (single-user app).
-- ============================================================

-- ── Movies watchlist ─────────────────────────────────────────
-- Replaces: localStorage key "enid_movies_v1"
CREATE TABLE IF NOT EXISTS movies (
  id           TEXT PRIMARY KEY,          -- 'mv_' + Date.now()
  user_id      TEXT NOT NULL,
  tmdb_id      INTEGER NOT NULL,
  title        TEXT NOT NULL,
  poster_path  TEXT,
  release_date TEXT,
  showing_date TEXT,
  theatre      TEXT,
  notes        TEXT,
  hype         INTEGER DEFAULT 3,
  watched      BOOLEAN DEFAULT FALSE,
  added_at     BIGINT,
  UNIQUE (user_id, tmdb_id)
);

-- ── Calendar events ──────────────────────────────────────────
-- Replaces: localStorage key "enid_calendar_v1"
CREATE TABLE IF NOT EXISTS calendar_events (
  id        TEXT PRIMARY KEY,             -- 'ev_' + Date.now()
  user_id   TEXT NOT NULL,
  title     TEXT NOT NULL,
  type      TEXT NOT NULL DEFAULT 'event',
  date      TEXT NOT NULL,               -- YYYY-MM-DD
  end_date  TEXT,
  time      TEXT,
  repeat    TEXT DEFAULT 'none',
  notes     TEXT
);

-- ── Books library ────────────────────────────────────────────
-- Replaces: localStorage key "enid_books_v1"
-- (reading_sessions table already exists in Supabase)
CREATE TABLE IF NOT EXISTS books (
  id          TEXT PRIMARY KEY,           -- 'bk_' + Date.now()
  user_id     TEXT NOT NULL,
  ol_key      TEXT,                       -- OpenLibrary /works/OL...
  title       TEXT NOT NULL,
  author      TEXT,
  cover_id    BIGINT,                     -- OpenLibrary cover ID
  total_pages INTEGER,
  pages_read  INTEGER DEFAULT 0,
  status      TEXT DEFAULT 'want',        -- reading|want|done|abandoned
  notes       TEXT,
  added_at    BIGINT
);

-- ── Finance state ────────────────────────────────────────────
-- Replaces: localStorage key "enid_finance_v2"
-- Stored as one JSONB blob per user (mirrors existing structure exactly).
-- Shape: { [period_id]: { c:{}, s:{}, sc:{}, cl:{}, sb, bbs, kt, bal:{} } }
CREATE TABLE IF NOT EXISTS finance_state (
  user_id    TEXT PRIMARY KEY,
  data       JSONB NOT NULL DEFAULT '{}',
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── Card collections ─────────────────────────────────────────
-- Replaces: localStorage keys "enid_wednesday_cards_v1" and "enid_panini_cards_v1"
-- set_key = 'wednesday' | 'panini'
-- data = { [cardId]: true } (only owned cards stored)
CREATE TABLE IF NOT EXISTS card_collections (
  user_id    TEXT NOT NULL,
  set_key    TEXT NOT NULL,
  data       JSONB NOT NULL DEFAULT '{}',
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (user_id, set_key)
);

-- ── User preferences ─────────────────────────────────────────
-- Replaces: localStorage key "enid_reading_goal_2026"
CREATE TABLE IF NOT EXISTS user_prefs (
  user_id           TEXT PRIMARY KEY,
  reading_goal_2026 INTEGER,
  updated_at        TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- Note: Row Level Security (RLS) is intentionally omitted.
-- This is a single-user personal app with hardcoded USER_ID.
-- The Supabase publishable key is read-only safe for this use.
-- ============================================================
