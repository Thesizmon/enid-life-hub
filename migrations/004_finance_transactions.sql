-- ============================================================
-- Migration 004: Finance transaction receipts
-- Run in Supabase SQL Editor before deploying updated finance.html
-- ============================================================
-- Stores individual receipt/transaction entries per pay period.
-- Amounts are summed into the Running Balance via computeBalance().
-- ============================================================

CREATE TABLE IF NOT EXISTS finance_transactions (
  id         TEXT PRIMARY KEY,
  user_id    TEXT NOT NULL,
  period_id  TEXT NOT NULL,
  amount     NUMERIC(10,2) NOT NULL,
  label      TEXT NOT NULL,
  category   TEXT NOT NULL DEFAULT 'other',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS fi_txn_period ON finance_transactions (user_id, period_id);
