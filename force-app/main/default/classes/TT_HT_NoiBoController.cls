public with sharing class TT_HT_NoiBoController {
        private static Set<String> SoQuery = new Set<String>();
        private static Set<String> CNTRQuery = new Set<String>();
        public CompanyInformation__c Company {get;set;}
        public String formattedDateTime { get; set; }
        public Attachment myfile  {get;set;}
        public case__c So {get;set;}
        public User user {get;set;}
        public Account ac {get;set;}
        public Blob body { get; set; }
        public String name { get; set; }
        public String OderID { get; set; }
        
        static{
            SoQuery.add('Account_Owner__c');
            SoQuery.add('Title__c');
            SoQuery.add('Role__c');
            SoQuery.add('Phone__c');
            SoQuery.add('Sales_Request_s_Title__c');
            SoQuery.add('Sales_Request_s_Role__c');
            SoQuery.add('Sales_Request_s_Phone__c');
            // SoQuery.add('OwnerId.LastName');
            // SoQuery.add('OwnerId.FirstName');
            SoQuery.add('OwnerId');
            SoQuery.add('AccountId__c');

            SoQuery.add('AccountId__r.Name');
            SoQuery.add('Tax_Code__c');
            SoQuery.add('Company_Address__c');
            SoQuery.add('Service_type_original__c');
            SoQuery.add('Service_Type__c');
            SoQuery.add('Credit_limit__c');
            SoQuery.add('Payment_Methods__c');
            SoQuery.add('Sales_Owner__c');
            SoQuery.add('Sales_Request__c');
        


            
        }
       

        public TT_HT_NoiBoController() {
           
           OderID = ApexPages.currentPage().getParameters().get('id');
           
            So = getSo(OderID);
        

            Company= [SELECT Name,Name__c,
            Id,CompanyLogo__c,
            TaxCode__c,Tel__c,Website__c
            ,Email__c ,Address__c,Fax__c
            FROM CompanyInformation__c  WHERE Branch1__c = 'Hồ Chí Minh' limit 1];


            if(So.OwnerId  != null){
    
                user = [SELECT FirstName, LastName, Email
                        FROM User  WHERE Id =: So.OwnerId ];
            }else user =  new User();

            if(So.AccountId__c  != null){
    
                ac = [SELECT Name
                        FROM Account  WHERE Id =: So.AccountId__c ];
            }else ac =  new Account();
            
        }
        
        private case__c getSo(String scheduleID){
            String strSelect = String.join(new List<String>(SoQuery), ',');
            String strQuery = 'SELECT ' + strSelect 
                        + ' FROM case__c'
                        + ' WHERE Id = \'' + scheduleID + '\'';
                        case__c donhang;
            try{
                donhang = Database.query(strQuery);
            } catch(QueryException e){
                donhang = new case__c();
            }
            return donhang;
        }

        
        

       
        public void  Savedoc()
        {
            String OderID = ApexPages.currentPage().getParameters().get('id');
            Attachment attach = new Attachment();
                 attach.Name = name; 
                attach.IsPrivate = false;
                attach.ParentId = OderID;
                if(!Test.isRunningTest()){
                attach.Body = body;
                try{
                    
                    FlsService.doInsert(attach);
                }catch(Exception ex){
                    System.debug(ex.getMessage());
                }
                // if(body!=null && name != null){

                    
                // }
              }   
        }
       
    }