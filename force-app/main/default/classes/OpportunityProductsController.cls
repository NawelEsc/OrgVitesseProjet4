public with sharing class OpportunityProductsController {

    // Wrapper pour structurer les données envoyées au LWC
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
        //Appel au selector
         List<OpportunityLineItem> oliList = OpportunityProductSelector.getByOpportunityId(opportunityId);

        for (OpportunityLineItem oli : oliList) {
            String pName = (oli.PricebookEntry != null && oli.PricebookEntry.Product2 != null) ? oli.PricebookEntry.Product2.Name : null;
            String sku = (oli.PricebookEntry != null && oli.PricebookEntry.Product2 != null) ? oli.PricebookEntry.Product2.StockKeepingUnit : null;
            Decimal qtyInStock = (oli.PricebookEntry != null && oli.PricebookEntry.Product2 != null) ? oli.PricebookEntry.Product2.QuantityInStock__c : null;

        results.add(new OpportunityProductWrapper(
            oli.Id,
            oli.PricebookEntry.Product2Id,
            pName,
            sku,
            oli.Quantity,
            oli.UnitPrice,
            oli.TotalPrice,
            qtyInStock
        ));

        }

        return results;
    }

}
