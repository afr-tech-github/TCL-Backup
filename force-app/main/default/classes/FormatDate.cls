public with sharing class FormatDate {
    public FormatDate() {

    }
    public String FormatDate(Date inputDate) {
        String[] monthNames = new String[] {
            'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
        };
        
        Integer day = inputDate.day();
        String month = monthNames[inputDate.month() - 1];
        Integer year = inputDate.year();
        
        String daySuffix;
        if (day == 1 || day == 21 || day == 31) {
            daySuffix = 'st';
        } else if (day == 2 || day == 22) {
            daySuffix = 'nd';
        } else if (day == 3 || day == 23) {
            daySuffix = 'rd';
        } else {
            daySuffix = 'th';
        }
        
        String formattedDate = month + ' ' + day + daySuffix + ', ' + year;
        return formattedDate;
    }
}