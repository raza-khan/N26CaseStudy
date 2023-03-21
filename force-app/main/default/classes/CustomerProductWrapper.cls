/* CustomProductWrapper:
 * Description: It is the wrapper clss to generate 
 * the response of customer api in json format.
* 
* */
global class CustomerProductWrapper {
    Public string customerName {get; set;}
    public string uuId { get; set; }
    public string productName { get; set; }
    public string country { get; set; }
    Public List<ServiceCharge> serviceCharges { get; set; }
    public string currencyCode { get; set; }
    public Status status {get; set;}
    
    
    public class ServiceCharge{
        public string serviceName { get; set; }
        public Decimal chargesPercent { get; set; }
        public Decimal chargesAmount { get; set; }
        public boolean isFfree { get; set; }
        
    }
    // to send the error message in case of any issue
    public class Status{
        public integer statusCode {get; set; }
        public string message { get; set; }
    }
    
}