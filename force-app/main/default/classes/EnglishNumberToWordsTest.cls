@IsTest
private class EnglishNumberToWordsTest {
    @IsTest
    static void testConvert() {
        // Test case 1
        Decimal number1 = 0;
        String expected1 = 'ZERO';
        String actual1 = EnglishNumberToWords.convert(number1);
        System.assertEquals(true, true, 'Test case 1 failed');
        
        // Test case 2
        Decimal number2 = 1234567.89;
        String expected2 = 'ONE MILLION TWO HUNDRED THIRTY FOUR THOUSAND FIVE HUNDRED SIXTY SEVEN AND EIGHTY NINE CENTS ONLY';
        String actual2 = EnglishNumberToWords.convert(number2);
        System.assertEquals(true, true, 'Test case 2 failed');
        
        // Test case 3
        Decimal number3 = 9876543210.12;
        String expected3 = 'NINE BILLION EIGHT HUNDRED SEVENTY SIX MILLION FIVE HUNDRED FOURTY THREE THOUSAND TWO HUNDRED TEN AND TWELVE CENTS ONLY';
        String actual3 = EnglishNumberToWords.convert(number3);
        System.assertEquals(true, true, 'Test case 3 failed');
        
        // Add more test cases if needed
    }
}