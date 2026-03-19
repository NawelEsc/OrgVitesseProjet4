@isTest
public class OpportunityProductsActionsTest {

@isTest
static void testDeleteOpportunityLineItem_NullId() {
    Test.startTest();
    OpportunityProductsActions.deleteOpportunityLineItem(null);
    Test.stopTest();
    // Rien à vérifier : on veut juste que ça ne plante pas
}
    @isTest
    static void testDeleteOpportunityLineItem_ValidId() {

        // Préparation des données obligatoires
        Id stdPriceBookId = Test.getStandardPricebookId();

        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Product2 prod = new Product2(Name='Produit Test', IsActive=true);
        insert prod;

        PricebookEntry pbe = new PricebookEntry(
            Product2Id = prod.Id,
            Pricebook2Id = stdPriceBookId,
            UnitPrice = 10,
            IsActive = true
        );
        insert pbe;

        Opportunity opp = new Opportunity(
            Name='Opp Test',
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

        // Exécution de la méthode
        Test.startTest();
        OpportunityProductsActions.deleteOpportunityLineItem(oli.Id);
        Test.stopTest();

        // Vérification : la ligne doit être supprimée
        Integer countOli = [
            SELECT COUNT() 
            FROM OpportunityLineItem 
            WHERE Id = :oli.Id
        ];

        System.assertEquals(0, countOli, 'La ligne d’opportunité aurait dû être supprimée');
    }
}

