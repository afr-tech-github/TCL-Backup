public class UpdateKhoanThuController {
    @AuraEnabled
    public static String getRecordTypeId(){
        //TODO: Need to clarify which spefic developer name record here
        return [SELECT Id,SobjectType FROM RecordType WHERE SobjectType = 'FTMSBill__c' AND DeveloperName = 'Selling_Buyging_Standard'].Id;
   
    }
    
	@AuraEnabled
    public static String getDescribeSobjectResult(){
		DescribeSobjectResult objResult = Schema.SObjectType.FTMSBill__c;
        return objResult.isCreateable() + '_' + objResult.isUpdateable() + '_' + objResult.isAccessible() + '_' + objResult.isDeletable();
    }
	@AuraEnabled
    public static List<FTMSBill__c> getAllBillingsInvoice(String shipmentId, Boolean isSelling){        
        List<FTMSBill__c> getBilling = new List<FTMSBill__c>();
        if(isSelling){
            getBilling =  [Select id FROM FTMSBill__c 
            WHERE FTMSSO__c = :shipmentId 
            AND InvoiceTo__c != null
            AND IssuedTaxInvSelling__c = true 
            // OR (UnitPriceofSellingLocal__c != 0 AND UnitPriceofSellingLocal__c != null))
            ORDER BY Name];
        } else {
            getBilling =  [Select id FROM FTMSBill__c 
                WHERE FTMSSO__c = :shipmentId 
                AND InvoiceTo__c != null
                AND IssuedTaxInvSelling__c = true 
                // OR (UnitPriceofBuyingLocal__c != 0 AND UnitPriceofBuyingLocal__c != null))
                ORDER BY Name];
        }
        return getBilling;
    }
    
    @AuraEnabled
    public static List<FTMSBill__c> getAllBillingsPayment(String shipmentId, Boolean isSelling){        
        List<FTMSBill__c> getBilling = new List<FTMSBill__c>();
        if(isSelling){
            getBilling =  [Select id FROM FTMSBill__c 
            WHERE FTMSSO__c = :shipmentId 
            AND PaymentTo__c != null
            AND IssuedTaxInvBuying__c = true 
            // OR (UnitPriceofSellingLocal__c != 0 AND UnitPriceofSellingLocal__c != null))
            ORDER BY Name];
        } else {
            getBilling =  [Select id FROM FTMSBill__c 
                WHERE FTMSSO__c = :shipmentId 
                AND PaymentTo__c != null
                AND IssuedTaxInvBuying__c = true 
                // OR (UnitPriceofBuyingLocal__c != 0 AND UnitPriceofBuyingLocal__c != null))
                ORDER BY Name];
        }
        return getBilling;
    }

	@AuraEnabled
    public static Boolean deleteBilling(String id){
        try {
            List<FTMSBill__c> billings = [Select Id FROM FTMSBill__c WHERE Id = :id];
            if(billings.size() == 0)
                return false;
            delete billings;
            return true;
        } catch (DmlException e) {
            throw e;
        }
    }

	@AuraEnabled
    public static String updateBillings(String jsonRecords, Boolean isSelling, Boolean isBuying, Boolean isVATRateSelling, Boolean isExchangeRateIDDebitCredit, Boolean isCurrencyConversionForSelling, Boolean isExchangeRateSellingDebit, Boolean isVATRateBuying, Boolean isExchangeRateBuyingCredit, Boolean isCurrencyConversionForBuying, Boolean isAdvancePaymentonbehalfofOurCompany ){
		List<FTMSBill__c> records = (List<FTMSBill__c>) JSON.deserialize(jsonRecords, List<FTMSBill__c>.class);
        System.debug('debug1 :'+records);
        Set<Id> ids = (new Map<Id,SObject>(records)).keySet();
        System.debug('Idd :'+ids);
        List<FTMSBill__c>  billings = [SELECT Id,Name,InvoiceSBDisplayNo__c,Service__c,InvoiceTo__c,PaymentTo__c,

        MVCSmadvcsselling__c,
        Mkhchmakhselling__c,
        Ngimuahngongbaselling__c,
        Dingiidiengiaiselling__c,
        Tknmanxselling__c,
        Ngyctngayctselling__c,
        Quynctmaqsselling__c,
        Shsoct__c,
        Tkdttkdt__c,
        Tnhhadvtenvt__c,
        vtdvt__c,
        SlngQsoluong__c,
        ngintP1giant2buying__c,  ngintP1giant2selling__c,
        ThnhtinntN1tiennt2buying__c,    ThnhtinntN1tiennt2selling__c,
        Tlcktlck__c,
        TinckntN1cknt__c,
        TinthuntN1thuent__c,
        Mntmant__c,
        TgiRtygia__c,
        ngiP0gia2__c,
        ThnhtinN0tien2__c,
        TinckN0ck__c,
        Mtsutmathuei__c,
        Thusutthuesuatibuying__c, Thusutthuesuatiselling__c,
        TinthuN0thuebuying__c, TinthuN0thueselling__c,
        Tkthutkthuei__c,
        Tkcktkck__c,
        Mkttmathck__c,
        HnttNhantt__c,
        Mdnmavvi__c,
        Mphmaphii__c,
        Mbphtmabphti__c,
        Mtd1matdi__c,
        Mtd2matd2i__c,
        Mtd3matd3i__c,
        SdngHTsdhddtyn__c,
        
   
 
        Shsoctselling__c,
        Tk_dt_tk_dtselling__c,
        T_n_h_h_a_d_v_ten_vtselling__c,
        vt_dvtselling__c,
        S_l_ng_Q_so_luongselling__c,
        T_l_ck_tl_ckselling__c,
        Ti_n_thu_n_t_N1_thue_ntselling__c,
        M_n_t_ma_ntselling__c,
        T_gi_R_ty_giaselling__c,
        n_gi_P0_gia2selling__c,
        Th_nh_ti_n_N0_tien2selling__c,
        Ti_n_ck_n_t_N1_ck_ntselling__c,
        Ti_n_ck_N0_ckselling__c,
        M_t_su_t_ma_thue_iselling__c,

        Tk_thu_tk_thue_iselling__c,
        Tk_ck_tk_ckselling__c,
        M_k_tt_ma_thckselling__c,
        H_n_tt_N_han_ttselling__c,
        
        M_ph_ma_phi_iselling__c,
        M_bpht_ma_bpht_iselling__c,
        M_td_1_ma_td_iselling__c,
        M_td_2_ma_td2_iselling__c,
        M_td_3_ma_td3_iselling__c,
        S_d_ng_H_T_sd_hddt_ynselling__c,


        ChargeQuantity__c,ChargeUnitinPrint__c,ChargeUnit__c,Print__c,CurrencySelling__c,AdvancePaymentonbehalfofCustomer__c,
        UnitPriceofSellingLocal__c,UnitPriceFCY__c,UnitPriceofSelling3rdCurrency__c,TaxRateSelling__c,VATrateselling__c,
        FxRateID__c,ExchangeRateSelling__c,CurrencyConversionforSelling__c,CurrencyBuying__c,ContainerType__c,
        BillNameatPrintENG__c,UnitPriceofBuyingLocal__c,UnitPriceofBuyingFCY__c,UnitPriceofBuying3rdCurrency__c,TaxRateBuying__c,VATratebuying__c,AdvancePaymentonbehalfofOurCompany__c,
        ExchangeRateBuying__c,CurrencyConversionforBuying__c
        FROM FTMSBill__c 
        WHERE Id in :ids];
        System.debug('debug2 :'+billings);

        
        List<FTMSBill__c> itemsIdsToRemove = new List<FTMSBill__c>();
        
        for(Integer i  = 0; i < records.size(); i++){
            FTMSBill__c r = records[i];
            itemsIdsToRemove.add(r);
    
                /*if(billings[i].Id == r.Id){
                    if(billings[i].InvoiceSBDisplayNo__c != r.InvoiceSBDisplayNo__c ||
                    billings[i].Service__c != r.Service__c ||
                    billings[i].BillNameatPrintENG__c != r.BillNameatPrintENG__c ||
                    billings[i].InvoiceTo__c != r.InvoiceTo__c ||
                    billings[i].PaymentTo__c != r.PaymentTo__c ||
                    billings[i].ChargeQuantity__c != r.ChargeQuantity__c ||
                    billings[i].ChargeUnitinPrint__c != r.ChargeUnitinPrint__c ||
                    billings[i].ChargeUnit__c != r.ChargeUnit__c ||
                    billings[i].ContainerType__c != r.ContainerType__c ||
                    billings[i].Print__c != r.Print__c ||
                    billings[i].CurrencySelling__c != r.CurrencySelling__c ||
                    billings[i].AdvancePaymentonbehalfofCustomer__c != r.AdvancePaymentonbehalfofCustomer__c ||
                    billings[i].UnitPriceofSellingLocal__c != r.UnitPriceofSellingLocal__c ||
                    billings[i].UnitPriceFCY__c != r.UnitPriceFCY__c ||
                    billings[i].UnitPriceofBuying3rdCurrency__c != r.UnitPriceofBuying3rdCurrency__c ||
                    billings[i].TaxRateSelling__c != r.TaxRateSelling__c ||
                    billings[i].FxRateID__c != r.FxRateID__c ||
                    billings[i].ExchangeRateSelling__c != r.ExchangeRateSelling__c ||
                    billings[i].CurrencyConversionforSelling__c != r.CurrencyConversionforSelling__c ||
                    billings[i].VATrateselling__c != r.VATrateselling__c ||
                    billings[i].CurrencyBuying__c != r.CurrencyBuying__c ||
                        billings[i].AdvancePaymentonbehalfofOurCompany__c != r.AdvancePaymentonbehalfofOurCompany__c ||
                        billings[i].UnitPriceofBuyingLocal__c != r.UnitPriceofBuyingLocal__c ||
                        billings[i].UnitPriceofBuyingFCY__c != r.UnitPriceofBuyingFCY__c ||
                        billings[i].UnitPriceofBuying3rdCurrency__c != r.UnitPriceofBuying3rdCurrency__c ||
                        billings[i].TaxRateBuying__c != r.TaxRateBuying__c ||
                        billings[i].ExchangeRateBuying__c != r.ExchangeRateBuying__c ||
                        billings[i].CurrencyConversionforBuying__c != r.CurrencyConversionforBuying__c ||
                        billings[i].VATratebuying__c != r.VATratebuying__c
                    ){
                        itemsIdsToRemove.add(r);
                    }
                    
                
            }*/
           
           
        }
        
        System.debug('debug3  :'+itemsIdsToRemove.size());
        try {
        	update itemsIdsToRemove;
        	return JSON.serialize(itemsIdsToRemove);
        }
        catch (Exception e) {
            throw new DmlException(e.getMessage());
        }
    }
}