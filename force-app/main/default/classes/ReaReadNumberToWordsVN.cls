public with sharing class ReaReadNumberToWordsVN {
    private static final String[] ones = new String[]{
        '', 'một', 'hai', 'ba', 'bốn', 'lăm', 'sáu', 'bảy', 'tám', 'chín', 'mười',
        'mười một', 'mười hai', 'mười ba', 'mười bốn', 'mười lăm', 'mười sáu', 'mười bảy',
        'mười tám', 'mười chín'
    };
    private static final String[] tens = new String[]{
        '', '', 'hai mươi', 'ba mươi', 'bốn mươi', 'năm mươi', 'sáu mươi', 'bảy mươi', 'tám mươi', 'chín mươi'
    };
    private static final String[] units = new String[]{
        '', 'nghìn', 'triệu', 'tỷ'
    };

    private static String convertThreeDigitNumber(Integer NCv) {
        String word = '';
		
        Integer hundreds = NCv / 100;
        if (hundreds > 0) {
            word += ones[hundreds] + ' trăm ';
        }

        Integer tensAndOnes = Math.mod(NCv, 100);
        if (tensAndOnes != 0) {
            if (tensAndOnes < 20) {
                word += ones[tensAndOnes];
            } else {
                Integer tensDigit = tensAndOnes / 10; 
                Integer onesDigit = Math.mod(tensAndOnes, 10);
                word += tens[tensDigit] + ' ' + ones[onesDigit];
            }
            
        }
        return word.trim();
    }

    public static String convertToVietnamese(Integer NCv) {
        if (NCv == 0) {
            return 'không';
        }

        String result = '';
        Integer unitIndex = 0;

        do {
            Integer currentNumber = Math.mod(NCv, 1000);
            if (currentNumber != 0) {
                String currentWord = convertThreeDigitNumber(currentNumber);
                result = currentWord + ' ' + units[unitIndex] + ' ' + result;
            }
            unitIndex++;
            NCv = NCv / 1000 ;
        } while (NCv > 0);
        result =  result.trim();
        String chuoiDaVietHoa = result.substring(0, 1).toUpperCase() + result.substring(1);
        return chuoiDaVietHoa;
    }

    public ReaReadNumberToWordsVN() {

    }
}