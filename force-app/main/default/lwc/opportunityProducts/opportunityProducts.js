import { LightningElement, api, track, wire } from 'lwc';
import getOpportunityProducts from '@salesforce/apex/OpportunityProductsController.getOpportunityProducts';

export default class OpportunityProducts extends LightningElement {
    @api recordId;
    @track products;

    @wire(getOpportunityProducts, { opportunityId: '$recordId' })
    wiredProducts({ error, data }) {
        if (data) {
            this.products = data;
        } else if (error) {
            console.error('Erreur Apex : ', error);
        }
    }
}
