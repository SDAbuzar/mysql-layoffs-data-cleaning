/* ==========================================================
   LAYOFFS DATA CLEANING PROJECT
   Dataset: Layoffs 2022 (Kaggle)
   Objective:
   Clean and prepare raw layoffs data for analysis by:
   1. Removing duplicate records
   2. Standardizing data formats
   3. Handling missing/null values
   4. Removing unnecessary records and columns
   ========================================================== */

-- View raw dataset
SELECT *
FROM layoffs;


-- STEP 1: CREATE A STAGING TABLE
-- Purpose:
-- Create a copy of the original dataset to avoid modifying
-- the raw source data.


CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT layoffs_staging
SELECT *
FROM layoffs;

SELECT *
FROM layoffs_staging;



-- STEP 2: IDENTIFY DUPLICATE RECORDS
-- Purpose:
-- Use ROW_NUMBER() to detect duplicate rows based on all
-- important business columns.


SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off,
percentage_laid_off, `date`
) AS row_num
FROM layoffs_staging;


WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry,
total_laid_off, percentage_laid_off,
`date`, stage, country,
funds_raised_millions
) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;


-- Example company check
SELECT *
FROM layoffs_staging
WHERE company = 'Casper';



-- STEP 3: CREATE SECOND STAGING TABLE
-- Purpose:
-- Store row numbers and remove duplicates safely.


CREATE TABLE layoffs_staging2 (
  company TEXT,
  location TEXT,
  industry TEXT,
  total_laid_off INT DEFAULT NULL,
  percentage_laid_off TEXT,
  `date` TEXT,
  stage TEXT,
  country TEXT,
  funds_raised_millions INT DEFAULT NULL,
  row_num INT
);

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry,
total_laid_off, percentage_laid_off,
`date`, stage, country,
funds_raised_millions
) AS row_num
FROM layoffs_staging;


-- View duplicate rows
SELECT *
FROM layoffs_staging2
WHERE row_num > 1;


-- Remove duplicates
DELETE
FROM layoffs_staging2
WHERE row_num > 1;


SELECT *
FROM layoffs_staging2;



-- STEP 4: STANDARDIZE DATA
-- Purpose:
-- Clean text values and ensure consistency.



-- Remove leading/trailing spaces from company names
SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);


-- Standardize industry values
SELECT DISTINCT industry
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';


-- Standardize country names
SELECT DISTINCT country,
TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';



-- STEP 5: CLEAN DATE COLUMN
-- Purpose:
-- Convert text dates into MySQL DATE format.


SELECT `date`
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;



-- STEP 6: HANDLE MISSING VALUES
-- Purpose:
-- Replace blank strings with NULL and populate missing
-- industry values using existing company records.


UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';


-- Check missing industries
SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';


-- Example company review
SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';


-- Find matching industry values
SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
    ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;


-- Populate missing industry values
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
    ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;


SELECT *
FROM layoffs_staging2;



-- STEP 7: REMOVE USELESS RECORDS
-- Purpose:
-- Remove rows where both total layoffs and layoff
-- percentage are missing because they provide no value
-- for analysis.


SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;



-- STEP 8: FINAL CLEANUP
-- Purpose:
-- Remove helper column used during duplicate detection.


ALTER TABLE layoffs_staging2
DROP COLUMN row_num;



-- FINAL CLEANED DATASET


SELECT *
FROM layoffs_staging2;