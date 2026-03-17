import OpportunityProducts_Title from '@salesforce/label/c.OpportunityProducts_Title';
import OpportunityProducts_NoLines from '@salesforce/label/c.OpportunityProducts_NoLines';
import OpportunityProducts_Global_Error from '@salesforce/label/c.OpportunityProducts_Global_Error';

import OpportunityProducts_Column_ProductName from '@salesforce/label/c.OpportunityProducts_Column_ProductName';
import OpportunityProducts_Column_Quantity from '@salesforce/label/c.OpportunityProducts_Column_Quantity';
import OpportunityProducts_Column_Unit_Price from '@salesforce/label/c.OpportunityProducts_Column_Unit_Price';
import OpportunityProducts_Column_Total_Price from '@salesforce/label/c.OpportunityProducts_Column_Total_Price';
import OpportunityProducts_Column_Quantity_In_Stock from '@salesforce/label/c.OpportunityProducts_Column_Quantity_In_Stock';

import OpportunityProducts_Action_View_Product from '@salesforce/label/c.OpportunityProducts_Action_View_Product';
import OpportunityProducts_Action_Delete_Tooltip from '@salesforce/label/c.OpportunityProducts_Action_Delete_Tooltip';

import OpportunityProducts_Select_Pricebook from '@salesforce/label/c.OpportunityProducts_Select_Pricebook';
import OpportunityProducts_Select_Products from '@salesforce/label/c.OpportunityProducts_Select_Products';

import OpportunityProducts_Error_Loading from '@salesforce/label/c.OpportunityProducts_Error_Loading';
import OpportunityProducts_Error_Update from '@salesforce/label/c.OpportunityProducts_Error_Update';
import OpportunityProducts_Error_Delete from '@salesforce/label/c.OpportunityProducts_Error_Delete';
import OpportunityProducts_Error_Stock from '@salesforce/label/c.OpportunityProducts_Error_Stock';

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

    label = {
        OpportunityProducts_Title,
        OpportunityProducts_NoLines,
        OpportunityProducts_Global_Error,

        OpportunityProducts_Column_ProductName,
        OpportunityProducts_Column_Quantity,
        OpportunityProducts_Column_Unit_Price,
        OpportunityProducts_Column_Total_Price,
        OpportunityProducts_Column_Quantity_In_Stock,

        OpportunityProducts_Action_View_Product,
        OpportunityProducts_Action_Delete_Tooltip,

        OpportunityProducts_Select_Pricebook,
        OpportunityProducts_Select_Products,

        OpportunityProducts_Error_Loading,
        OpportunityProducts_Error_Update,
        OpportunityProducts_Error_Delete,
        OpportunityProducts_Error_Stock
    };

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

    @wire(getOpportunityProducts, { opportunityId: '$recordId' })
    wiredProducts(result) {
        this.wiredProductsResult = result;
        const { data, error } = result;

        if (data) {

            // 🔥 AJOUT EXACT DU CONSOLE.LOG
            console.log('DATA FROM APEX:', JSON.stringify(data));

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

    viewProductColumn = {
        type: 'button',
        typeAttributes: {
            label: OpportunityProducts_Action_View_Product,
            name: 'view_product',
            variant: 'brand',
            title: OpportunityProducts_Action_View_Product
        }
    };

    deleteColumn = {
        type: 'button-icon',
        typeAttributes: {
            iconName: 'utility:delete',
            name: 'delete',
            title: OpportunityProducts_Action_Delete_Tooltip,
            variant: 'border-filled',
            alternativeText: OpportunityProducts_Action_Delete_Tooltip
        },
        label: OpportunityProducts_Action_Delete_Tooltip
    };

    baseColumns = [
        { label: OpportunityProducts_Column_ProductName, fieldName: 'productName', type: 'text' },
        { label: OpportunityProducts_Column_Quantity, fieldName: 'quantity', type: 'number' },
        { label: OpportunityProducts_Column_Unit_Price, fieldName: 'unitPrice', type: 'currency' },
        { label: OpportunityProducts_Column_Total_Price, fieldName: 'totalPrice', type: 'currency' },
        {
            label: OpportunityProducts_Column_Quantity_In_Stock,
            fieldName: 'quantityInStock',
            type: 'number',
            cellAttributes: {
                class: { fieldName: 'stockClass' }
            }
        }
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

    get hasGlobalError() {
        return this.products && this.products.some(p => p.hasStockError);
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
        deleteOpportunityLineItem({ oliId: row.oliId })
            .then(() => refreshApex(this.wiredProductsResult))
            .catch(error => {
                console.error('Erreur suppression : ', error);
            });
    }

    handleViewProduct(row) {
        window.location.href = `/lightning/r/Product2/${row.productId}/view`;
    }
}





