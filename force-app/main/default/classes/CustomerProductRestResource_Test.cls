@istest
public class CustomerProductRestResource_Test {
     @testSetup
    Private static void setupData()
    {
        Product2 prod = new Product2(name = 'Standard');
        insert prod;
        
        Service__c ser =new Service__c(name = 'Card Replacement Cost');
        Service__c ser2 =new Service__c(name = 'ATM Fee in other currencies');
        Service__c ser3 =new Service__c(name = 'Cost per Calendar Month');
        insert new List<Service__c>{ser,ser2, ser3};
            
            Service_Charge__c cost = new Service_Charge__c(Product__c = prod.id,
                                                             Service__c = ser.id,
                                                             Cost__c = double.valueOf(12),
                                                             Currency_Code__c = 'EUR',
                                                             Country__c = 'DE');
        Service_Charge__c cost2 = new Service_Charge__c(Product__c = prod.id,
                                                          Service__c = ser2.id,
                                                          Cost__c = double.valueOf(12),
                                                          Country__c = 'DE');
        Service_Charge__c cost3 = new Service_Charge__c(Product__c = prod.id,
                                                          Service__c = ser3.id,
                                                          Cost__c = double.valueOf(12),
                                                          Country__c = 'DE');
        insert new List<Service_Charge__c>{cost, cost2, cost3};
            
            Contact  cont = new Contact(lastname = 'Test',
                                        Product__c = prod.Id,
                                        UUID__c = '12345',
                                        Home_Country__c = 'DE');
        insert cont;
        
    }
    
    @isTest
    private static void testHttpPost() {
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/CustomerProduct/12345'; 
        req.httpMethod = 'GET';
        
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        CustomerProductWrapper productInformation = CustomerProductRestResource.doGet();
        Test.stopTest();
        
        System.assertEquals('Standard', productInformation.productName);
        System.assertEquals('DE', productInformation.country);
        System.assertEquals(3, productInformation.serviceCharges.size());
    }
    @isTest
    private static void invalidCustomerIdHttpPost() {
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/CustomerProduct/123456'; 
        req.httpMethod = 'GET';
        
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        CustomerProductWrapper productInformation = CustomerProductRestResource.doGet();
        Test.stopTest();
         System.assertEquals(400, productInformation.status.statusCode );
        System.assertEquals(Label.CPRESTR_BAD_REQ_400_NO_RECORD_FOUND, productInformation.status.message );
        
    }
     @isTest
    private static void noProductAssignedHttpPost() {
        
        Contact contactToUpdate = [Select id, Product__c from Contact where UUID__c = '12345'  limit 1];
        contactToUpdate.Product__c = null;
        update contactToUpdate;
        
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/CustomerProduct/12345'; 
        req.httpMethod = 'GET';
        
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        CustomerProductWrapper productInformation = CustomerProductRestResource.doGet();
        Test.stopTest();
        System.assertEquals(400, productInformation.status.statusCode );
        System.assertEquals(Label.CPRESTR_BAD_REQ_400_NO_PRODUCT_SUBSCRIBED, productInformation.status.message );
        
    }

}