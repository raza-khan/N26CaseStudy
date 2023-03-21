/*Class: CustomeProductRestResource
 * Description: The purpose of this class have write the rest API for the external
 * .            system to retrieve the data of customer product from Salesforce
 * 
 * 
 * **/
 @RestResource(urlMapping='/CustomerProductInfo/*')
global with sharing class CustomerProductRestResource {
    
    /* Method:doGet
     * This method is being provide the implementation of Http Get which is 
     * being invoked from. the external system and send UUID of the customer
     *  and it return product information in response.
     * 
     * */
    @HttpGet
    global static CustomerProductWrapper doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String uuid = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        
        CustomerProductWrapper jsonResponse = getCustomerProductInfo(uuid);
        return jsonResponse;
    }
    
    /* Method:getCustomerProductJson
     * This method is helper method to generate the response for the given
     *  customer Id
     * 
     * */
    private static CustomerProductWrapper getCustomerProductInfo( String uuid )
    {
       
        CustomerProductWrapper wrapper = new CustomerProductWrapper();
        CustomerProductWrapper.Status status = new CustomerProductWrapper.Status();
        wrapper.status = status;
        status.statusCode = 200;
        status.message = '';
        try{
            List<Contact> customers = [SELECT Id,name, Product__c,Product__r.name, Phone, Home_Country__c, UUID__c  
                                       FROM Contact WHERE UUID__c  =: uuid];
            
            if(customers != null && customers.size() > 0){
                Contact cont = customers[0];
                if(cont.Product__c != null){
                    
                    wrapper.customerName = cont.Name;
                    wrapper.country = cont.Home_Country__c;
                    wrapper.productName = cont.Product__r.Name;
                    wrapper.uUid = cont.UUID__c;
                    wrapper.serviceCharges = new List<CustomerProductWrapper.ServiceCharge>();
                    
                    for(Service_Charge__c service: [SELECT Id, Service__r.Name, Cost__c, Country__c, Product__r.Name, 
                                                    Percent_Cost__c,Currency_Code__c,Is_Free__c FROM Service_Charge__c 
                                                    WHERE Product__c=:cont.Product__c And Country__c =: cont.Home_Country__c])
                    {
                        CustomerProductWrapper.ServiceCharge serviceCharge = new CustomerProductWrapper.ServiceCharge();
                        serviceCharge.serviceName = service.Service__r.Name;
                        serviceCharge.chargesAmount = service.Cost__c;
                        serviceCharge.chargesPercent = service.Percent_Cost__c;
                        // since multi currency cannot be enabled in Dev org so created a custom field
                        if( wrapper.currencyCode == null )
                            wrapper.currencyCode = service.Currency_Code__c;
                        serviceCharge.isFfree = service.Is_Free__c;
                       
                        wrapper.serviceCharges.add(serviceCharge);
                    }
                   
                    
                }else{
                    status.statusCode = 400;
                    status.message = Label.CPRESTR_BAD_REQ_400_NO_PRODUCT_SUBSCRIBED;
                    
                    
                }
                
            }else{
                status.statusCode = 400;
                status.message = Label.CPRESTR_BAD_REQ_400_NO_RECORD_FOUND;
               
                
            }
        }Catch(Exception ex){
             status.statusCode = 500;
            status.message = ex.getMessage();
            
        }
        return wrapper;  
        
    }
}