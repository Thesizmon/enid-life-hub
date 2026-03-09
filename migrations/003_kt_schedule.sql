-- ============================================================
-- Migration 003: KT (Kwik Trip) recurring weekly shift schedule
-- Run in Supabase SQL Editor before deploying updated index.html
-- ============================================================
-- Stores which days of the week are KT shift days for user_id = 'Enid'.
-- dow: 0=Sunday … 6=Saturday (matches JS Date.getDay())
-- notif_hour/notif_min: when to fire the pre-shift motivation notification
-- No seed data — user configures via the 🏪 KT Schedule modal in the app.
-- ============================================================

CREATE TABLE IF NOT EXISTS kt_schedule (
  user_id    TEXT    NOT NULL,
  dow        INTEGER NOT NULL CHECK (dow BETWEEN 0 AND 6),
  enabled    BOOLEAN NOT NULL DEFAULT TRUE,
  notif_hour INTEGER NOT NULL DEFAULT 7,
  notif_min  INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (user_id, dow)
);
