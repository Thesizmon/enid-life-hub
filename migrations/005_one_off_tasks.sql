-- ============================================================
-- Migration 005: One-off daily tasks
-- Run in Supabase SQL Editor before deploying updated index.html
-- ============================================================
-- Stores date-specific one-time tasks (separate from recurring habits).
-- Tasks appear only on their assigned task_date.
-- ============================================================

CREATE TABLE IF NOT EXISTS one_off_tasks (
  id          TEXT PRIMARY KEY,
  user_id     TEXT NOT NULL,
  task_date   DATE NOT NULL,
  title       TEXT NOT NULL,
  emoji       TEXT NOT NULL DEFAULT '📌',
  completed   BOOLEAN NOT NULL DEFAULT FALSE,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS oot_user_date ON one_off_tasks (user_id, task_date);
