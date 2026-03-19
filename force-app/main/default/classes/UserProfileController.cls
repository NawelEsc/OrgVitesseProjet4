public with sharing class UserProfileController {

    /**
     * Retourne le nom du profil de l’utilisateur connecté.
     */
    @AuraEnabled(cacheable=true)
    public static String getUserProfileName() {
        return OpportunityProductSelector.getUserProfileName(UserInfo.getUserId());
    }
}



