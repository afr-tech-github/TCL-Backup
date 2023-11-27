public with sharing class RecruitmentPlanCalendarController {

    @AuraEnabled
    public static RecruitmentPlan__c getCurRPL(String id){
        RecruitmentPlan__c rs;
        try {
            rs = [SELECT StartDate__c FROM RecruitmentPlan__c WHERE Id = :id];
            return rs;
        } catch (Exception e) {
            return new RecruitmentPlan__c();
        }
    }
    
    @AuraEnabled
    public static List<RecruitmentPlanLine__c> getAllRPLLineByWeek(String rplId){
        List<RecruitmentPlanLine__c> rs = null;
        try {
            rs = [SELECT 
            Id,
            Name,
            Month__c,
            Quarter_of_Year__c,
            Week_of_year__c,
            ClosingDate__c,
            Position__r.Id,
            Position__r.Name,
            Quantity__c,
            ReasonsForRecruitment__c,
            Manager__r.Id,
            Manager__r.Name,
            Change__c
            FROM RecruitmentPlanLine__c
            WHERE RecruitmentPlan__c = :rplId AND Week_of_year__c != NULL
            ORDER BY Week_of_year__c];
            return rs;
        } catch (Exception e) {
            return new List<RecruitmentPlanLine__c>();
        }
    }
    @AuraEnabled
    public static List<RecruitmentPlanLine__c> getAllRPLLineByMonth(String rplId, String month){
        List<RecruitmentPlanLine__c> rs = null;
        String monthName;
        Integer monthNum = Integer.valueOf(month);
        switch on monthNum {
            when 1 {		// when block 1
                monthName = 'January';
            }	
            when 2 {		// when block 2
                monthName = 'February';
            }
            when 3 {		// when block 3
                monthName = 'March';
            }
            when 4 {		// when block 1
                monthName = 'April';
            }	
            when 5 {		// when block 2
                monthName = 'May';
            }
            when 6 {		// when block 3
                monthName = 'June';
            }
            when 7 {		// when block 1
                monthName = 'July';
            }	
            when 8 {		// when block 2
                monthName = 'August';
            }
            when 9 {		// when block 3
                monthName = 'September';
            }
            when 10 {		// when block 1
                monthName = 'October';
            }	
            when 11 {		// when block 2
                monthName = 'November';
            }
            when 12 {		// when block 3
                monthName = 'December';
            }
            when else {		  // default block, optional
                monthName = '';
            }
        }
        try {
            System.debug('month: '+monthName);
            rs = [SELECT 
            Id,
            Name,
            Month__c,
            Quarter_of_Year__c,
            Week_of_year__c,
            ClosingDate__c,
            Position__r.Id,
            Position__r.Name,
            Quantity__c,
            ReasonsForRecruitment__c,
            Manager__r.Id,
            Manager__r.Name,
            Change__c
            FROM RecruitmentPlanLine__c
            WHERE RecruitmentPlan__c = :rplId AND Week_of_year__c != NULL AND Month__c != NULL AND Month__c = :monthName
            ORDER BY Week_of_year__c];
            System.debug('RS LENGTH: ');
            System.debug(rs.size());
            System.debug(rs);
            return rs;
        } catch (Exception e) {
            return new List<RecruitmentPlanLine__c>();
        }
    }
    @AuraEnabled
    public static List<RecruitmentPlanLine__c> getAllRPLLineByQuarter(String rplId, String quarter){
        List<RecruitmentPlanLine__c> rs = null;
        Decimal quarterNum = Decimal.valueOf(quarter);
        try {
            rs = [SELECT 
            Id,
            Name,
            Month__c,
            Quarter_of_Year__c,
            Week_of_year__c,
            ClosingDate__c,
            Position__r.Id,
            Position__r.Name,
            Quantity__c,
            ReasonsForRecruitment__c,
            Manager__r.Id,
            Manager__r.Name,
            Change__c
            FROM RecruitmentPlanLine__c
            WHERE RecruitmentPlan__c = :rplId AND Week_of_year__c != NULL AND Quarter_of_Year__c != NULL AND Quarter_of_Year__c = :quarterNum
            ORDER BY Week_of_year__c];
            return rs;
        } catch (Exception e) {
            return new List<RecruitmentPlanLine__c>();
        }
    }
    @AuraEnabled
    public static List<RecruitmentPlanLine__c> getMoreRecord(String rplId, String weekNum, String colNum){
        List<RecruitmentPlanLine__c> rs = null;
        Integer colNumVal = Integer.valueOf(colNum);
        Decimal weekNumVal = Decimal.valueOf(weekNum);
        try {
            rs = [SELECT 
            Id,
            Name,
            Month__c,
            Quarter_of_Year__c,
            Week_of_year__c,
            ClosingDate__c,
            Position__r.Id,
            Position__r.Name,
            Quantity__c,
            ReasonsForRecruitment__c,
            Manager__r.Id,
            Manager__r.Name,
            Change__c
            FROM RecruitmentPlanLine__c
            WHERE RecruitmentPlan__c = :rplId AND Week_of_year__c != NULL AND Week_of_year__c = :weekNumVal
            ORDER BY Week_of_year__c
            LIMIT 5 OFFSET :colNumVal];
            return rs;
        } catch (Exception e) {
            return new List<RecruitmentPlanLine__c>();
        }
    }
}