import { api, LightningElement, track, wire } from 'lwc';
import getCaseInfo from '@salesforce/apex/ProductInfoController.getCaseInfo';
import getProductInfo from '@salesforce/apex/ProductInfoController.getProductInfo';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ProductInfoComp extends LightningElement {
    @track showSpinner = false;
    @track productCharges = [];
    @track hasProducts = false;
    @api recordId;
    @track case = {};

getCaseInfo(){
    this.showSpinner = true;
    getCaseInfo( {caseId : this.recordId})
    .then(result =>{

        console.log('case: ' + JSON.stringify(result));
        this.case = result;
        this.getProductInfo();
    
    
    }).catch(error =>{
        console.log('error: ' + JSON.stringify(error));
        this.showToast('Error', error, 'error');
        this.showSpinner = false;
    });

}
getProductInfo(){

    getProductInfo( {productId : this.case.Contact.Product__c, country:this.case.Contact.Home_Country__c })
    .then(result =>{
        
        this.productCharges = result;
        console.log('productCharges: ' + JSON.stringify(this.productCharges));
        if(this.productCharges.length > 0) this.hasProducts = true;
        this.showSpinner = false;
    
    }).catch(error =>{
        console.log('error: ' + JSON.stringify(error));
        this.showToast('Error', error, 'error');
        this.isLoading = false;
    });

}


    //lifecycle hook fires when a component is inserted into the DOM
    connectedCallback(){
        this.getCaseInfo();
    
     
    }

    showToast(toastTitle, toastMessage, toastType){
        this.dispatchEvent(
            new ShowToastEvent({
                title: toastTitle,
                message: toastMessage,
                variant: toastType,
            }),
        );
    }
}