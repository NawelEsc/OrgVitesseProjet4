import { LightningElement, api, track, wire } from 'lwc';
import getOpportunityProducts from '@salesforce/apex/OpportunityProductsController.getOpportunityProducts';
import USER_ID from '@salesforce/user/Id';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import PROFILE_NAME_FIELD from '@salesforce/schema/User.Profile.Name';

export default class OpportunityProducts2 extends LightningElement {
    @api recordId;
    @track products;
    isAdmin = false;

    @wire(getRecord, { recordId: USER_ID, fields: [PROFILE_NAME_FIELD] })
    wiredUser({ data, error }) {
        if (data) {
            const profileName = getFieldValue(data, PROFILE_NAME_FIELD);
            this.isAdmin = profileName === 'System Administrator';
        } else if (error) {
            console.error('Erreur récupération profil utilisateur (LDS): ', error);
            this.isAdmin = false;
        }
    }

    @wire(getOpportunityProducts, { opportunityId: '$recordId' })
    wiredProducts({ data, error }) {
        if (data) {
            this.products = data;
        } else if (error) {
            console.error('Erreur Apex : ', error);
            this.products = [];
        }
    }

    viewProductColumn = {
        type: 'button',
        typeAttributes: {
            label: 'Voir produit',
            name: 'view_product',
            variant: 'brand',
            title: 'Voir produit'
        }
    };

    deleteColumn = {
        type: 'button-icon',
        typeAttributes: {
            iconName: 'utility:delete',
            name: 'delete',
            title: 'Supprimer',
            variant: 'border-filled',
            alternativeText: 'Supprimer'
        },
        label: 'Supprimer'
    };

    baseColumns = [
        { label: 'Produit', fieldName: 'productName', type: 'text' },
        { label: 'SKU', fieldName: 'sku', type: 'text' },
        { label: 'Quantité', fieldName: 'quantity', type: 'number' },
        { label: 'Prix unitaire', fieldName: 'unitPrice', type: 'currency' },
        { label: 'Total', fieldName: 'totalPrice', type: 'currency' },
        { label: 'Stock disponible', fieldName: 'quantityInStock', type: 'number' }
    ];

    get columns() {
        const cols = [...this.baseColumns];
        cols.push(this.deleteColumn);
        if (this.isAdmin) {
            cols.push(this.viewProductColumn);
        }
        return cols;
    }

    get hasProducts() {
        return Array.isArray(this.products) && this.products.length > 0;
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;

        switch (actionName) {
            case 'delete':
                this.handleDelete(row);
                break;
            case 'view_product':
                this.handleViewProduct(row);
                break;
        }
    }

    handleDelete(row) {
        console.log('Suppression demandée pour : ', row);
    }

    handleViewProduct(row) {
        console.log('Voir produit : ', row);
    }
}


