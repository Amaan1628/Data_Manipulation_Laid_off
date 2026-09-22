-- Exploratory Data Analysis
select * 
from layoffs_staging2;

-- Rolling Total of total laid off according to months
select substring(`date`,1,7) as `Month`, sum(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `Month`
order by 1 asc
;


with Rolling_total as 
(
select substring(`date`,1,7) as `Month`, sum(total_laid_off) as Sum_T
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `Month`
order by 1 asc
) 
select `Month`,Sum_T as Total_laid_off,sum(Sum_T) over(order by `Month`) as Rolling
from Rolling_total;


-- Total Laid off per Year according to Company

select * 
from layoffs_staging2;

select company, Sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 Desc
;

select company,year(`date`) as `year`, Sum(total_laid_off)
from layoffs_staging2
group by company,`year`
;


-- Ranking years the companies laid off the most employees 

with Ranking as 
(
select company,year(`date`) as `year`, Sum(total_laid_off) as Total_laidofff
from layoffs_staging2
group by company,`year`
order by 3 Desc
)
select *,
dense_rank() over(partition by(`year`) order by Total_laidofff desc) as Rankk
from Ranking
where `year` is not null
order by Rankk
;

-- Ranking Top 5 Companies By each Year

with Ranking as 
(
select company,year(`date`) as `year`, Sum(total_laid_off) as Total_laidofff
from layoffs_staging2
group by company,`year`
order by 3 Desc
), Company_year_rank as 
(
select *,
dense_rank() over(partition by(`year`) order by Total_laidofff desc) as Rankk
from Ranking
where `year` is not null
) 
select *
from Company_year_rank
where rankk <= 5
;