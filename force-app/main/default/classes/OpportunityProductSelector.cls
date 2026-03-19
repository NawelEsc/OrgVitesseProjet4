public with sharing class OpportunityProductSelector {

    /**
     * Récupère les lignes d’opportunité liées à une opportunité.
     */
    public static List<OpportunityLineItem> getByOpportunityId(Id opportunityId) {
        if (opportunityId == null) {
            return new List<OpportunityLineItem>();
        }

        return [
            SELECT Id,
                   OpportunityId,
                   Quantity,
                   UnitPrice,
                   TotalPrice,
                   PricebookEntry.Product2Id,
                   PricebookEntry.Product2.Name,
                   PricebookEntry.Product2.StockKeepingUnit,
                   PricebookEntry.Product2.QuantityInStock__c
            FROM OpportunityLineItem
            WHERE OpportunityId = :opportunityId
        ];
    }

    /**
     * Récupère une ligne d’opportunité par son Id.
     */
    public static OpportunityLineItem getOpportunityLineItemById(Id oliId) {
        List<OpportunityLineItem> items = [
            SELECT Id
            FROM OpportunityLineItem
            WHERE Id = :oliId
            LIMIT 1
        ];
        return items.isEmpty() ? null : items[0];
    }

    /**
     * Récupère le nom du profil d’un utilisateur.
     */
    public static String getUserProfileName(Id userId) {
        List<User> users = [
            SELECT Profile.Name
            FROM User
            WHERE Id = :userId
            LIMIT 1
        ];
        return users.isEmpty() ? null : users[0].Profile.Name;
    }
}

