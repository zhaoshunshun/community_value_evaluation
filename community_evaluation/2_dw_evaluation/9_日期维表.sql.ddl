drop table dim_day
CREATE TABLE `dim_day` (
                           `DAY_ID` varchar(20) NOT NULL,
                           `DAY_SHORT_DESC` varchar(14) DEFAULT NULL,
                           `DAY_LONG_DESC` varchar(100) DEFAULT NULL,
                           `WEEK_DESC` varchar(20) DEFAULT NULL,
                           `WEEK_ID` varchar(100) DEFAULT NULL,
                           `WEEK_LONG_DESC` varchar(100) DEFAULT NULL,
                           `MONTH_ID` varchar(100) DEFAULT NULL,
                           `MONTH_SHORT_DESC` varchar(100) DEFAULT NULL,
                           `MONTH_LONG_DESC` varchar(100) DEFAULT NULL,
                           `QUARTER_ID` varchar(100) DEFAULT NULL,
                           `QUARTER_LONG_DESC` varchar(100) DEFAULT NULL,
                           `YEAR_ID` varchar(100) DEFAULT NULL,
                           `YEAR_LONG_DESC` varchar(100) DEFAULT NULL,
                           PRIMARY KEY (`DAY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



drop procedure if exists f_dim_day;
create procedure f_dim_day(in start_date VARCHAR(20),in end_date VARCHAR(20))
begin
    declare i int;
    set i=0;
    DELETE from dim_day;
    while DATE_FORMAT(start_date,'%Y-%m-%d %H:%i:%s') < DATE_FORMAT(end_date,'%Y-%m-%d %H:%i:%s') do
            INSERT into dim_day
            (DAY_ID,DAY_SHORT_DESC,DAY_LONG_DESC,WEEK_DESC,WEEK_ID,WEEK_LONG_DESC,MONTH_ID,MONTH_SHORT_DESC,MONTH_LONG_DESC,QUARTER_ID,QUARTER_LONG_DESC,YEAR_ID,YEAR_LONG_DESC)
            SELECT
                REPLACE(start_date,'-','') DAY_ID,
                DATE_FORMAT(STR_TO_DATE(start_date,'%Y-%m-%d %H:%i:%s'),'%Y-%m-%d') DAY_SHORT_DESC,
                DATE_FORMAT(STR_TO_DATE(start_date,'%Y-%m-%d %H:%i:%s'),'%Y年%m月%d日') DAY_LONG_DESC,
                case DAYOFWEEK(STR_TO_DATE(start_date,'%Y-%m-%d %H:%i:%s'))  when 1 then '星期日' when 2 then '星期一' when 3 then '星期二' when 4 then '星期三' when 5 then '星期四' when 6 then '星期五' when 7 then '星期六' end WEEK_DESC,
                DATE_FORMAT(STR_TO_DATE(start_date,'%Y-%m-%d %H:%i:%s'),'%Y%u') WEEK_ID,
                DATE_FORMAT(STR_TO_DATE(start_date,'%Y-%m-%d %H:%i:%s'),'%Y年第%u周') WEEK_LONG_DESC,
                DATE_FORMAT(STR_TO_DATE(start_date,'%Y-%m-%d %H:%i:%s'),'%Y%m') MONTH_ID,
                DATE_FORMAT(STR_TO_DATE(start_date,'%Y-%m-%d %H:%i:%s'),'%Y-%m') MONTH_SHORT_DESC,
                DATE_FORMAT(STR_TO_DATE(start_date,'%Y-%m-%d %H:%i:%s'),'%Y年第%m月') MONTH_LONG_DESC,
                CONCAT(DATE_FORMAT(STR_TO_DATE(start_date,'%Y-%m-%d %H:%i:%s'),'%Y'),quarter(STR_TO_DATE( start_date,'%Y-%m-%d %H:%i:%s'))) QUARTER_ID,
                CONCAT(DATE_FORMAT(STR_TO_DATE(start_date,'%Y-%m-%d %H:%i:%s'),'%Y'),'年第',quarter(STR_TO_DATE(start_date,'%Y-%m-%d %H:%i:%s')),'季度') QUARTER_LONG_DESC,
                DATE_FORMAT(STR_TO_DATE(start_date,'%Y-%m-%d %H:%i:%s'),'%Y') YEAR_ID,
                DATE_FORMAT(STR_TO_DATE(start_date,'%Y-%m-%d %H:%i:%s'),'%Y年') YEAR_LONG_DESC
            from dual;
            set i=i+1;
            set start_date = DATE_FORMAT(date_add(STR_TO_DATE(start_date,'%Y-%m-%d %H:%i:%s'),interval 1 day),'%Y-%m-%d');
        end while;
end;

call f_dim_day('2019-01-01 00:00:00','2025-01-01 00:00:00');