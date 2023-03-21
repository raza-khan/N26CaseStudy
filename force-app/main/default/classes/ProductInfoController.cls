/* Class: ProductInfoController
 * Description: It is the controller for 'ProductInfo' component
 *  to display the product information the customer rlelated to
 *  case being viewed.
 * 
 * */
public class ProductInfoController {
    
    // To get the information of the customer from the given case id
    @AuraEnabled
    public static Case getCaseInfo(Id caseId){
        
        Case caseRecord; 
        try{
            List<Case> cases = [SELECT Id,ContactId,Contact.Name, Contact.Home_Country__c,Contact.Product__c,Contact.Product__r.name FROM Case WHERE Id =:caseId];
            if(cases.size() > 0){
                caseRecord = cases[0];
            } 
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return caseRecord; 
    }
    
	// To get the information of the customer product
    @AuraEnabled
    public static List<Service_Charge__c> getProductInfo(Id productId, String country)
    {
        List<Service_Charge__c> productInfo = new List<Service_Charge__c>();
        try{
            if(productId != null && country != null){
                productInfo = [SELECT Id, Service__r.Name, Cost__c, Country__c, Product__r.Name, Percent_Cost__c,Currency_Code__c
                               FROM Service_Charge__c  WHERE Product__c=:productId And Country__c =: country];
                
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return productInfo;
    }
    
    
}