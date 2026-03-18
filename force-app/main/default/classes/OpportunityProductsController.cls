public with sharing class OpportunityProductsController {

    public class OpportunityProductWrapper {
        @AuraEnabled public String productName;
        @AuraEnabled public String sku;
        @AuraEnabled public Decimal quantity;
        @AuraEnabled public Decimal unitPrice;
        @AuraEnabled public Decimal totalPrice;
        @AuraEnabled public Decimal quantityInStock;
        @AuraEnabled public Id oliId;
        @AuraEnabled public Id productId;

        public OpportunityProductWrapper(
            Id oliId,
            Id productId,
            String productName,
            String sku,
            Decimal quantity,
            Decimal unitPrice,
            Decimal totalPrice,
            Decimal quantityInStock
        ) {
            this.oliId = oliId;
            this.productId = productId;
            this.productName = productName;
            this.sku = sku;
            this.quantity = quantity;
            this.unitPrice = unitPrice;
            this.totalPrice = totalPrice;
            this.quantityInStock = quantityInStock;
        }
    }

    @AuraEnabled
    public static void deleteOpportunityLineItem(Id oliId) {
        delete [SELECT Id FROM OpportunityLineItem WHERE Id = :oliId];
    }

    @AuraEnabled(cacheable=true)
    public static List<OpportunityProductWrapper> getOpportunityProducts(Id opportunityId) {
        List<OpportunityProductWrapper> results = new List<OpportunityProductWrapper>();

        if (opportunityId == null) {
            return results;
        }

        List<OpportunityLineItem> oliList = [
            SELECT Id,
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

        for (OpportunityLineItem oli : oliList) {
            results.add(new OpportunityProductWrapper(
                oli.Id,
                oli.PricebookEntry.Product2Id,
                oli.PricebookEntry.Product2.Name,
                oli.PricebookEntry.Product2.StockKeepingUnit,
                oli.Quantity,
                oli.UnitPrice,
                oli.TotalPrice,
                oli.PricebookEntry.Product2.QuantityInStock__c
            ));
        }

        return results;
    }
}

