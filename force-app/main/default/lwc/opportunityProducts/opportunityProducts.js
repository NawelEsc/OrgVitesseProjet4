import { LightningElement, api, track, wire } from 'lwc';
import getOpportunityProducts from '@salesforce/apex/OpportunityProductsController.getOpportunityProducts';
import USER_ID from '@salesforce/user/Id';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import PROFILE_NAME_FIELD from '@salesforce/schema/User.Profile.Name';
import deleteOpportunityLineItem from '@salesforce/apex/OpportunityProductsController.deleteOpportunityLineItem';
import { refreshApex } from '@salesforce/apex';

export default class OpportunityProducts extends LightningElement {
    @api recordId;
    @track products;
    isAdmin = false;

    // Profil utilisateur
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

    wiredProductsResult;

    // Récupération des produits
    @wire(getOpportunityProducts, { opportunityId: '$recordId' })
        wiredProducts(result) {
        console.log('RECORD ID:', this.recordId);
        this.wiredProductsResult = result;
        const { data, error } = result;


        if (data) {
            // Ajout du flag d’erreur pour le point 6
            this.products = data.map(prod => ({
                ...prod,
                hasStockError: prod.quantityInStock < prod.quantity,
                stockClass: prod.quantityInStock < prod.quantity ? 'slds-text-color_error' : ''
            }));
        } else if (error) {
            console.error('Erreur Apex : ', error);
            this.products = [];
        }
    }

    // Bouton Voir produit (admin)
    viewProductColumn = {
        type: 'button',
        typeAttributes: {
            label: 'Voir produit',
            name: 'view_product',
            variant: 'brand',
            title: 'Voir produit'
        }
    };

    // Bouton Supprimer
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

    // Colonnes demandées
    baseColumns = [
        { label: 'Nom du produit', fieldName: 'productName', type: 'text' },
        { label: 'Quantité', fieldName: 'quantity', type: 'number' },
        { label: 'Prix unitaire', fieldName: 'unitPrice', type: 'currency' },
        { label: 'Prix Total', fieldName: 'totalPrice', type: 'currency' },

        // Point 6 : case rouge si stock insuffisant
        {
            label: 'Quantité en Stock',
            fieldName: 'quantityInStock',
            type: 'number',
            cellAttributes: {
                class: { fieldName: 'stockClass' }
            }
        }
    ];

    // Colonnes finales selon profil
    get columns() {
        const cols = [...this.baseColumns];
        cols.push(this.deleteColumn);
        if (this.isAdmin) {
            cols.push(this.viewProductColumn);
        }
        return cols;
    }

    // Condition d’affichage du tableau
    get hasProducts() {
        return Array.isArray(this.products) && this.products.length > 0;
    }

    // Point 7 : message d’erreur global
    get hasGlobalError() {
        return this.products && this.products.some(p => p.hasStockError);
    }

    // Gestion des actions
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

    // Suppression réelle
    handleDelete(row) {
        deleteOpportunityLineItem({ oliId: row.oliId })
            .then(() => {
                return refreshApex(this.wiredProductsResult);
            })
            .catch(error => {
                console.error('Erreur suppression : ', error);
            });
    }

    // Point 5 : Voir produit
    handleViewProduct(row) {
        window.location.href = `/lightning/r/Product2/${row.productId}/view`;
    }
}



