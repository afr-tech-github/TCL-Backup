public with sharing class PrintSIMBLController {
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
    public String readTotalAmountVND {get; set;}
    public String readTotalAmountUSD {get; set;}
    public Date today {get; set;}
    public String userName {get; set;}
    public String currentDate {get; set;}
    public List<ConsolCNTR__c> console {get; set;}
    public List<FTMSSO__c> SOList {get;set;}
 
    public String InvoiceNo {get; set;}
    private String shipId {get; set;}
    private String cusId {get; set;}
    

    private static Set<String> fieldsShipQuery = new Set<String>();
    static {
        fieldsShipQuery.add('Id');
        fieldsShipQuery.add('Name');
        fieldsShipQuery.add('VesselFlight__c');
        fieldsShipQuery.add('ETD__c');
        fieldsShipQuery.add('MPOD__r.Name');
        // fieldsShipQuery.add('MShippersDetailInformation__c');
        // fieldsShipQuery.add('MNotifyPartysDetailInformation__c');
        // fieldsShipQuery.add('MConsigneesDetailInformation__c');
        // fieldsShipQuery.add('Branch__c');
        fieldsShipQuery.add('Branch1__c');
        // fieldsShipQuery.add('MAgent__r.Name');
        // fieldsShipQuery.add('MAgent__r.Phone');
        // fieldsShipQuery.add('MAgent__r.Fax');
        fieldsShipQuery.add('Freight_Term__c');
        // fieldsShipQuery.add('voyage__c');
		// fieldsShipQuery.add('Carrier_Company_Name__r.AccountNameENG__c');

        fieldsShipQuery.add('Shipping_Mark__c');
        fieldsShipQuery.add('Description_of_Goods__c');
        fieldsShipQuery.add('GrossWeight__c');
        fieldsShipQuery.add('MeasurementCBM__c');

        fieldsShipQuery.add('Cargo_Unit__c');
        fieldsShipQuery.add('Quantity__c');
        fieldsShipQuery.add('MBLType__c');

        fieldsShipQuery.add('AgentDetailInformation__c');
        fieldsShipQuery.add('HouseNotifyPartyDetailInformation__c');
        fieldsShipQuery.add('ConsealReportOnly__c');
        fieldsShipQuery.add('MasterNotifyPartyDetailInformation__c');
        // fieldsShipQuery.add('MarksNumbersAttachment__c');
        // fieldsShipQuery.add('DescriptionofGoods__c');
        // fieldsShipQuery.add('MeasurementTotalCBM__c');


        

    }
    private static Set<String> fieldsSOQuery = new Set<String>();
    static {
        fieldsSOQuery.add('MarksNumbersAttachment__c');
        fieldsSOQuery.add('DescriptionofGoods__c');
        fieldsSOQuery.add('GrossWeight__c');
        fieldsSOQuery.add('MeasurementTotalCBM__c');
        fieldsSOQuery.add('CargoQuantity__c');
        fieldsSOQuery.add('Plural_Cargo_Unit__c');
        fieldsSOQuery.add('CargoUnit__c');
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
        fieldsComInQuery.add('Branch1__c');
        fieldsComInQuery.add('CompanyLogo__c');
    }
    private static Set<String> fieldsConsoleQuery = new Set<String>();
    static {
        fieldsConsoleQuery.add('Container_Number__c');
        fieldsConsoleQuery.add('Seal_Number__c');
        fieldsConsoleQuery.add('Container_Type__c');   
    }

   

    public PrintSIMBLController() {
        shipId = ApexPages.currentPage().getParameters().get('Id');
        ComInfo = [SELECT Name,Address__c, Tel__c, Fax__c, Taxcode__c, Email__c, Website__c, Branch1__c, CompanyLogo__c FROM CompanyInformation__c WHERE Branch1__c = 'Hồ Chí Minh'];
        advancedShipment = getShipment(shipId);
        ComInf = new CompanyInformation__c();
        // advancedShipment = [SELECT Branch1__c FROM AdvancedShipment__c WHERE id =: shipId];
        System.debug('advancedShipment: ' + advancedShipment);
        System.debug('shipId: ' + shipId);
        System.debug('advancedShipment: ' + advancedShipment.Branch1__c);
        // ComInf = new CompanyInformation__c();
        if(advancedShipment.Branch1__c != null){
            ComInf = getComIn(advancedShipment.Branch1__c);
        }
        userName = UserInfo.getName();
        currentDate=getCurrentDate();
        console= getConsole(shipId);
        SOList= getSOList(shipId);
    }

    @AuraEnabled
    public static void createAttatchment(String recordId){
        
        AdvancedShipment__c SO = [SELECT Id,FileNo__c, Name  FROM AdvancedShipment__c WHERE Id =: recordId];
        System.debug('recordId: '+recordId);
        PageReference pdf_file = Page.page_FormSIMBL;
        pdf_file.getParameters().put('id', recordId);
        String namefile = 'TCL_MSI_' + SO.FileNo__c;
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
    private List<FTMSSO__c> getSOList(String id){
        String strSelect = String.join(new List<String>(fieldsSOQuery), ',');
        String strQuery = 'SELECT ' + strSelect 
                    + ' FROM FTMSSO__c'
                    + ' WHERE ConsolidationID__c = \'' + String.escapeSingleQuotes(id) + '\'';       
        List<FTMSSO__c> soList;
        try{
            soList = Database.query(strQuery);
        } catch(QueryException e){
            soList = new List<FTMSSO__c>();
        }
        return soList;
    }
    private List<ConsolCNTR__c> getConsole(String id){
        String strSelect = String.join(new List<String>(fieldsConsoleQuery), ',');
        String strQuery = 'SELECT ' + strSelect 
                    + ' FROM ConsolCNTR__c'
                    + ' WHERE AdvancedShipment__c = \'' + String.escapeSingleQuotes(id) + '\'';
        // strQuery += ' ORDER BY Name ASC Limit 1';        
        List<ConsolCNTR__c> console;
        try{
            console = Database.query(strQuery);

        } catch(QueryException e){
            console = new List<ConsolCNTR__c>();
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
    private AdvancedShipment__c getShipment(String shipId){
        String strSelect = String.join(new List<String>(fieldsShipQuery), ',');
        String strQuery = 'SELECT ' + strSelect 
                    + ' FROM AdvancedShipment__c'
                    + ' WHERE Id = \'' + String.escapeSingleQuotes(shipId) + '\'';
        
        AdvancedShipment__c ship;
        try{
            ship = Database.query(strQuery);
            System.debug('get');
        } catch(QueryException e){
            ship = new AdvancedShipment__c();
        }
        return ship;
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