@isTest
private class OpportunityProductsActionsTest {

    @isTest
    static void testDeleteOpportunityLineItem_Success() {

        Id stdPriceBookId = Test.getStandardPricebookId();

        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Product2 prod = new Product2(
            Name = 'Produit Test',
            IsActive = true
        );
        insert prod;

        PricebookEntry pbe = new PricebookEntry(
            Product2Id = prod.Id,
            Pricebook2Id = stdPriceBookId,
            UnitPrice = 100,
            IsActive = true
        );
        insert pbe;

        Opportunity opp = new Opportunity(
            Name = 'Opp Test',
            StageName = 'Prospecting',
            CloseDate = System.today(),
            AccountId = acc.Id,
            Pricebook2Id = stdPriceBookId
        );
        insert opp;

        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId = opp.Id,
            Quantity = 2,
            PricebookEntryId = pbe.Id,
            TotalPrice = 200
        );
        insert oli;

        Test.startTest();
        OpportunityProductsActions.deleteOpportunityLineItem(oli.Id);
        Test.stopTest();

        System.assertEquals(0, [
            SELECT COUNT() FROM OpportunityLineItem WHERE Id = :oli.Id
        ]);
    }

    @isTest
    static void testDeleteOpportunityLineItem_NullId() {

        Test.startTest();
        try {
            OpportunityProductsActions.deleteOpportunityLineItem(null);
            System.assert(false, 'Une exception aurait dû être levée');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('identifiant de la ligne'));
        }
        Test.stopTest();
    }

    @isTest
    static void testGetCurrentUserProfile() {

        Test.startTest();
        String profileName = OpportunityProductsActions.getCurrentUserProfile();
        Test.stopTest();

        System.assertNotEquals(null, profileName);
        System.assert(profileName.length() > 0);
    }
}
