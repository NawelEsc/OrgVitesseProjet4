public with sharing class UserProfileController {

    @AuraEnabled
    public static String getUserProfileName() {
        User u = [
            SELECT Id, Profile.Name
            FROM User
            WHERE Id = :UserInfo.getUserId()
            LIMIT 1
        ];

        return u.Profile.Name;
    }
}


