@isTest
private class OpportunityProductsControllerTest {

    /**
     * Vérifie que getOpportunityProducts retourne correctement
     * les informations des OpportunityLineItem sous forme de wrapper.
     */
    @isTest
    static void testGetOpportunityProducts() {

        // Récupération du Pricebook standard pour les tests
        Id stdPriceBookId = Test.getStandardPricebookId();

        // Création d’un compte pour lier l’Opportunity
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Création d’un produit actif avec les champs utilisés dans le controller
        Product2 prod = new Product2(
            Name = 'Produit Test',
            StockKeepingUnit = 'SKU-123',
            QuantityInStock__c = 50,
            IsActive = true
        );
        insert prod;

        // Création d’un PricebookEntry actif lié au Pricebook standard
        PricebookEntry pbe = new PricebookEntry(
            Product2Id = prod.Id,
            Pricebook2Id = stdPriceBookId,
            UnitPrice = 100,
            IsActive = true
        );
        insert pbe;

        // Ligne envoyée par ton mentor, intégrée telle quelle
        Opportunity opp = new Opportunity(
            Name='test',
            TotalOpportunityQuantity=10,
            StageName='Hot',
            CloseDate=System.today(),
            Pricebook2Id=stdPriceBookId,
            AccountId=acc.Id
        );
        insert opp;

        // Création d’un OpportunityLineItem lié à l’Opportunity
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId = opp.Id,
            Quantity = 10,
            PricebookEntryId = pbe.Id,
            TotalPrice = 1000
        );
        insert oli;

        // Appel de la méthode du controller
        List<OpportunityProductsController.OpportunityProductWrapper> results =
            OpportunityProductsController.getOpportunityProducts(opp.Id);

        // Vérification : un seul produit doit être retourné
        System.assertEquals(1, results.size());

        // Vérification du contenu du wrapper
        OpportunityProductsController.OpportunityProductWrapper w = results[0];

        System.assertEquals('Produit Test', w.productName);
        System.assertEquals('SKU-123', w.sku);
        System.assertEquals(10, w.quantity);
        System.assertEquals(100, w.unitPrice);
        System.assertEquals(1000, w.totalPrice);
        System.assertEquals(50, w.quantityInStock);
    }
}






