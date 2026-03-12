public with sharing class OpportunityProductSelector {

    public static List<OpportunityLineItem> getByOpportunityId(Id opportunityId) {
        return [
            SELECT Id,
                   OpportunityId,
                   Quantity,
                   UnitPrice,
                   PricebookEntry.Product2Id,
                   PricebookEntry.Product2.Name,
                   PricebookEntry.Product2.StockKeepingUnit,
                   PricebookEntry.Product2.QuantityInStock__c
                 FROM OpportunityLineItem
            WHERE OpportunityId = :opportunityId
        ];
    }
}
