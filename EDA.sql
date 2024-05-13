-- Exploratory Data Analysis


USE world_layoffs;

SELECT * FROM layoffs_staging2;

-- Maximum of total laid off and percentage 
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- Percentage laid off equals 1
SELECT *
FROM layoffs_staging2 
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Companies and sum of total lay offs 
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Start date and end date of the given period
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- Total layoffs industry wise
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- Total layoffs company wise
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- Total layoffs year wise
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- Total layoffs stage wise
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- Average percentage of layoffs company wise
SELECT company, AVG(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company 
ORDER BY 2 DESC;

-- Rolling total of total laid off 
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

WITH ROLLING_TOTAL AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)

SELECT `MONTH`, total_off, 
SUM(total_off) OVER(ORDER BY MONTH) AS rolling_total
FROM ROLLING_TOTAL;

-- Ranking companies by sum of  laid off  

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`) 
ORDER BY 3 DESC;

WITH COMPANY_YEAR (company, years, total_laid_off)AS 
(SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`) 
),
COMPANY_YEAR_RANK AS
(
SELECT *,
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM COMPANY_YEAR
WHERE years IS NOT NULL
)

SELECT *
FROM COMPANY_YEAR_RANK
WHERE Ranking <=5;




