public with sharing class OpportunityProductsActions {

    /**
     * Supprime une ligne d’opportunité.
     * Si l’Id est null, on ne fait rien (évite les erreurs dans les tests).
     */
    @AuraEnabled
    public static void deleteOpportunityLineItem(Id oliId) {
        if (oliId == null) {
            return;
        }

        OpportunityLineItem oli = [
            SELECT Id
            FROM OpportunityLineItem
            WHERE Id = :oliId
            LIMIT 1
        ];

        delete oli;
    }
}

