@isTest
private class OpportunityProductsControllerTest {

    @isTest
    static void testGetOpportunityProducts() {

        // Récupération du Pricebook standard
        Id stdPriceBookId = Test.getStandardPricebookId();

        // Compte
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Produit
        Product2 prod = new Product2(
            Name = 'Produit Test',
            StockKeepingUnit = 'SKU-123',
            QuantityInStock__c = 50,
            IsActive = true
        );
        insert prod;

        // PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Product2Id = prod.Id,
            Pricebook2Id = stdPriceBookId,
            UnitPrice = 100,
            IsActive = true
        );
        insert pbe;

        // Opportunity
        Opportunity opp = new Opportunity(
            Name = 'Test Opp',
            StageName = 'Hot',
            CloseDate = System.today(),
            TotalOpportunityQuantity = 10,
            Pricebook2Id = stdPriceBookId,
            AccountId = acc.Id
        );
        insert opp;

        // OpportunityLineItem
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId = opp.Id,
            Quantity = 10,
            PricebookEntryId = pbe.Id,
            TotalPrice = 1000
        );
        insert oli;

        // 🔥 OBLIGATOIRE pour exécuter les méthodes cacheable
        Test.startTest();

        List<OpportunityProductsController.OpportunityProductWrapper> results =
            OpportunityProductsController.getOpportunityProducts(opp.Id);

        Test.stopTest();

        // Vérifications
        System.assertEquals(1, results.size());

        OpportunityProductsController.OpportunityProductWrapper w = results[0];

        System.assertEquals('Produit Test', w.productName);
        System.assertEquals('SKU-123', w.sku);
        System.assertEquals(10, w.quantity);
        System.assertEquals(100, w.unitPrice);
        System.assertEquals(1000, w.totalPrice);
        System.assertEquals(50, w.quantityInStock);
    }
}







