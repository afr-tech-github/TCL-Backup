public with sharing class FMS_ShowReceivablePayableController {
	private static final String TAB_PARAMETER_NAME = 'isTabShow';
	private static final String RECEIVABLE_TAB = 'receivableTab';
	private static final String PAYABLE_TAB = 'payableTab';
	private static final String MEISAIID = 'meisaiIds';
	private static final String SHOW_ALL = 'Show all';
	private static final String CHECK_ONLY = 'Check only';
	private static final String UNCHECK_ONLY = 'Un-check only';
	private static final String LOCAL = 'Local';
	private static final String ENGLISH = 'English';
	private static final String USD = 'USD';
	private static final String VND = 'VND';
	private static final String PHP = 'PHP';
	private static final String EUR = 'EUR';
	private static final String KHR = 'KHR';
	private static final String JPY	 = 'JPY';
	private static final String KRW = 'KRW';

	public static FTMSBill__c objAnkenMeisaiFilter {get; set;}
	public static FTMSBill__c objAnkenMeisaiFilterTo {get; set;}
	public static FTMSBill__c objAnkenMeisaiInput {get; set;}
	public static String orderNo {get; set;}
	public static String CurrencySelling {get; set;}

	public Boolean isShowReceivable {get; set;}
	public String localCurrency {get; set;}
	public String tabNameSelect {get; set;}
	public String pickCurrency {get; set;}

	static {
		objAnkenMeisaiInput = new FTMSBill__c();
		objAnkenMeisaiFilter = new FTMSBill__c(
			AmountReceivedfromCustomerLocal__c = 0
			,AmountSellingInclTaxAdjustLocal__c = 0
			,AmountPaidforCustomerLocal__c = 0
			,AmountBuyingInclTaxAdjust_Local__c = 0
		);
		objAnkenMeisaiFilterTo = new FTMSBill__c();
	}

	public FMS_ShowReceivablePayableController(ApexPages.StandardSetController stdController) {
		try {
			SiteCustomSettings__c objSiteCustomSettings = SiteCustomSettings__c.getOrgDefaults();
			if (String.isNotBlank(objSiteCustomSettings.Id)) {
				this.localCurrency = objSiteCustomSettings.LocalCurrency__c;
			}
			
			this.isShowReceivable = true;
			this.tabNameSelect = RECEIVABLE_TAB;
		} catch (Exception ex) {
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
		}
	}

	@RemoteAction
    public static List<FTMSBill__c> getData(Boolean isReceivable
    															,Decimal amount
															  	,Decimal unpaid
															  	,String customerId
																,String advance
																,String strDateFrom
																,String strDateTo
																,String orderNo
																,String currencyOption) {
		if (amount == null || amount < 0) {
			amount = 0;
		}

		if (unpaid == null || unpaid < 0) {
			unpaid = 0;
		}
		
		Boolean isAdvance = null;
		if (advance == CHECK_ONLY) {
			isAdvance = true;
		} else if (advance == UNCHECK_ONLY) {
			isAdvance = false;
		}

		Date dateFrom = null;
		Date dateTo = null;

		if (String.isNotBlank(strDateFrom)) {
			dateFrom = Date.parse(strDateFrom);
		}

		if (String.isNotBlank(strDateTo)) {
			dateTo = Date.parse(strDateTo);
		}

		List<String> orderNoList = new List<String>();
		if (String.isNotBlank(orderNo)) {
			List<String> orderNoInputList = orderNo.split(',');

			for (String oderNoInput : orderNoInputList) {
				oderNoInput = oderNoInput.trim();
				if (String.isNotBlank(oderNoInput)) {
					orderNoList.add('%' + oderNoInput + '%');
				}
			}
		}

        return getAnkenMeisaiList(isReceivable, amount, unpaid, customerId, isAdvance, dateFrom, dateTo, orderNoList, currencyOption);   
    }

	public void actionProcessing() {
		Savepoint sp;
		try {			
			List<String> ankenMeisaiIdUpdateList = new List<String>();
			String meisaiIdsSelected = ApexPages.currentPage().getParameters().get(MEISAIID);

			if (String.isNotBlank(meisaiIdsSelected)) {
				ankenMeisaiIdUpdateList = meisaiIdsSelected.split(',');
			}

			if (ankenMeisaiIdUpdateList.size() <= 10) {
				List<FTMSBill__c> ankenMeisaiUpdateList = new List<FTMSBill__c>();
				for(String meisaiIdUpdate : ankenMeisaiIdUpdateList) {
					ankenMeisaiUpdateList.add(this.createanKenMeisaiUpdate(meisaiIdUpdate, objAnkenMeisaiInput, this.isShowReceivable));					
				}

				sp = Database.setSavepoint();
				FlsService.doupdate(ankenMeisaiUpdateList);
			} else {
				ShowReceivablePayableBatch batch = new ShowReceivablePayableBatch(ankenMeisaiIdUpdateList, objAnkenMeisaiInput, this.isShowReceivable);
				Database.executeBatch(batch, 30);
			}
		} catch (Exception ex) {
			if (sp != null) {
				Database.rollback(sp);
			}
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
		}
	}	

	public Decimal getAmount(){
		Decimal amountNumber = objAnkenMeisaiFilter.AmountReceivedfromCustomerLocal__c;
		if(isShowReceivable){
			amountNumber = objAnkenMeisaiFilter.AmountSellingInclTaxAdjustLocal__c; 
		}
		return amountNumber;
	}

	public Decimal getUnpaid(){
		Decimal unpaidNumber = objAnkenMeisaiFilter.AmountPaidforCustomerLocal__c;
		if(isShowReceivable){
			unpaidNumber = objAnkenMeisaiFilter.AmountBuyingInclTaxAdjust_Local__c; 
		}
		return unpaidNumber;
	}

	public void actionFilter() {
		try {
			if (objAnkenMeisaiFilter.AmountReceivedfromCustomerLocal__c == null
				|| objAnkenMeisaiFilter.AmountReceivedfromCustomerLocal__c < 0) {
				objAnkenMeisaiFilter.AmountReceivedfromCustomerLocal__c = 0;
			}

			if (objAnkenMeisaiFilter.AmountSellingInclTaxAdjustLocal__c == null
				|| objAnkenMeisaiFilter.AmountSellingInclTaxAdjustLocal__c < 0) {
				objAnkenMeisaiFilter.AmountSellingInclTaxAdjustLocal__c = 0;
			}

			if (objAnkenMeisaiFilter.AmountBuyingInclTaxAdjust_Local__c == null
				|| objAnkenMeisaiFilter.AmountBuyingInclTaxAdjust_Local__c < 0) {
				objAnkenMeisaiFilter.AmountBuyingInclTaxAdjust_Local__c = 0;
			}

			if (objAnkenMeisaiFilter.AmountPaidforCustomerLocal__c == null
				|| objAnkenMeisaiFilter.AmountPaidforCustomerLocal__c < 0) {
				objAnkenMeisaiFilter.AmountPaidforCustomerLocal__c = 0;
			}
		} catch (Exception ex) {
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
		}
	}

	public void actionChangeTab() {
		try {
			this.isShowReceivable = Boolean.valueOf(ApexPages.currentPage().getParameters().get(TAB_PARAMETER_NAME));
			if (this.isShowReceivable == true) {
				this.tabNameSelect = RECEIVABLE_TAB;
			} else {
				this.tabNameSelect = PAYABLE_TAB;
			}

			objAnkenMeisaiFilter = new FTMSBill__c(
				AmountReceivedfromCustomerLocal__c = 0
				,AmountSellingInclTaxAdjustLocal__c = 0
				,AmountPaidforCustomerLocal__c = 0
				,AmountBuyingInclTaxAdjust_Local__c = 0
			);
			objAnkenMeisaiFilterTo = new FTMSBill__c();
			orderNo = null;
		} catch (Exception ex) {
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
		}
	}

	public void actionCancel() {
		try {
			objAnkenMeisaiInput = new FTMSBill__c();			
		} catch (Exception ex) {
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
		}
	}

	public List<SelectOption> getItems() {
		List<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption(SHOW_ALL, SHOW_ALL));
		options.add(new SelectOption(CHECK_ONLY, CHECK_ONLY));
		options.add(new SelectOption(UNCHECK_ONLY, UNCHECK_ONLY));
		return options;
	}

	public List<SelectOption> getItemsLanguage() {
		List<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption(LOCAL, LOCAL));
		options.add(new SelectOption(ENGLISH, ENGLISH));
		return options;
	}

	public List<SelectOption> getItemsCurrency() {
		String Local = '';
		SiteCustomSettings__c objSiteCustomSettings = SiteCustomSettings__c.getOrgDefaults();
		if (String.isNotBlank(objSiteCustomSettings.Id)) {
			Local = objSiteCustomSettings.LocalCurrency__c;
		}
		List<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption(Local, 'Local'));
		if (Local != USD){
			options.add(new SelectOption(USD, USD));
		}
		if (Local != VND){
			options.add(new SelectOption(VND, VND));
		}
		if (Local != PHP){
			options.add(new SelectOption(PHP, PHP));
		}
		if (Local != EUR){
			options.add(new SelectOption(EUR, EUR));
		}
		if (Local != JPY){
			options.add(new SelectOption(JPY, JPY));
		}
		if (Local != KHR){
			options.add(new SelectOption(KHR, KHR));
		}
		if (Local != KRW){
			options.add(new SelectOption(KRW, KRW));
		}
		return options;
	}
	
	private FTMSBill__c createanKenMeisaiUpdate(String meisaiIdUpdate
																	,FTMSBill__c objAnkenMeisai
																	,Boolean isReceivable) {
		FTMSBill__c objAnkenMeisaiUpdate = new FTMSBill__c();
		objAnkenMeisaiUpdate.Id = meisaiIdUpdate;
		CurrencySelling = objAnkenMeisai.CurrencySelling__c;
		System.debug('CurrencySelling: '+ CurrencySelling);

		if (isReceivable) {
			objAnkenMeisaiUpdate.PaymentConfirmedSelling__c = objAnkenMeisai.PaymentConfirmedSelling__c;
			objAnkenMeisaiUpdate.ApplicantSelling__c = objAnkenMeisai.ApplicantSelling__c;
			objAnkenMeisaiUpdate.PaymentTypeSelling__c = objAnkenMeisai.PaymentTypeSelling__c;
			objAnkenMeisaiUpdate.PaymentSettledDateSelling__c = objAnkenMeisai.PaymentSettledDateSelling__c;
			objAnkenMeisaiUpdate.BankAccountforReceipt__c = objAnkenMeisai.BankAccountforReceipt__c;
			objAnkenMeisaiUpdate.PaymentNotesSelling__c = objAnkenMeisai.PaymentNotesSelling__c;
		} else {
			objAnkenMeisaiUpdate.PaymentConfirmedBuying__c = objAnkenMeisai.PaymentConfirmedBuying__c;
            objAnkenMeisaiUpdate.BeneficiaryBuying__c = objAnkenMeisai.BeneficiaryBuying__c;
			// objAnkenMeisaiUpdate.clofor_com_cfs__actual_payer__c = objAnkenMeisai.clofor_com_cfs__actual_payer__c;
			objAnkenMeisaiUpdate.PaymentTypeBuying__c = objAnkenMeisai.PaymentTypeBuying__c;
			objAnkenMeisaiUpdate.PaymentSettledDateBuying__c = objAnkenMeisai.PaymentSettledDateBuying__c;
			objAnkenMeisaiUpdate.BankAccountforPayment__c = objAnkenMeisai.BankAccountforPayment__c;
			objAnkenMeisaiUpdate.PaymentNotesBuying__c = objAnkenMeisai.PaymentNotesBuying__c;
		}

		return objAnkenMeisaiUpdate;
	}

	private static List<FTMSBill__c> getAnkenMeisaiList(Boolean isReceivable
																		  ,Decimal amount
																		  ,Decimal unpaid
																		  ,String customerId
																		  ,Boolean isAdvance
																		  ,Date dateFrom
																		  ,Date dateTo
																		  ,List<String> orderNoList
																		  ,String currencyOption) {		

		String soqlQuery = 'SELECT ' +
								'Id ' +
								',Name ' +
								',FTMSSO__c ' +
								',FTMSSO__r.Name ' +
								',FTMSSO__r.AccountedDate__c ' +
								',InvoiceTo__c ' +
								',InvoiceTo__r.Name ' +
								',BillNameatPrintLocal__c ' +
								',BillNameatPrintENG__c ' +
								',PaymentConfirmedSelling__c ' +
								',AmountSellingInclTaxLocal__c ' +
								',AmountReceivedfromCustomerLocal__c ' +
								',UnreceivedBalanceofSellingLocal__c' +
								',AmountSellingInclTaxFCY__c ' +
								',AmountReceivedfromCustomer__c	 ' +
								',UnreceivedBalanceofSellingFCY__c ' +
								',ApplicantSelling__c ' +
								',ApplicantSelling__r.Name ' +
                                ',BeneficiaryBuying__c' +
                                ',BeneficiaryBuying__r.Name' +
								',toLabel(PaymentTypeSelling__c) ' +
								',PaymentSettledDateSelling__c ' +
								',BankAccountforReceipt__c ' +
								',BankAccountforReceipt__r.Name ' +
								',PaymentNotesSelling__c ' +
								',PaymentTo__c ' +
								',PaymentTo__r.Name ' +
								',PaymentConfirmedBuying__c ' +
								',AmountSellingInclTaxAdjustFCY__c ' +
								',AmountBuyingInclTaxAdjust_Local__c ' +
								',UnpaidBalanceofBuyingLocal__c ' +
								',AmountBuyingInclTaxFCY__c ' +
								',AmountPaidforCustomerFCY__c ' +
								',UnpaidBalanceofBuyingFCY__c ' +
								',toLabel(PaymentTypeBuying__c) ' +								
								',PaymentSettledDateBuying__c ' +
								',BankAccountforPayment__c ' +
								',BankAccountforPayment__r.Name ' +
								',PaymentNotesBuying__c ' +
								',CurrencySelling__c ' +
								',CurrencyBuying__c ' +	
								',AdvancePaymentonbehalfofCustomer__c ' +	
								',FTMSSO__r.House_Bill__c ' +
								',FTMSSO__r.JobRequestID__c ' +
							'FROM FTMSBill__c ';
		if (isReceivable) {
			soqlQuery += 'WHERE (UnreceivedBalanceofSellingLocal__c > 0 ';
			soqlQuery += 'OR UnreceivedBalanceofSellingFCY__c > 0) ';
			soqlQuery += 'AND AmountSellingInclTaxLocal__c >=: amount ';
			soqlQuery += 'AND UnreceivedBalanceofSellingLocal__c >=: unpaid ';
			soqlQuery += 'AND CurrencySelling__c =: currencyOption ';


			if (String.isNotBlank(customerId)) {			
				soqlQuery += 'AND InvoiceTo__c =: customerId ';
			}

			if (isAdvance != null) {
				soqlQuery += 'AND AdvancePaymentonbehalfofCustomer__c =: isAdvance ';
			}
		} else {
			soqlQuery += 'WHERE (UnpaidBalanceofBuyingLocal__c > 0 ';
			soqlQuery += 'OR UnpaidBalanceofBuyingFCY__c > 0) ';
			soqlQuery += 'AND AmountBuyingInclTaxFCY__c >=: amount ';
			soqlQuery += 'AND UnpaidBalanceofBuyingLocal__c >=: unpaid ';
			soqlQuery += 'AND CurrencyBuying__c =: currencyOption ';

			if (String.isNotBlank(customerId)) {			
				soqlQuery += 'AND PaymentTo__c =: customerId ';
			}

			if (isAdvance != null) {
				soqlQuery += 'AND AdvancePaymentonbehalfofOurCompany__c =: isAdvance ';
			}
		}


		if (dateFrom != null) {
			soqlQuery += 'AND FTMSSO__r.AccountedDate__c >=: dateFrom ';
		}

		if (dateTo != null) {
			soqlQuery += 'AND FTMSSO__r.AccountedDate__c <=: dateTo ';
		}

		if (!orderNoList.isEmpty()) {			
			soqlQuery += 'AND FTMSSO__r.Name LIKE: orderNoList';
		}
		System.debug('query : '+soqlQuery);
		List<FTMSBill__c> ankenMeisaiList = Database.query(soqlQuery);
		if (ankenMeisaiList == null) {
			ankenMeisaiList = new List<FTMSBill__c>();
		}

		return ankenMeisaiList;
	}
}