@isTest
public class UserProfileControllerTest {

    @isTest
    static void testGetUserProfileName() {

        // Création d’un utilisateur de test
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];

        User u = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser' + System.currentTimeMillis() + '@example.com',
            Alias = 'tuser',
            TimeZoneSidKey = 'Europe/Paris',
            LocaleSidKey = 'fr_FR',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'fr',
            ProfileId = p.Id
        );
        insert u;

        Test.startTest();

        // Exécution en tant que l’utilisateur de test
        System.runAs(u) {
            String profileName = UserProfileController.getUserProfileName();
            System.assertNotEquals(null, profileName);
            System.assert(profileName.length() > 0);
        }

        Test.stopTest();
    }
}

