public with sharing class PrintBK{
    public FTMSSO__c shipment {get;set;}
    public CompanyInformation__c companyInfor {get; set;}
    private String shipId {get; set;}
    public String bookingNo {get; set;}
    public Date currentDate  {get; set;}
   	public String formattedDate {get; set;}
    public Date dateToFormat {get; set;}
    public String formattedDateTable {get; set;}
    public String formattedTimeTable {get; set;}
    public Date originalDate  {get; set;}
    public Time originalTime  {get; set;}
    public String closingTime  {get; set;}
    public String terminal  {get; set;}
    public String html {get; set;}
    private static Set<String> fieldsComInfoQuery = new Set<String>();
    static{
        fieldsComInfoQuery.add('Name');
        fieldsComInfoQuery.add('Address__c');
        fieldsComInfoQuery.add('Branch1__c');
        fieldsComInfoQuery.add('Fax__c');
        fieldsComInfoQuery.add('Tel__c');
        fieldsComInfoQuery.add('TaxCode__c');
        fieldsComInfoQuery.add('Website__c');
        fieldsComInfoQuery.add('ShowAddressonHeader__c');
    }

    private static Set<String> fieldsFTMSQuery = new Set<String>();
    static{
      
        fieldsFTMSQuery.add('FlightDetailInformation__c');
        fieldsFTMSQuery.add('Consignee__r.name');
        fieldsFTMSQuery.add('ShipperDetailInformation__c');
        fieldsFTMSQuery.add('PlaceofReceipt__r.Name');
        fieldsFTMSQuery.add('PlaceofDelivery__r.Name');
        fieldsFTMSQuery.add('PlaceofStuffing__c');
        fieldsFTMSQuery.add('CargoClosingTime__c');
     
       
        fieldsFTMSQuery.add('MeasurementTotalCBM__c');
        fieldsFTMSQuery.add('PlaceofReceipt__r.Standard_Port_Code__c');
        fieldsFTMSQuery.add('FinalDestination__r.Standard_Port_Code__c');

       
       

        fieldsFTMSQuery.add('GrossWeight__c');
        fieldsFTMSQuery.add('MeasurementTotalCBM__c');

        fieldsFTMSQuery.add('Dimension__c');
        
        fieldsFTMSQuery.add('Terminal__r.Name');
        fieldsFTMSQuery.add('Terminal__r.CountryCode__c');
 
        
       
        
    }

    public PrintBK(){
        FormatDate formatDate = new FormatDate();
        companyInfor = new CompanyInformation__c();
        companyInfor = getComInfor();
        
        shipId = ApexPages.currentPage().getParameters().get('Id');
        shipment = getShipment(shipId);
        
        formattedDate = formatDate.FormatDate(Date.today());
        if (shipment.CargoClosingTime__c != null) {
            originalDate = shipment.CargoClosingTime__c.date();
            originalTime = shipment.CargoClosingTime__c.time();
            formattedDateTable = formatDate.FormatDate(originalDate);
            formattedTimeTable = formateTime(originalTime);
            closingTime = formattedDateTable +' - ' + formattedTimeTable;
        }
        if(shipment.Terminal__r.Name != null || shipment.Terminal__r.CountryCode__c != null)
            terminal = shipment.Terminal__r.Name + ' / ' + shipment.Terminal__r.CountryCode__c;
        html = getGeneratedHTMLPage();
        
    }
    private String formateTime(Time inputTime){
        Integer hours = inputTime.hour();
        Integer minutes = inputTime.minute();
        
        String formattedTime = hours.format() + ':' + minutes.format().leftPad(2, '0');
        
        return formattedTime;
    }
    
    
    
    private CompanyInformation__c getComInfor (){
        CompanyInformation__c infor = new CompanyInformation__c();
        String strSelect = String.join(new List<String>(fieldsComInfoQuery), ','); 
        String strQuery = 'SELECT ' + strSelect +
                  ' FROM CompanyInformation__c' +
                  ' WHERE Branch1__c = \'Hồ Chí Minh\'' ;
        try{
            infor = Database.query(strQuery);
        } catch(QueryException e){
            infor = new CompanyInformation__c();
        }
        return infor;
    }

    private FTMSSO__c getShipment(String shipId){
      
      
        String strSelect = String.join(new List<String>(fieldsFTMSQuery), ','); 
        String strQuery  =  'SELECT ' + strSelect 
                            + ' FROM FTMSSO__c '
                            + ' WHERE Id = \'' + String.escapeSingleQuotes(shipId) + '\'';
         System.debug('queryShip: '+strQuery);
         FTMSSO__c shipment;
        try{
            shipment = Database.query(strQuery); 
        } catch(QueryException e){
            shipment = new FTMSSO__c();
        }
   
        System.debug('bac: ' + shipment.FlightDetailInformation__c);
        return shipment;
    }
    private String getGeneratedHTMLPage() {
        String html = '<html>';
        html += '<head>';
        html += '<title>Trang HTML trong Apex Class</title>';
        html += '</head>';
        html += '<body>';
        html += '<div id="content-company">';
        html += '<div>';
        html += '<strong style="border-bottom:1px solid black">FROM:</strong>&nbsp;';
        html += '<strong>TIMES CARGO LOGISTIC CO., LTD</strong>';
        html += '</div>';
        html += '<div>';
        html += '<strong style="border-bottom:1px solid black">TO:</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
        html += '<strong>VUONG QUOC SO JSC (VN HUB)</strong>';
        html += '</div>';
        html += '<div>';
        html += '<strong style="border-bottom:1px solid black">ATTN:</strong>&nbsp;';
        html += '<strong> MS. PHUONG – 090.886.5470</strong>';
        html += '</div>';
        html += '<div style="margin-left: 400px;">';
        html += '<strong>Date: </strong>';
        html += '<strong>' + formattedDate + '</strong>';
        html += '</div>';
        html += '</div>';
        html += '</html>';

       
        return html;
    }
   
    
    

}