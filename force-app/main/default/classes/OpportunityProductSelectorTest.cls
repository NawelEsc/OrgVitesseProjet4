@isTest
public class OpportunityProductSelectorTest {

    @isTest
    static void testGetByOpportunityId() {

        // Cas null
        List<OpportunityLineItem> emptyList = OpportunityProductSelector.getByOpportunityId(null);
        System.assertEquals(0, emptyList.size());

        // Préparation des données
        Id stdPriceBookId = Test.getStandardPricebookId();

        Account acc = new Account(Name = 'Test');
        insert acc;

        Product2 prod = new Product2(Name='P', IsActive=true);
        insert prod;

        PricebookEntry pbe = new PricebookEntry(
            Product2Id = prod.Id,
            Pricebook2Id = stdPriceBookId,
            UnitPrice = 10,
            IsActive = true
        );
        insert pbe;

        Opportunity opp = new Opportunity(
            Name='Opp',
            StageName='Prospecting',
            CloseDate=Date.today(),
            Pricebook2Id=stdPriceBookId,
            AccountId=acc.Id
        );
        insert opp;

        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId = opp.Id,
            Quantity = 1,
            PricebookEntryId = pbe.Id,
            TotalPrice = 10
        );
        insert oli;

        // Cas valide
        List<OpportunityLineItem> result = OpportunityProductSelector.getByOpportunityId(opp.Id);
        System.assertEquals(1, result.size());
    }

    @isTest
    static void testGetOpportunityLineItemById() {

        // Cas null
        OpportunityLineItem nullResult = OpportunityProductSelector.getOpportunityLineItemById(null);
        System.assertEquals(null, nullResult);

        // Préparation des données
        Id stdPriceBookId = Test.getStandardPricebookId();

        Account acc = new Account(Name = 'Test');
        insert acc;

        Product2 prod = new Product2(Name='P', IsActive=true);
        insert prod;

        PricebookEntry pbe = new PricebookEntry(
            Product2Id = prod.Id,
            Pricebook2Id = stdPriceBookId,
            UnitPrice = 10,
            IsActive = true
        );
        insert pbe;

        Opportunity opp = new Opportunity(
            Name='Opp',
            StageName='Prospecting',
            CloseDate=Date.today(),
            Pricebook2Id=stdPriceBookId,
            AccountId=acc.Id
        );
        insert opp;

        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId = opp.Id,
            Quantity = 1,
            PricebookEntryId = pbe.Id,
            TotalPrice = 10
        );
        insert oli;

        // Cas valide
        OpportunityLineItem result = OpportunityProductSelector.getOpportunityLineItemById(oli.Id);
        System.assertNotEquals(null, result);
    }
}
