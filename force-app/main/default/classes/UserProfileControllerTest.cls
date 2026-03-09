@isTest
public class UserProfileControllerTest {

    @isTest
    static void testGetUserProfileName() {

        Test.startTest();
        String profileName = UserProfileController.getUserProfileName();
        Test.stopTest();

        System.assertNotEquals(null, profileName, 'Le nom du profil ne doit pas être null');
        System.assert(profileName.length() > 0, 'Le nom du profil doit contenir du texte');
    }
}
