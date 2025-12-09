# EEG Initial Preprocessing Pipeline

This document outlines the step-by-step preprocessing workflow for EEG data analysis. The pipeline moves from raw data import and trigger management through artifact correction (ICA) to final epoching and trial rejection.

## 📋 Pipeline Overview

**Input Data:** Raw EEG files
**Tools Required:** MATLAB, EEGLAB (implied by `.m` scripts and ICA steps)

---

## Phase 1: Data Import & Trigger Management
*Goal: Ensure all events are correctly labeled and datasets are merged before processing.*

1.  **Run `MakeTriggerFile.m`**
    * Generates the initial trigger information.
2.  **Run `AppendFiles.m`**
    * Merges necessary file segments.
3.  **Run `KeepS1Events.m`**
    * Filters for Session 1 events specific to the analysis.
4.  **Run `ChangeTriggerNames.m`**
    * Standardizes event markers.
    * **Output Saved:** `session1_trigfix`

## Phase 2: Signal Conditioning (Resampling & Filtering)
*Goal: Reduce file size and remove high-frequency noise.*

5.  **Downsample Data**
    * **Target:** 250 Hz
    * **Output Saved:** `session1_trigfix_ds`
6.  **Low-Pass Filter**
    * **Cutoff:** 50 Hz
    * **Output Saved:** `session1_trigfix_ds_lp`

## Phase 3: Early Artifact Rejection & Referencing
*Goal: Remove gross artifacts and establish a common reference.*

7.  **Visual Rejection**
    * Manual inspection to remove major non-stereotypical artifacts.
    * **View Settings:**
        * Remove DC offset
        * Scale: 80
        * Time window: 25 sec
8.  **Re-reference**
    * Compute average reference (or specific reference scheme).
9.  **One Channel Rejection**
    * *Status:* **SKIPPED** (Step 8)

## Phase 4: Independent Component Analysis (ICA)
*Goal: Isolate and remove stereotypical artifacts (blinks, saccades) using a high-pass filter proxy to improve ICA quality.*

10. **High-Pass Filter (Pre-ICA)**
    * Apply HP filter (typically 1Hz) to prepare data for ICA decomposition.
11. **Run ICA**
    * Decompose signal into independent components.
12. **Run `Copy_ICs_to_nonHp.m`**
    * **Critical Step:** Transfer the IC weights calculated on the high-pass filtered data back to the original (non-high-pass filtered) dataset to preserve low-frequency information.
13. **IC Rejection**
    * Identify and remove components clearly associated with ocular artifacts (blinks and saccades).

## Phase 5: Final Processing & Epoching
*Goal: Interpolate bad channels, apply final filters, and segment data for analysis.*

14. **Channel Interpolation**
    * Reconstruct bad channels identified earlier using surrounding electrode data.
15. **High-Pass Filter**
    * **Cutoff:** 0.1 Hz (Final slow-drift removal).
16. **Epoch Data & Baseline Correction**
    * Segment continuous data into time-locked trials.
    * Subtract baseline activity.
17. **Run Trial Rejection**
    * **Criteria:** Amplitude threshold.
    * **Limit:** Exclude epochs exceeding **±100µV** from baseline at any of the 128 scalp channels.