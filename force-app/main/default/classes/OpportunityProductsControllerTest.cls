@IsTest
public with sharing class OpportunityProductsControllerTest {

    @IsTest
    static void testGetOpportunityProducts() {

        // 1) Récupération du Pricebook standard
        Pricebook2 pb = [
            SELECT Id, IsActive
            FROM Pricebook2
            WHERE IsStandard = true
            LIMIT 1
        ];

        // ⚠️ Activation obligatoire dans les tests Apex
        pb.IsActive = true;
        update pb;

        // 2) Création du produit
        Product2 p = new Product2(
            Name = 'Produit Test',
            StockKeepingUnit = 'SKU123',
            QuantityInStock__c = 50,
            IsActive = true
        );
        insert p;

        // 3) Création du PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Product2Id = p.Id,
            Pricebook2Id = pb.Id,
            UnitPrice = 100,
            UseStandardPrice = false,
            IsActive = true
        );
        insert pbe;

        // 4) Création de l’Opportunity
        Opportunity opp = new Opportunity(
            Name = 'Opp Test',
            StageName = 'Prospecting',
            CloseDate = Date.today(),
            Pricebook2Id = pb.Id
        );
        insert opp;

        // 5) Création de l’OpportunityLineItem
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId = opp.Id,
            Quantity = 2,
            UnitPrice = 100,
            PricebookEntryId = pbe.Id
        );
        insert oli;

        // 6) Appel de la méthode Apex
        Test.startTest();
        List<OpportunityProductsController.OpportunityProductWrapper> results =
            OpportunityProductsController.getOpportunityProducts(opp.Id);
        Test.stopTest();

        // 7) Assertions
        System.assertEquals(1, results.size());
        System.assertEquals('Produit Test', results[0].productName);
        System.assertEquals('SKU123', results[0].sku);
        System.assertEquals(2, results[0].quantity);
        System.assertEquals(100, results[0].unitPrice);
        System.assertEquals(50, results[0].quantityInStock);
    }
}




