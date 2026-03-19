public with sharing class OpportunityProductsController {

    // Wrapper utilisé par le LWC pour afficher les produits
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

    /**
     * Supprime une ligne d’opportunité.
     * (Requête déplacée dans le Selector)
     */
    @AuraEnabled
    public static void deleteOpportunityLineItem(Id oliId) {
        OpportunityLineItem oli = OpportunityProductSelector.getOpportunityLineItemById(oliId);
        delete oli;
    }

    /**
     * Récupère les produits d’une opportunité et les transforme en wrapper.
     */
    @AuraEnabled(cacheable=true)
    public static List<OpportunityProductWrapper> getOpportunityProducts(Id opportunityId) {
        List<OpportunityProductWrapper> results = new List<OpportunityProductWrapper>();

        if (opportunityId == null) {
            return results;
        }

        // Récupération via le Selector (SOQL centralisé)
        List<OpportunityLineItem> oliList = OpportunityProductSelector.getByOpportunityId(opportunityId);

        // Transformation en wrapper pour le LWC
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
