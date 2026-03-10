public with sharing class OpportunityProductsActions {

    @AuraEnabled
    public static void deleteOpportunityLineItem(Id oliId) {
        if (oliId == null) {
            throw new AuraHandledException('L\'identifiant de la ligne est manquant.');
        }

        OpportunityLineItem oli = [
            SELECT Id
            FROM OpportunityLineItem
            WHERE Id = :oliId
            LIMIT 1
        ];

        delete oli;
    }

    @AuraEnabled(cacheable=true)
    public static String getCurrentUserProfile() {
        User u = [
            SELECT Profile.Name
            FROM User
            WHERE Id = :UserInfo.getUserId()
            LIMIT 1
        ];
        return u.Profile.Name;
    }
}
