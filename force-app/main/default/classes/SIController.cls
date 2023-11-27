public with sharing class SIController {
    public AdvancedShipment__c advancedShipment {get; set;}
    public List<FTMSBill__c> lstBill {get; set;}
    public Account cus {get; set;}
    public CompanyInformation__c ComInf {get; set;}
    public CompanyInformation__c ComInfo {get; set;}
    public List<CntrinTrans__c> lstCont {get; set;}
    public String recordType {get; set;}
    public Decimal totalVND {get; set;}
    public Decimal totalUSD {get; set;}
    public String curr {get; set;}
    public String Unit {get; set;}
 
    public String readTotalAmountVND {get; set;}
    public String readTotalAmountUSD {get; set;}
    public Date today {get; set;}
    public String userName {get; set;}
    public String currentDate {get; set;}
    public static List<CntrinTrans__c> console {get; set;}
    public static List<CntrinTrans__c> consoleu {get; set;}

    public  static FTMSSO__c SO {get;set;}
    public  static FTMSSO__c SOu {get;set;}

    public String InvoiceNo {get; set;}
    private String shipId {get; set;}
    private String cusId {get; set;}

    private static String UpdateField {get; set;}
    

    private static Set<String> fieldsSOQuery = new Set<String>();
    static {
 
        fieldsSOQuery.add('CoLoader__r.AccountNameENG__c');
        fieldsSOQuery.add('CoLoader__r.Phone');
        fieldsSOQuery.add('CoLoader__r.Fax');
        fieldsSOQuery.add('MasterShippersDetailInformation__c');
        fieldsSOQuery.add('MasterConsigneesDetailInformation__c');
        fieldsSOQuery.add('MasterNotifyPartysDetailInformation__c');


        fieldsSOQuery.add('MBLType__c');
        fieldsSOQuery.add('Agent__r.Name');
        fieldsSOQuery.add('AgentDetailInformation__c');
        fieldsSOQuery.add('HouseNotifyPartyDetail_Information__c');
        fieldsSOQuery.add('PODAOAsDetailInformation__c');
        fieldsSOQuery.add('ConsealReportOnly__c');
        fieldsSOQuery.add('AgentDetailInformation__c');

        fieldsSOQuery.add('Agent__r.Phone');
        fieldsSOQuery.add('Agent__r.Fax');
        fieldsSOQuery.add('Branch__c');
        fieldsSOQuery.add('Branch1__c');
        fieldsSOQuery.add('MarksNumbersAttachment__c');
        fieldsSOQuery.add('DescriptionofGoods__c');
        fieldsSOQuery.add('GrossWeight__c');
        fieldsSOQuery.add('MeasurementTotalCBM__c');
        fieldsSOQuery.add('CargoQuantity__c');
        fieldsSOQuery.add('Plural_Cargo_Unit__c');
        fieldsSOQuery.add('CargoUnit__c');
        fieldsSOQuery.add('VesselFlight__c');
        fieldsSOQuery.add('ETD__c');
        fieldsSOQuery.add('Master_Freight_Collect_Prepaid__c');
        fieldsSOQuery.add('voyage__c');

        
        fieldsSOQuery.add('HouseFreightCollectPrepaid__c');

        fieldsSOQuery.add('POD_Formul__c');
        fieldsSOQuery.add('HouseNotifyDetailInformation_text__c');
        fieldsSOQuery.add('ConsigneeDetailInformation_text__c');
        fieldsSOQuery.add('ShipperDetailInformation_text__c');

        fieldsSOQuery.add('Cargo_Unit_Text__c');



    }



    private static Set<String> fieldsComInQuery = new Set<String>();
    static {
        fieldsComInQuery.add('Id');
        fieldsComInQuery.add('Name');
        fieldsComInQuery.add('Address__c');
        fieldsComInQuery.add('Tel__c');
        fieldsComInQuery.add('Fax__c');
        fieldsComInQuery.add('Taxcode__c');
        fieldsComInQuery.add('Email__c');
        fieldsComInQuery.add('Website__c');
        fieldsComInQuery.add('Branch__c');
        fieldsComInQuery.add('CompanyLogo__c');
    }
    private static Set<String> fieldsConsoleQuery = new Set<String>();
    static {
        fieldsConsoleQuery.add('Container_Number__c');
        fieldsConsoleQuery.add('Seal_Number__c');
        fieldsConsoleQuery.add('Container_Type__c'); 

        fieldsConsoleQuery.add('Cargo_Quantity__c');   
        fieldsConsoleQuery.add('CargoUnit__c');   
        fieldsConsoleQuery.add('Gross_Weight_Kg__c');  
        fieldsConsoleQuery.add('Measurement_CBM__c');   
        fieldsConsoleQuery.add('Cargo_Unit_Text__c');   


    }

    public SIController() {
        shipId = ApexPages.currentPage().getParameters().get('Id');
        SO = getSO(shipId);

        ComInfo = [SELECT Name,Address__c, Tel__c, Fax__c, Taxcode__c, Email__c, Website__c, Branch__c, CompanyLogo__c FROM CompanyInformation__c WHERE Branch1__c = 'Hồ Chí Minh'];
        ComInf = new CompanyInformation__c();
        if(SO.Branch1__c != null && SO.Branch1__c != ''){
            ComInf = getComIn(SO.Branch1__c);     
        }
        userName = UserInfo.getName();
        currentDate=getCurrentDate();
        console = getConsole(shipId);
        
        // String Vss = convertToPlural('nguyenCH, van ,CITY');

        UpdateField= '';
            for( CntrinTrans__c Item : console){
                // List<String> unitCon = new List<String>();
                if(Item.Cargo_Quantity__c > 1){

                    String unitItem = convertToPlural(String.valueOf(Item.CargoUnit__c));
                   //  Unit.add(unitItem);
                   //  for ()
                    Item.Cargo_Unit__c = unitItem;

                    UpdateField += unitItem + '\n';
                }
                

            }
           
    }

    @AuraEnabled
    public static void createAttatchment(String recordId){
        
        FTMSSO__c SO = [SELECT Id, Name, JobRequestID__c, File_No1__c FROM FTMSSO__c WHERE Id =: recordId];
        System.debug('recordId: '+recordId);
        PageReference pdf_file = Page.page_SI;
        pdf_file.getParameters().put('id', recordId);
        String namefile = 'TCL_SI_' + SO.JobRequestID__c;
        // for(PicklistEntry value: User.LanguageLocalekey.getDescribe().getPicklistValues()) {
        //     if(value.getValue().contains(language)) {
        //         languaName = value.getLabel();
        //         break;
        //     }
        // }
        String attachName = namefile + '_v';
        String attachNameSearch = attachName + '%';
        // get exist file Name
        List<Attachment> attachments = [SELECT Id, Name, ParentId 
                                        FROM Attachment 
                                        WHERE ParentId =: recordId 
                                        AND Name LIKE : attachNameSearch 
                                        ORDER BY CreatedDate DESC LIMIT 1];
        if(attachments.isEmpty()){
            attachName += '1.1';
        }else{
            String attachNameExist = attachments[0].Name;
            attachNameExist = attachNameExist.substringAfter(attachName);
            attachNameExist = attachNameExist.substringBefore('.pdf');
            Decimal versionNumber = Decimal.valueOf(attachNameExist);
            versionNumber += 0.1;
            attachName += String.valueOf(versionNumber);
        }
        // Attachment attach = new Attachment();
        // Blob body;
        // attach.Name = attachName + '.pdf'; 
        // attach.IsPrivate = false;
        // attach.ParentId = recordId;
        // if(!Test.isRunningTest()){
        //     body = pdf_file.getContentAsPDF();
        //     attach.Body = body;
        //     insert(attach);
        // }
        ContentVersion cv = new ContentVersion();
        // Blob body;
        cv.PathOnClient = attachName + '.pdf';
        cv.Title = attachName + '.pdf';
        cv.Description = attachName + '.pdf';
        cv.FirstPublishLocationId = recordId;
        if(!Test.isRunningTest()){
            // body = pdf_file.getContentAsPDF();
            cv.VersionData = pdf_file.getContentAsPDF();
            // attach.Body = body;
            insert cv;
        }
    }
    public static void UpdateCargoUint(){
        
        String shipId = ApexPages.currentPage().getParameters().get('Id');

        SOu = getSO(shipId);
        consoleu = getConsole(shipId);

        List<CntrinTrans__c> UpdateList = new List<CntrinTrans__c>();

        for( CntrinTrans__c Item : consoleu){
            // List<String> unitCon = new List<String>();
            if(Item.Cargo_Quantity__c > 1){
                String unitItem = convertToPlural(String.valueOf(Item.Cargo_Unit__c));
                if(Item.Cargo_Unit_Text__c == null || Item.Cargo_Unit_Text__c == unitItem ){
                    Item.Cargo_Unit_Text__c = unitItem;
                    UpdateList.add(Item);
                }
            }else {
                UpdateList.add(Item);
            }
        }
        // System.debug('update size :'+ UpdateList.size());

        if(UpdateList.size() > 0){
            update UpdateList;
            System.debug('update text :'+ UpdateList);
        }

    }
    public static String convertToPlural(String input) {
        List<String> pluralWords = new List<String>();
        String[] words = input.split(';');
        for (String word : words) {
            if( word.contains(',')){
                List<String> tmpList = new List<String>();
                String[] wordsItems = word.split(','); 
                for (String wordItem : wordsItems) {
                    String tmp = convertWordToPlural(wordItem.trim());
                    tmpList.add(tmp);
                }
                 String resultTmp = '';

                for (Integer i = 0; i < tmpList.size(); i++) {
                    resultTmp += tmpList[i].trim();
                    if( i< tmpList.size()-1){

                        resultTmp +=  ', ';
                    }
                   
            
                }
                pluralWords.add(resultTmp);

            }
            else{
                String pluralWord = convertWordToPlural(word.trim());
                pluralWords.add(pluralWord);
            }
        }
        
        String result = '';
        for (Integer i = 0; i < pluralWords.size(); i++) {
            if (i > 0) {
                result += '; ';
            }
            result += pluralWords[i];
        }
        
        return result;
    }
    
    private static boolean checkChar(String c) {
        System.debug('debuggg List value :'+ c);
 
        return c == 'A' || c == 'E' || c == 'I' || c == 'O' || c == 'U';
    }

    public static String convertWordToPlural(String word) {
        if (word == null || word.length() == 0 ||word.endsWith('ED')){
            return word;
        }
        
        if (word.endsWith('Y') && !checkChar(word.substring(word.length()-1))) {
            return word.substring(0, word.length() - 1) + 'IES';
        } else if (word.endsWith('S') || word.endsWith('CH') || word.endsWith('SH') || word.endsWith('X') || word.endsWith('Z')) {
            return word + 'ES';
        } 
        else {
            return word + 'S';
        } 
    }
    
    



    private  static FTMSSO__c getSO(String id){
        String strSelect = String.join(new List<String>(fieldsSOQuery), ',');
        String strQuery = 'SELECT ' + strSelect 
                    + ' FROM FTMSSO__c'
                    + ' WHERE id = \'' + String.escapeSingleQuotes(id) + '\'';       
        FTMSSO__c soList;
        try{
            soList = Database.query(strQuery);
        } catch(QueryException e){
            soList = new FTMSSO__c();
        }
        return soList;
    }
    private static List<CntrinTrans__c> getConsole(String id){
        String strSelect = String.join(new List<String>(fieldsConsoleQuery), ',');
        String strQuery = 'SELECT ' + strSelect 
                    + ' FROM CntrinTrans__c'
                    + ' WHERE F_TMS_S_O__c = \'' + String.escapeSingleQuotes(id) + '\'';
        // strQuery += ' ORDER BY Name ASC Limit 1';        
        List<CntrinTrans__c> console;
        try{
            console = Database.query(strQuery);
        } catch(QueryException e){
            console = new List<CntrinTrans__c>();
        }
        return console;
    }
    private String getCurrentDate() {
    
           
                Date currentDate = Date.today();
                Integer monthNumber = currentDate.month();
                Integer dateNow = currentDate.day();
                Integer yearNow = currentDate.year();

                
                List<String> monthNames = new List<String>{
                    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul',
                    'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                };
                
                String monthName = monthNames[monthNumber - 1];
                
                 return dateNow +'-'+ monthName +'-' + yearNow;
      
      
    }
    

   

    private CompanyInformation__c getComIn(String branch){
        String strSelect = String.join(new List<String>(fieldsComInQuery), ',');
        String strQuery = 'SELECT ' + strSelect 
                    + ' FROM CompanyInformation__c'
                    + ' WHERE Branch1__c = \'' + String.escapeSingleQuotes(branch) + '\'';
        strQuery += ' ORDER BY Name ASC Limit 1';        
        CompanyInformation__c ComIn;
        try{
            ComIn = Database.query(strQuery);
        } catch(QueryException e){
            ComIn = new CompanyInformation__c();
        }
        return ComIn;
    }
  
}