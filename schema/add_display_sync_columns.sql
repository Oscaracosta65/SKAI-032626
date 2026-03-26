-- =============================================================================
-- SKAI + MyLottoExpert Display-Save-Render Sync
-- Schema Migration: user_saved_numbers structured display columns
-- =============================================================================
--
-- PURPOSE
-- -------
-- Adds 23 structured columns to `user_saved_numbers` that are required for the
-- SKAI/MyLottoExpert display-save-render synchronization pipeline.
--
-- WHEN TO RUN THIS SCRIPT
-- -----------------------
-- YOU DO NOT NEED TO RUN THIS MANUALLY in most cases.
-- The SKAI PHP code automatically runs this migration in two places:
--   1. When the SKAI Admin Migration is run (SKAI_runAdminMigration)
--   2. Automatically on EVERY prediction save (before insert)
--
-- Run this script manually ONLY if:
--   - You want to add the columns immediately before any user saves a prediction
--   - You want to verify the columns are present before deploying the new code
--   - The automatic migration fails for any reason (check php error_log for details)
--
-- SAFETY
-- ------
-- Every ALTER TABLE statement uses IF NOT EXISTS, so it is:
--   - Safe to run multiple times (idempotent)
--   - Will NOT touch or drop any existing data or columns
--   - Will NOT modify any existing column definitions
--
-- REQUIREMENTS
-- ------------
-- Replace YOUR_TABLE_PREFIX_ below with your actual Joomla table prefix
-- (e.g., jos_ or j5_ -- check your Joomla configuration.php for $dbprefix)
-- Default Joomla prefix is usually "jos_" but yours may differ.
--
-- USAGE
-- -----
-- Option A: phpMyAdmin
--   Paste the SQL block below into phpMyAdmin SQL tab and click Go.
--
-- Option B: MySQL CLI
--   mysql -u YOUR_DB_USER -p YOUR_DB_NAME < add_display_sync_columns.sql
--
-- =============================================================================

-- IMPORTANT: Change `jos_` to your actual Joomla table prefix if different.
-- You can find your prefix in Joomla configuration.php: $dbprefix = 'YOUR_PREFIX_';

ALTER TABLE `jos_user_saved_numbers`
    ADD COLUMN IF NOT EXISTS `save_schema_version`            INT          NOT NULL DEFAULT 2    COMMENT 'Schema version marker for structured display fields',
    ADD COLUMN IF NOT EXISTS `prediction_family`              VARCHAR(30)  NULL                  COMMENT 'regular or daily',
    ADD COLUMN IF NOT EXISTS `prediction_type`                VARCHAR(50)  NULL                  COMMENT 'powerball euromillions pick3 pick4 pick5 etc',
    ADD COLUMN IF NOT EXISTS `render_mode`                    VARCHAR(40)  NULL                  COMMENT 'regular_main_extra or daily_combos',
    ADD COLUMN IF NOT EXISTS `main_display_json`              TEXT         NULL                  COMMENT 'JSON array of main display numbers in probability order',
    ADD COLUMN IF NOT EXISTS `extra_display_json`             TEXT         NULL                  COMMENT 'JSON array of extra/bonus display numbers in probability order',
    ADD COLUMN IF NOT EXISTS `canonical_main_display`         VARCHAR(500) NULL                  COMMENT 'CSV of main display numbers in canonical probability order',
    ADD COLUMN IF NOT EXISTS `canonical_extra_display`        VARCHAR(200) NULL                  COMMENT 'CSV of extra display numbers canonical',
    ADD COLUMN IF NOT EXISTS `prediction_extra_display_count` INT          NULL                  COMMENT 'Count of extra/bonus numbers in display set',
    ADD COLUMN IF NOT EXISTS `regular_main_numbers_json`      TEXT         NULL                  COMMENT 'Regular lottery: JSON array of main numbers for display',
    ADD COLUMN IF NOT EXISTS `regular_extra_numbers_json`     TEXT         NULL                  COMMENT 'Regular lottery: JSON array of extra/bonus numbers for display',
    ADD COLUMN IF NOT EXISTS `daily_pick_size`                TINYINT      NULL                  COMMENT 'Daily lottery: pick size 3 4 or 5',
    ADD COLUMN IF NOT EXISTS `daily_primary_prediction`       VARCHAR(30)  NULL                  COMMENT 'Daily lottery: primary combo display string e.g. 123',
    ADD COLUMN IF NOT EXISTS `daily_primary_prediction_json`  TEXT         NULL                  COMMENT 'Daily lottery: JSON array of primary combo digits',
    ADD COLUMN IF NOT EXISTS `daily_top_picks_json`           TEXT         NULL                  COMMENT 'Daily lottery: JSON array of top-5 combo display strings',
    ADD COLUMN IF NOT EXISTS `daily_top_pick_strings_json`    TEXT         NULL                  COMMENT 'Daily lottery: JSON array of top-5 combo strings with bonus display',
    ADD COLUMN IF NOT EXISTS `daily_bonus_digits_json`        TEXT         NULL                  COMMENT 'Daily lottery: JSON array of bonus digit integers',
    ADD COLUMN IF NOT EXISTS `daily_influential_digits_json`  TEXT         NULL                  COMMENT 'Daily lottery: JSON array of ranked/influential digit integers',
    ADD COLUMN IF NOT EXISTS `daily_display_payload_json`     MEDIUMTEXT   NULL                  COMMENT 'Daily lottery: full canonical display payload for rendering',
    ADD COLUMN IF NOT EXISTS `daily_learning_payload_json`    MEDIUMTEXT   NULL                  COMMENT 'Daily lottery: structured payload for learning/tracking',
    ADD COLUMN IF NOT EXISTS `display_variant`                VARCHAR(40)  NULL                  COMMENT 'Renderer display variant hint e.g. powerball euromillions daily_pick3',
    ADD COLUMN IF NOT EXISTS `renderer_hint`                  VARCHAR(40)  NULL                  COMMENT 'Renderer hint for MyLottoExpert display logic',
    ADD COLUMN IF NOT EXISTS `canonical_display_string`       VARCHAR(500) NULL                  COMMENT 'Human-readable canonical display summary string';

-- =============================================================================
-- VERIFICATION QUERY
-- Run this after the ALTER to confirm all 23 columns were added:
-- =============================================================================
-- SELECT COLUMN_NAME, COLUMN_TYPE, IS_NULLABLE, COLUMN_COMMENT
-- FROM   INFORMATION_SCHEMA.COLUMNS
-- WHERE  TABLE_SCHEMA = DATABASE()
--   AND  TABLE_NAME   = 'jos_user_saved_numbers'
--   AND  COLUMN_NAME  IN (
--     'save_schema_version','prediction_family','prediction_type','render_mode',
--     'main_display_json','extra_display_json','canonical_main_display','canonical_extra_display',
--     'prediction_extra_display_count','regular_main_numbers_json','regular_extra_numbers_json',
--     'daily_pick_size','daily_primary_prediction','daily_primary_prediction_json',
--     'daily_top_picks_json','daily_top_pick_strings_json','daily_bonus_digits_json',
--     'daily_influential_digits_json','daily_display_payload_json','daily_learning_payload_json',
--     'display_variant','renderer_hint','canonical_display_string'
--   )
-- ORDER BY COLUMN_NAME;
-- =============================================================================
