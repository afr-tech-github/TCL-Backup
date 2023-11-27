public with sharing class documentControler {
    private static Set<String> SoQuery = new Set<String>();
    private static Set<String> docDetal = new Set<String>();

    private static Set<String> CNTRQuery = new Set<String>();
    public CompanyInformation__c adr1 {get;set;}
    public CompanyInformation__c adr2 {get;set;}
    public CompanyInformation__c adr3 {get;set;}
    public String textTotal { get; set; }
    public String textTotalVN { get; set; }

    public String formName { get; set; }
    

    public Document__c Doc {get;set;}
    public String formattedDateTime { get; set; }
    public String cur { get; set; }

    public Decimal Total { get; set; }
    public Integer TotalVN { get; set; }


    public List<Documentsdetails__c> DocDT {get;set;}


    
    static{
        SoQuery.add('RecordType.name');

        
        SoQuery.add('AccountName__c');
        SoQuery.add('Address__c');
        SoQuery.add('Tel__c');
        SoQuery.add('Fax__c');
        SoQuery.add('TaxCode__c');
        SoQuery.add('Name');
        SoQuery.add('JobreferenceNo__c');
        SoQuery.add('Origin__c');
        SoQuery.add('MBLNo__c');
        SoQuery.add('FTMSSO__r.Shipper__r.Name');
        SoQuery.add('FTMSSO__r.Shipper__r.Company_Address__c');
        SoQuery.add('VesselVoy__c');
        SoQuery.add('QtyCTNS__c');
        SoQuery.add('ETD__c');
        SoQuery.add('ETA__c');
        SoQuery.add('Dest__c');
        SoQuery.add('HBLNo__c');
        SoQuery.add('FTMSSO__r.Consignee__r.Name');
        SoQuery.add('FTMSSO__r.Consignee__r.Company_Address__c');
        SoQuery.add('GW__c');
        SoQuery.add('CBM__c');
        SoQuery.add('ContSeal__c');

        SoQuery.add('BankAccount__r.BankAccountNameLocal__c');
        
        SoQuery.add('BankAccount__r.InternationalBank__c');

        SoQuery.add('BankAccount__r.BankOfficialName__c');
        SoQuery.add('BankAccount__r.BankBranchName__c');
        SoQuery.add('BankAccount__r.BankShortName__c');
        SoQuery.add('BankAccount__r.BankAddress__c');
        SoQuery.add('BankAccount__r.SWIFTCode__c');
        SoQuery.add('BankAccount__r.BankAccountNumber__c');



        docDetal.add('PricingName__c');
        docDetal.add('PricingNamePrinted__c');

        docDetal.add('Quantity__c');


        docDetal.add('TotalBuyingInclTaxActual__c');


        docDetal.add('TotalSellingInclTaxActual__c');

        docDetal.add('UnitPriceofBuyingActual__c');

        docDetal.add('UnitPriceofSellingActual__c');





        docDetal.add('ChargeUnit__c');
        docDetal.add('UnitPriceofBuyingFCY__c');
        docDetal.add('UnitPriceofBuyingLocal__c');
        docDetal.add('UnitPriceofSellingFCY__c');
        docDetal.add('UnitPriceofSellingLocal__c');
        docDetal.add('TaxRatioBuying__c');
        docDetal.add('TaxRatioSelling__c');
        docDetal.add('CurrencyBuying__c');
        docDetal.add('CurrencySelling__c');
        docDetal.add('Total_Selling_Incl_Tax_Local__c');
        docDetal.add('Total_Selling_Incl_Tax_FCY__c');
        docDetal.add('TotalBuyingInclTaxLocal__c');
        docDetal.add('TotalBuyingInclTaxFCY__c');



       
    }


    public documentControler() {
        String DocID = ApexPages.currentPage().getParameters().get('id');
        cur = ApexPages.currentPage().getParameters().get('cur');
        
        //  cur= 'usd';
         Total=0;
         TotalVN=0;
       adr1= getCpn('Hồ Chí Minh');
       adr2= getCpn('Đà Nẵng');
       adr3= getCpn('Hải Phòng');



        Doc = getDoc(DocID);
        DocDT= getDocDT(DocID);

        Datetime currentDateTime = Datetime.now();
        formattedDateTime = formatDatetime(currentDateTime);
        formName=Doc.RecordType.name;
        if(formName== 'Invoice' && DocDT.size()>0 ){
            if( DocDT[0].TotalBuyingInclTaxLocal__c !=null && DocDT[0].TotalBuyingInclTaxFCY__c != null) {
                Doc.RecordType.name='Credit Note';
            }else if(DocDT[0].Total_Selling_Incl_Tax_Local__c !=null && DocDT[0].Total_Selling_Incl_Tax_FCY__c != null){
                Doc.RecordType.name='Debit Note';
            }
        }

        if(cur=='vnd' && Doc.RecordType.name == 'Credit Note' && DocDT.size()>0 ){
            for(Documentsdetails__c item : DocDT){
                if(item.TotalBuyingInclTaxLocal__c != null)
                TotalVN += Integer.valueOf(item.TotalBuyingInclTaxLocal__c);
            }
        }
        else if(cur=='usd' && Doc.RecordType.name == 'Credit Note'  && DocDT.size()>0){
            for(Documentsdetails__c item : DocDT){
                if(item.TotalBuyingInclTaxFCY__c != null)
                
                Total += item.TotalBuyingInclTaxFCY__c;
            }
        }
        else if(cur=='vnd' && Doc.RecordType.name == 'Debit Note'  && DocDT.size()>0){
            for(Documentsdetails__c item : DocDT){
                if(item.Total_Selling_Incl_Tax_Local__c != null)
                
                TotalVN += Integer.valueOf(item.Total_Selling_Incl_Tax_Local__c);
            }
        } 
        else if(cur=='usd' && Doc.RecordType.name == 'Debit Note'  && DocDT.size()>0){
            for(Documentsdetails__c item : DocDT){
                if(item.Total_Selling_Incl_Tax_FCY__c != null)
                
                Total += item.Total_Selling_Incl_Tax_FCY__c;
            }
        }
        
       if(cur=='vnd'){
        Total= TotalVN + 0.00;
       }
       textTotal= ReadNumberToWords.convert(Total);
    //    textTotalVN='12xx';
       textTotalVN=ReaReadNumberToWordsVN.convertToVietnamese( TotalVN);
    }

    public String formatDatetime(Datetime dt) {
        // Format the datetime in the desired format
        return dt.format('dd MMM, yyyy  h:mm:ssa');
     }
   
     public void generateAttachmentFile(){
          
        String recordID = String.valueOf(ApexPages.currentPage().getParameters().get('id'));

        // checkPackage = Boolean.valueOf(ApexPages.currentPage().getParameters().get('checkPack'));
        // System.debug('1234:'+ requiredAttachment);
        PageReference pageRef = new PageReference('/apex/page_TT_HT_NoiBo');
        pageRef.getParameters().put('Id', recordID);
        // pageRef.getParameters().put('checkPackage', String.valueOf(checkPackage));
        System.debug('1234:xxxxx' + pageRef);
        String namefile = 'Contract' + '_v';

        String attachNameSearch = namefile + '%';
        // get exist file Name
        List<Attachment> attachments = [SELECT Id, Name, ParentId 
                                        FROM Attachment 
                                        WHERE ParentId =: recordID 
                                        AND Name LIKE : attachNameSearch 
                                        ORDER BY CreatedDate DESC LIMIT 1];
                                        
        if(attachments.isEmpty()){
            namefile += '1.1';
        }else{
            String attachNameExist = attachments[0].Name;
            attachNameExist = attachNameExist.substringAfter(namefile);
            attachNameExist = attachNameExist.substringBefore('.pdf');
            Decimal versionNumber = Decimal.valueOf(attachNameExist);
            versionNumber += 0.1;
            namefile += String.valueOf(versionNumber);
        }
        if(true){
            Attachment attach = new Attachment();
            Blob body;
            attach.Name = namefile + '.pdf'; 
            attach.IsPrivate = false;
            attach.ParentId = recordID;
            if(!Test.isRunningTest()){
            body = pageRef.getContentAsPDF();
            System.debug('1234:'+body);
            attach.Body = body;
            FlsService.doInsert(attach);
        }
        }
        
        
    }
    private CompanyInformation__c getCpn(String branch){
        CompanyInformation__c  Company= [SELECT Name,Name__c,
        Id,CompanyLogo__c,
        TaxCode__c,Tel__c,Website__c
        ,Email__c ,Address__c,Fax__c
        FROM CompanyInformation__c  WHERE Branch1__c =:branch limit 1];
        if(Company == null){
            return new CompanyInformation__c();
        }
        return Company;
    }

    private Document__c getDoc(String scheduleID){
        String strSelect = String.join(new List<String>(SoQuery), ',');
        String strQuery = 'SELECT ' + strSelect 
                    + ' FROM Document__c'
                    + ' WHERE Id = \'' + scheduleID + '\'';
                    Document__c donhang;
        try{
            donhang = Database.query(strQuery);
        } catch(QueryException e){
            donhang = new Document__c();
        }
        return donhang;
    }

    private List<Documentsdetails__c> getDocDT(String scheduleID){
        String strSelect = String.join(new List<String>(docDetal), ',');
        String strQuery = 'SELECT ' + strSelect 
                    + ' FROM Documentsdetails__c'
                    + ' WHERE Document__c = \'' + scheduleID + '\'';
                    List<Documentsdetails__c> donhang;
        try{
            donhang = Database.query(strQuery);
        } catch(QueryException e){
            donhang = new List<Documentsdetails__c>();
        }
        return donhang;
    }

    

}