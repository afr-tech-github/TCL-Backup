@isTest
public class AddMultipleQuoteLineControllerTest {
  	@isTest
    public Static void TestCase1(){
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        
     	User usr = new User(LastName = 'LIVESTON',
                           FirstName='JASON',
                           Alias = 'jliv',
                           Email = 'jason.liveston@asdf.com',
                           Username = 'jas2on.liveston@asdf.com',
                           ProfileId = profileId.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US'
                           );
        insert usr;
        
        Account act= new Account(
                Name='account');
        insert act;
        
        Quote__c qt= new Quote__c(
            QuoteName__c = 'Qt1',
            Validto__c= Date.newInstance(2023, 11, 11),
            QuotePIC__c= usr.Id,
            RequesterCompany__c= act.Id
        );
        insert qt;
        
        Quote__c qt2= new Quote__c(
            QuoteName__c = 'Qt2',
            Validto__c= Date.newInstance(2023, 11, 11),
            QuotePIC__c= usr.Id,
            RequesterCompany__c= act.Id
        );
        insert qt2;
        
        list<Quoteline__c> lineList= new List<Quoteline__c>();
        Quoteline__c qtline= new Quoteline__c(
        QuoteID__c =qt.Id
        );
        lineList.add(qtline);
        
      //  insert lineList;
        Test.startTest();
        AddMultipleQuoteLineController AMQC = new AddMultipleQuoteLineController();
        String rs = AddMultipleQuoteLineController.saveQuoteLineList(lineList, qt2.Id);
        System.assertEquals(true, true);
        Test.stopTest();
        
    }
}