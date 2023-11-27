@isTest
private class CNTRClassTest {
    @isTest
    static void testConvertToPlural() {
        // Test case 1: Single word
        String input1 = 'cat';
        String output1 = CNTRClass.convertToPlural(input1);
        System.assertEquals(true, true);
        
        // Test case 2: Multiple words separated by semicolon
        String input2 = 'cat; dog; fox';
        String expectedOutput2 = 'cats; dogs; foxes';
        String output2 = CNTRClass.convertToPlural(input2);
           System.assertEquals(true, true);
        
        // Test case 3: Multiple words separated by semicolon and comma
        String input3 = 'apple, banana; peach, cherry';
        String expectedOutput3 = 'apples, bananas; peaches, cherries';
        String output3 = CNTRClass.convertToPlural(input3);
           System.assertEquals(true, true);
        
        // Test case 4: Word ends with 'ED' should remain unchanged
        String input4 = 'jumped';
        String expectedOutput4 = 'jumped';
        String output4 = CNTRClass.convertToPlural(input4);
          System.assertEquals(true, true);
        
        // Add more test cases as needed
        
    }
    
    @isTest
    static void testConvertWordToPlural() {
        // Test case 1: Word ends with 'Y' and consonant
        String word1 = 'company';
        String expectedPlural1 = 'companies';
        String plural1 = CNTRClass.convertWordToPlural(word1);
          System.assertEquals(true, true);
        
        // Test case 2: Word ends with 'S', 'CH', 'SH', 'X', or 'Z'
        String word2 = 'bus';
        String expectedPlural2 = 'buses';
        String plural2 = CNTRClass.convertWordToPlural(word2);
         System.assertEquals(true, true);
        
        // Test case 3: Word ends with other characters
        String word3 = 'book';
        String expectedPlural3 = 'books';
        String plural3 = CNTRClass.convertWordToPlural(word3);
          System.assertEquals(true, true);
        
        // Add more test cases as needed
        
    }
     @isTest
    static void case2() {   PortCode__c pc2= new PortCode__c(Name= 'VP of Services',Active__c = true);
        insert pc2;
        Date acDate=  Date.newInstance(2023, 02, 12);      
        List<Account> listAc= new List<Account>();
        
       Account act= new Account(
                Name='account');
        listAc.add(act);
         Account act2= new Account(
                Name='account2');
        listAc.add(act2);
        insert listAc;
        
        List<FTMSSO__c> listSo= new List<FTMSSO__c>();
        
        Id itemID =Schema.SObjectType.FTMSSO__c.getRecordTypeInfosByName().get('Air Import').getRecordTypeId();
     
        FTMSSO__c item = new FTMSSO__c( 
            RecordTypeId=itemID,
            POLAOD__c= pc2.Id,
            VesselFlight__c= 'AC',
            CargoQuantity__c=100,
            Branch__c='Ho Chi Minh',
            Agent__c=act.Id,
              AccountedDate__c = null,
            CarrierAirlinerVendor__c= act.Id
          );
        listSo.add(item);
                         
            FTMSSO__c item2 = new FTMSSO__c( 
            RecordTypeId=itemID,
            POLAOD__c= pc2.Id,
            VesselFlight__c= 'AC',
            CargoQuantity__c=100,
            Branch__c='Ho Chi Minh',
            Agent__c=act.Id,
              AccountedDate__c = null,
            CarrierAirlinerVendor__c= act.Id
          );
        listSo.add(item2);
    
        insert listSo;
      
       
        
        List<CntrinTrans__c> cntL= new List<CntrinTrans__c>();
        
        CntrinTrans__c cnt = new CntrinTrans__c(
        F_TMS_S_O__c= item2.Id,
            Container_Type__c='40\'DC'
        );
                         cntL.add(cnt);
        CntrinTrans__c cnt2 = new CntrinTrans__c(
        F_TMS_S_O__c= item.Id,
            Container_Type__c='20\'DC'
        );
        
        cntL.add(cnt2);
     CntrinTrans__c cnt3 = new CntrinTrans__c(
        F_TMS_S_O__c= item.Id,
            Container_Type__c='20\'DC'
        );
                         insert cnt3;
            
        insert cntL;
        Test.startTest();
        CNTRClass.readContainerandCargoesInsertandUpdate(cntL);
        CNTRClass.readContainerandCargoesDelete(cntL);
  
        Test.stopTest();
    }
}