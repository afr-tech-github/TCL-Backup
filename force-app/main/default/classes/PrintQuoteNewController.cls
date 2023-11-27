public with sharing class PrintQuoteNewController {
    public CompanyInformation__c ComInfo {get; set;}

    public Date today {get; set;}
    public String userName {get; set;}
    public String currentDate {get; set;}
 
    private String shipId {get; set;}
    private String cusId {get; set;}
    public User Uinfo {get;set;}

    public String quoteId{get; set;}
    public String ProcessInstanceId{get; set;}
    public String TargetObjectId{get; set;}
    public String printtype {get; set;}
    public Integer numberTH {get;set;}
    public Quote__c quote{get; set;}
    public Set<String> setChargeUnit{get; set;}
    public List<String> lstSortChargeUnit{get; set;}
    public List<SectionDataWapper> lstSectionData{get; set;}
    public Map<String,SectionDataWapper> mapSectionData{get; set;}
    public List<ChargeUnitWrapper> listChargeUnitWrapper{get; set;}
    public Map<String,ChargeUnitWrapper> mapChargeUnitWrapper{get; set;}
    public Set<String> setSectionName {get; set;}
    private static Set<String> setFieldsQuote = new Set<String>();
    private static Set<String> setFieldsQuoteLine = new Set<String>();

    static {
        // fields of Quote build query
		setFieldsQuote.add('RequestCompanysPIC__r.LastName');
		setFieldsQuote.add('RequesterCompany__r.AccountNameENG__c');
		setFieldsQuote.add('RequesterCompany__r.Company_Address__c');
		setFieldsQuote.add('QuoteIssueDate__c');
        setFieldsQuote.add('Validto__c');
        setFieldsQuote.add('QuoteName__c');
		setFieldsQuote.add('Commodity1__r.Name');
        setFieldsQuote.add('PickupAddress__c');
		setFieldsQuote.add('DeliveryAddress__c');
		setFieldsQuote.add('Currency__c');
		setFieldsQuote.add('Volume__c');
		setFieldsQuote.add('MeasurementTotalCBM__c');
		setFieldsQuote.add('GrossWeight__c ');
		setFieldsQuote.add('Remarks__c');
        setFieldsQuote.add('QuotePIC__r.Name');
        setFieldsQuote.add('QuotePIC__r.Email');
        setFieldsQuote.add('QuotePIC__r.Phone');
        setFieldsQuote.add('TypeofTrade__c');
        setFieldsQuote.add('Name');


        // fields of Quote Line build query
        setFieldsQuoteLine.add('LineItemNameEng__c');
		setFieldsQuoteLine.add('LineItemNameLocal__c');
		setFieldsQuoteLine.add('ChargeUnit__c');
        setFieldsQuoteLine.add('ContainerType1__c');
        setFieldsQuoteLine.add('ServiceID__c');
        setFieldsQuoteLine.add('ServiceID__r.Name');
		setFieldsQuoteLine.add('Remarks__c');

        setFieldsQuoteLine.add('Quote_route__r.Route_Name__c');
        setFieldsQuoteLine.add('Quote_route__c');
        setFieldsQuoteLine.add('Name');
        setFieldsQuoteLine.add('TotalSellingInclTaxActual__c');
    }



    public class ChargeUnitWrapper {
        public String  itemNameENG{get;set;}
        public String  itemNameLocal{get;set;}
        public String  sectionId{get;set;}
        public String  sectionName{get;set;}
        public Boolean checkTotal{get;set;}
        public Map<String, Decimal> mapAmountUnit{get;set;}
        public String  remark{get;set;}
        public Set<String> lstremark {get; set;}
        public List<Quoteline__c> lstQuoteLine {get;set;}
        public ChargeUnitWrapper(){
            itemNameENG = '';
            itemNameLocal = '';
            sectionId = '';
            sectionName = '';
            mapAmountUnit = new Map<String,Decimal>();
            remark = '';
            lstQuoteLine = new List<Quoteline__c>();
            lstremark = new Set<String>();
        }
    }

    public class SectionDataWapper {
        // public RouterDataWapper(){}
        public String sectionId{get;set;}
        public String sectionTitle{get;set;}
        public Boolean checkTotal{get;set;}
        public Map<String,Decimal> mapTotal{get;set;}
        public List<String> lstUnit {get;set;}
        public String sectionRemark{get;set;}
        public List<ChargeUnitWrapper> lstChargeUnitWrapper {get;set;}
        public SectionDataWapper() {
            sectionId = '';
            sectionTitle = '';
            checkTotal = false;
            lstUnit = new List<String>();
            mapTotal = new Map<String,Decimal>();
            sectionRemark = ''; 
            lstChargeUnitWrapper = new List<ChargeUnitWrapper>();    
        }
    }
    
    public PrintQuoteNewController() {
        shipId = ApexPages.currentPage().getParameters().get('id');
        userName = UserInfo.getUserId();
        ComInfo = new CompanyInformation__c();
        Uinfo = [SELECT Name, Branch1__c FROM User WHERE Id = :userName];
        if(Uinfo.Branch1__c != null){
            
            ComInfo = [SELECT Name,Address__c, Tel__c, Fax__c, Taxcode__c, Email__c, Website__c, Branch1__c, CompanyLogo__c FROM CompanyInformation__c WHERE Branch1__c =: Uinfo.Branch1__c];
        }

        ProcessInstanceId = '';
        TargetObjectId = '';
        quoteId = ApexPages.currentPage().getParameters().get('Id');
        printtype = ApexPages.currentPage().getParameters().get('printtype');
        lstSectionData = new List<SectionDataWapper>();
        mapSectionData = new Map<String,SectionDataWapper>();
        // lstChargeUnits = new List<String>();
        setChargeUnit = new Set<String>();
        Set<String> setSection = new Set<String>();
        lstSortChargeUnit = new List<String>();
        setSectionName = new Set<String>();
        numberTH = 2;
        mapChargeUnitWrapper = new Map<String,ChargeUnitWrapper>();
        List<String> lstRoute = new List<String>();
        if (!String.isBlank(quoteId)) {
            quote = getQuoteById();
            List<Quoteline__c> listAllQuoteLine = getAllQuoteLine();
            System.debug('listAllQuoteLine: ' + listAllQuoteLine);
            Map<String, List<String>> mapChargeUnit = new Map<String, List<String>>();
            for(Quoteline__c ql : listAllQuoteLine){
                
                if (ql.ChargeUnit__c == 'Container' ){
                    if (!setChargeUnit.contains(ql.ContainerType1__c)){
                        setChargeUnit.add(ql.ContainerType1__c);
                        lstSortChargeUnit.add(ql.ContainerType1__c);
                        // lstU.add(ql.ContainerType1__c);
                    }
                }
                else{
                    if (!setChargeUnit.contains(ql.ChargeUnit__c)){
                        setChargeUnit.add(ql.ChargeUnit__c);
                        lstSortChargeUnit.add(ql.ChargeUnit__c);
                        // lstU.add(ql.ChargeUnit__c);
                    }
                }
                // if(ql.ChargeUnit__c == 'Container'){
                //     if (!setSection.contains(ql.Quote_route__c)){
                //         setSection.add(ql.ContainerType1__c);
                //         // lstSortChargeUnit.add(ql.ContainerType1__c);
                //         lstU.add(ql.ContainerType1__c);
                //     }
                // }
                // else{
                //     if (!setSection.contains(ql.Quote_route__c)){
                //         setSection.add(ql.ChargeUnit__c);
                //         // lstSortChargeUnit.add(ql.ChargeUnit__c);
                //         lstU.add(ql.ChargeUnit__c);
                //     }
                // }
                // mapChargeUnit.put(ql.Quote_route__c, lstU);
                if(!setSection.contains(ql.Quote_route__c)){
                    setSection.add(ql.Quote_route__c);
                    lstRoute.add(ql.Quote_route__c);
                }
            }
            for(String route : lstRoute){
                List<String> lstU = new List<String>();
                for(Quoteline__c ql : listAllQuoteLine){
                    if(ql.Quote_route__c == route){
                        if (ql.ChargeUnit__c == 'Container'){
                            if(!lstU.contains(ql.ContainerType1__c)){
                                lstU.add(ql.ContainerType1__c);                     
                            }
                        }
                        else{
                            if(!lstU.contains(ql.ChargeUnit__c)){
                                lstU.add(ql.ChargeUnit__c);

                            }
                        }
                    }
                    
                }
                mapChargeUnit.put(route, lstU);
            }
            System.debug('setSection: ' + setSection);
            System.debug('mapChargeUnit: ' + mapChargeUnit);
            System.debug('lstSortChargeUnit: ' + lstSortChargeUnit);
            System.debug('setChargeUnit: ' + setChargeUnit);
            lstSortChargeUnit = bubbleSortChargeUnitWrapper(lstSortChargeUnit);
            for(Quoteline__c ql : listAllQuoteLine){

                if (ql.Quote_route__c != null){
                    if(!setSectionName.contains(ql.Quote_route__c)){
                        setSectionName.add(ql.Quote_route__c);
                        SectionDataWapper section = new SectionDataWapper();
                        for (String unit : mapChargeUnit.get(ql.Quote_route__c)){
                            section.mapTotal.put(unit,0);
                        }
                        section.lstUnit = mapChargeUnit.get(ql.Quote_route__c);
                        section.sectionId = ql.Quote_route__c;
                        section.sectionTitle = quote.TypeofTrade__c + ' - ' + ql.Quote_route__r.Route_Name__c;

                        mapSectionData.put(ql.Quote_route__c,section);
                    }
                }
            }
            System.debug('mapSectionData: ' + mapSectionData);
            numberTH = lstSortChargeUnit.size()+2;
            for(Quoteline__c ql : listAllQuoteLine){
                if (ql.Quote_route__c != null){
                    String key = ql.Quote_route__c+'-'+ql.ServiceID__c+'-'+ql.ChargeUnit__c;
                    if (mapChargeUnitWrapper.containsKey(key)){
                        ChargeUnitWrapper item = mapChargeUnitWrapper.get(key);
                        if (!item.lstremark.contains(ql.Remarks__c)){
                            item.remark += ', '+ ql.Remarks__c;
                            item.lstremark.add(ql.Remarks__c);
                        }
                        // item.remark += ', '+ ql.Remarks__c;
                        item.lstQuoteLine.add(ql);
                       
                        Decimal amount = ql.TotalSellingInclTaxActual__c != null ? ql.TotalSellingInclTaxActual__c : 0;

                        for (String unit : lstSortChargeUnit){
                            if(ql.ChargeUnit__c == 'Container'){
                                if (unit == ql.ContainerType1__c){
                                    if (item.mapAmountUnit.containsKey(ql.ContainerType1__c)){
                                        item.mapAmountUnit.put(ql.ContainerType1__c, item.mapAmountUnit.get(ql.ContainerType1__c) + amount);
                                    } else {
                                        item.mapAmountUnit.put(ql.ContainerType1__c, amount);
                                    }
                                } 

                            }
                            else{
                                if (unit == ql.ChargeUnit__c){
                                    if (item.mapAmountUnit.containsKey(ql.ChargeUnit__c)){
                                        item.mapAmountUnit.put(ql.ChargeUnit__c, item.mapAmountUnit.get(ql.ChargeUnit__c) + amount);
                                    } else {
                                        item.mapAmountUnit.put(ql.ChargeUnit__c, amount);
                                    }
                                } 
                            }
                        }
                        mapChargeUnitWrapper.put(key, item);
                    } else {
                        ChargeUnitWrapper item = new ChargeUnitWrapper();
                        for (String unit : lstSortChargeUnit){
                            item.mapAmountUnit.put(unit,0);
                        }
                        item.itemNameENG = ql.LineItemNameEng__c;
                        item.itemNameLocal = ql.LineItemNameLocal__c;
                        item.sectionId = ql.Quote_route__c;
                        // item.sectionName = ql.Quote_route__r.Name;
                        item.remark = ql.Remarks__c;
                        item.lstremark.add(ql.Remarks__c);
                        Decimal amount = ql.TotalSellingInclTaxActual__c != null ? ql.TotalSellingInclTaxActual__c : 0;
                        for (String unit : lstSortChargeUnit){
                           
                            if(ql.ChargeUnit__c == 'Container'){
                                if (unit == ql.ContainerType1__c){
                                    if (item.mapAmountUnit.containsKey(ql.ContainerType1__c)){
                                        item.mapAmountUnit.put(ql.ContainerType1__c, item.mapAmountUnit.get(ql.ContainerType1__c) + amount);
                                    } else {
                                        item.mapAmountUnit.put(ql.ContainerType1__c, amount);
                                    }
                                } 
                                
                            }
                            else{
                                if (unit == ql.ChargeUnit__c){
                                    if (item.mapAmountUnit.containsKey(ql.ChargeUnit__c)){
                                        item.mapAmountUnit.put(ql.ChargeUnit__c, item.mapAmountUnit.get(ql.ChargeUnit__c) + amount);
                                    } else {
                                        item.mapAmountUnit.put(ql.ChargeUnit__c, amount);
                                    }
                                } 
                            }

                        }
 
                        item.lstQuoteLine.add(ql);
                        mapChargeUnitWrapper.put(key, item);
                    }
                }
            }
            System.debug('size charge unit: '+mapChargeUnitWrapper.size());
             System.debug('charge unit: '+mapChargeUnitWrapper);
            for (ChargeUnitWrapper item : mapChargeUnitWrapper.values()){
                if (mapSectionData.containsKey(item.sectionId)){
                    SectionDataWapper section = mapSectionData.get(item.sectionId);
                    section.lstChargeUnitWrapper.add(item);
                    for (String unit : lstSortChargeUnit){
                        if (section.mapTotal.containsKey(unit)){
                            Decimal totalAmount = item.mapAmountUnit.get(unit) + section.mapTotal.get(unit);
                            section.mapTotal.put(unit,totalAmount);
                        }
 
                    }
                } else {
                    SectionDataWapper section = new SectionDataWapper();
                    section.checkTotal = item.checkTotal;
                    section.sectionId = item.sectionId;
                    section.sectionTitle = item.sectionName;
                    section.sectionRemark = '';
                    section.lstChargeUnitWrapper.add(item);
                    for (String unit : lstSortChargeUnit){
                        if (section.mapTotal.containsKey(unit)){
                            section.mapTotal.put(unit,item.mapAmountUnit.get(unit));
                        }
                        // else {
                        //     section.mapTotal.put(unit,0);
                        // }
                    }
                }
            }
        }
        for(SectionDataWapper section : mapSectionData.values()){
            lstSectionData.add(section);
            System.debug('sectionList: '+section.lstChargeUnitWrapper);
            System.debug('sectionTital: '+section.sectionTitle);
            System.debug('section: '+section.checkTotal);
            System.debug('section total: '+ section.mapTotal);
        }
        System.debug('size Section: '+mapSectionData.size());
        System.debug('Section: '+mapSectionData);
        System.debug('lstSectionData: '+lstSectionData);
    }

    public List<String> bubbleSortChargeUnitWrapper(List<String> listUnit) {
        List<String> values = sortListWithUnit(listUnit);
        return values;
    }

    public List<String> sortListWithUnit(List<String> listVal) {
        Schema.DescribeSObjectResult objSchema = Quoteline__c.sObjectType.getDescribe();
        Map<String, Schema.SObjectField> fieldMap = objSchema.fields.getmap();
        Map<String, Schema.SObjectField> fieldMap2 = objSchema.fields.getmap();
        List<Schema.Picklistentry>fld =fieldmap.get('ChargeUnit__c').getDescribe().getpicklistValues();
        List<Schema.Picklistentry>fld2 =fieldmap2.get('ContainerType1__c').getDescribe().getpicklistValues();
        System.debug('fld'+fld);
        
        List<String> pickList = new List<String>();

        for(Schema.Picklistentry pl : fld)
        {   
            if(pl.getValue() != 'Container'){
                pickList.add(pl.getValue());
            }
        }
        for(Schema.Picklistentry pl2 : fld2)
        {   
                pickList.add(pl2.getValue());
        }
        System.debug('pickList:'+pickList);
        System.debug('pickList:'+pickList.size());
        List<String> listResult = new List<String>();
        for(String s : pickList){
            if(listVal.contains(s)) {
                listResult.add(s);
            }
        }
        return listResult;
    }

    @AuraEnabled
    public static void createAttatchment(String recordId){
        System.debug('recordId: '+recordId);
        PageReference pdf_file = Page.page_PrintQuoteNew;
        pdf_file.getParameters().put('id', recordId);
        String namefile = 'Quotation';
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
        // insert cv;

    }

    private Quote__c getQuoteById() {
        String sqlStr = 'SELECT Id,' + String.join(new List<String>(setFieldsQuote), ',');
        sqlStr += ' FROM Quote__c WHERE Id = \'' + String.escapeSingleQuotes(quoteId) + '\'';
        List<Quote__c> sobjQuotes = Database.query(sqlStr);
        return !sobjQuotes.isEmpty() ? sobjQuotes[0] : new Quote__c();
    }

    private List<Quoteline__c> getAllQuoteLine() {
        String sqlStr = 'SELECT Id,' + String.join(new List<String>(setFieldsQuoteLine), ',');
        sqlStr += ' FROM Quoteline__c';
        String whereClause = '  WHERE QuoteID__c = \'' + String.escapeSingleQuotes(quoteId) + '\'';
        // whereClause += ' AND clofor_com_cfs__LineItemName__c != null';
        // whereClause += ' AND clofor_com_cfs__ChargeUnitInPrint__c != null';
        // whereClause += ' AND (clofor_com_cfs__SellingListPriceUSD__c != null OR clofor_com_cfs__SellingListPriceLocal__c != null)';
        // String orderClause = ' ORDER BY Quote_route__r.Section_number__c,clofor_com_cfs__ChargeUnitInPrint__c';
        sqlStr += whereClause;
        // sqlStr += orderClause; 
        List<Quoteline__c> quoteline;
        try{
            quoteline = Database.query(sqlStr);
        } catch(QueryException e){
            quoteline = new List<Quoteline__c>();
        }
        return quoteline;
        // List<Quoteline__c> sobjQuoteLines = Database.query(sqlStr);
        // return !sobjQuoteLines.isEmpty() ? sobjQuoteLines : new List<Quoteline__c>();
    }
   
}