create database Campaign_data;
use Campaign_data;
select * from updated_marketing_campaigns;

-- Task 6: Determine the conversion volume achieved by each marketing channel.
select updated_marketing_campaigns.Channel, sum(updated_user_engagement.Conversions) as 'Total_Conversion' from
updated_marketing_campaigns join updated_user_engagement on updated_user_engagement.Campaign_ID=updated_marketing_campaigns.Campaign_ID
group by updated_marketing_campaigns.Channel order by Total_Conversion;

-- Task 7: Identify the top-performing campaigns based on return metrics
alter table updated_revenue_generated
add column Total_Revenue int as (New_User_Revenue+Returning_User_Revenue);
select * from updated_revenue_generated;

-- Return View
create view Campaigns_Returns as
select updated_marketing_campaigns.Campaign_ID, updated_marketing_campaigns.Budget, 
updated_revenue_generated.Total_Revenue, (updated_revenue_generated.Total_Revenue / updated_marketing_campaigns.Budget) AS Return_metrics
from updated_marketing_campaigns join updated_revenue_generated on
updated_marketing_campaigns.Campaign_ID =  updated_revenue_generated.Campaign_ID
order by Return_metrics desc limit 5;

select * from Campaign_Returns;

-- Task 8: Map user engagement progression through stages.
create view Campaign_Engagement_Progression AS
select 
    Campaign_ID,
    Impressions,
    Clicks,
    Sign_Ups,
    Conversions,
    (Clicks /Impressions) * 100 AS Click_Through_Rate,
    (Sign_Ups / Clicks) * 100 AS Sign_Up_Rate,
    (Conversions / Sign_Ups) * 100 AS Conversion_Rate,
    (Conversions/Clicks)*100 As Conversion_per_Clicks
From updated_user_engagement
Order by Campaign_ID;

select * from Campaign_Engagement_Progression;

-- Task 9 already done Return View above
-- Task 10: Highlight High-Return Campaigns
-- Nested Queries
select * from updated_revenue_generated where Total_Revenue > (select avg(Total_Revenue) from updated_revenue_generated);

