public with sharing class ReadNumberToWords {
 
    private static final String[] tensNames = new String[] {
      '',
      ' TEN',
      ' TWENTY',
      ' THIRTY',
      ' FORTY',
      ' FIFTY',
      ' SIXTY',
      ' SEVENTY',
      ' EIGHTY',
      ' NINETY'
    };
   
    private static final String[] numNames = new String []{
      '',
      ' ONE',
      ' TWO',
      ' THREE',
      ' FOUR',
      ' FIVE',
      ' SIX',
      ' SEVEN',
      ' EIGHT',
      ' NINE',
      ' TEN',
      ' ELEVEN',
      ' TWELVE',
      ' THIRTEEN',
      ' FOURTEEN',
      ' FIFTEEN',
      ' SIXTEEN',
      ' SEVENTEEN',
      ' EIGHTEEN',
      ' NINETEEN'
    };
   
  
   
    private static String convertLessThanOneThousand(Integer number1) {
      String soFar = '';
       String convert ='';
      if (math.mod(number1,100) < 20){
        soFar = numNames[math.mod(number1,100)];
        number1 /= 100;
      }
      else {
        soFar = numNames[math.mod(number1,10)];
        number1 /= 10;
   
        soFar = tensNames[math.mod(number1,10)] + soFar;
        number1 /= 10;
      }
      if (number1 == 0) return soFar;
      convert = numNames[number1] +' HUNDRED'+ soFar;
        return convert;
    }
   
   
    public static String convert(Decimal number1) {
      // 0 to 999 999 999 999
      if (number1 == 0) { return 'ZERO'; }
   
      String snumber = String.valueOf(number1);
        System.debug('snumber:'+ snumber);
           System.debug('snumberlength:'+ snumber.length());
      // pad with '0'
      //String mask = '000000000000';
      //DecimalFormat df = new DecimalFormat(mask);
      //snumber = df.format(number1); 
      // 
      String[] ssnumber = snumber.split(',',2);
         String snumber1 = snumber.substringBefore('.');
      String snumber2 = snumber.substringAfter('.');
      String result = '';
        If (snumber1.length()<4){
            Integer thousands = Integer.valueOf(snumber1.substring(0,snumber1.length()));
                 String tradThousand = '';
                if(thousands > 0){
                  tradThousand = convertLessThanOneThousand(thousands);
                } 
                result = tradThousand ;
        }
        If (snumber1.length()>3 && snumber1.length()<7){
            Integer thousands = Integer.valueOf(snumber1.substring(snumber1.length()-3,snumber1.length()));
                 String tradThousand = '';
                if(thousands > 0){
                  tradThousand = convertLessThanOneThousand(thousands);
                } 
                result = tradThousand;
                Integer hundredThousands = Integer.valueOf(snumber1.substring(0,snumber1.length()-3));
                String tradHundredThousands = '';
                if(hundredThousands > 0){
                  tradHundredThousands = convertLessThanOneThousand(hundredThousands)+ ' THOUSAND ';
                } 
                result = tradHundredThousands + result ;
        }
        If (snumber1.length()<10 && snumber1.length()>6){
            Integer thousands = Integer.valueOf(snumber1.substring(snumber1.length()-3,snumber1.length()));
                 String tradThousand = '';
                if(thousands > 0){
                  tradThousand = convertLessThanOneThousand(thousands);
                } 
                result = tradThousand;
                Integer hundredThousands = Integer.valueOf(snumber1.substring(snumber1.length()-6,snumber1.length()-3));
                String tradHundredThousands = '';
                if(hundredThousands > 0){
                  tradHundredThousands = convertLessThanOneThousand(hundredThousands)+ ' THOUSAND ';
                }
                result = tradHundredThousands + result;
                Integer millions  = Integer.valueOf(snumber1.substring(0,snumber1.length()-6));
                String tradMillions = '';
                if(millions > 0){
                  tradMillions = convertLessThanOneThousand(millions)+ ' MILLION ';
                } 
                 result = tradMillions + result;
        }
        If (snumber1.length()>9){
            Integer thousands = Integer.valueOf(snumber1.substring(snumber1.length()-3,snumber1.length()));
                 String tradThousand = '';
                if(thousands > 0){
                  tradThousand = convertLessThanOneThousand(thousands);
                }
                result = tradThousand;
                Integer hundredThousands = Integer.valueOf(snumber1.substring(snumber1.length()-6,snumber1.length()-3));
                String tradHundredThousands = '';
                if(hundredThousands > 0){
                  tradHundredThousands = convertLessThanOneThousand(hundredThousands)+ ' THOUSAND ';
                }
                result = tradHundredThousands + result;
                Integer millions  = Integer.valueOf(snumber1.substring(snumber1.length()-9,snumber1.length()-6));
                String tradMillions = '';
                if(millions > 0){
                  tradMillions = convertLessThanOneThousand(millions)+ ' MILLION ';
                }
                 result = tradMillions + result;
                Integer billions = Integer.valueOf(snumber1.substring(0,snumber1.length()-9));
                String tradBillions = '';
                if(billions > 0){
                  tradBillions = convertLessThanOneThousand(billions)+ ' BILLION ';
                } 
                result = tradBillions + result;
        }
        Integer cent = Integer.valueOf(snumber2);
        String tradCent = '';
                if(cent > 0){
                  tradCent = ' AND '+ convertLessThanOneThousand(Cent);
                }
                result =result + tradCent;
      return result.replaceAll('^\\s+', '').replaceAll('\\b\\s{2,}\\b', ' ');
    }
  }