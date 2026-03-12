import { createElement } from '@lwc/engine-dom';
import OpportunityProducts from 'c/opportunityProducts';

// Mock LDS getRecord
jest.mock(
    'lightning/uiRecordApi',
    () => {
        return {
            getRecord: jest.fn()
        };
    },
    { virtual: true }
);

// Mock Apex
jest.mock(
    '@salesforce/apex/OpportunityProductsController.getOpportunityProducts',
    () => ({
        default: jest.fn()
    }),
    { virtual: true }
);

describe('c-opportunity-products', () => {

    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    });

    it('renders the component', () => {
        const element = createElement('c-opportunity-products', {
            is: OpportunityProducts
        });
        element.recordId = '006XXXXXXXXXXXX';
        document.body.appendChild(element);

        expect(element).not.toBeNull();
    });

    it('shows delete button for all users and view product button for admins', async () => {
        const element = createElement('c-opportunity-products', {
            is: OpportunityProducts
        });
        element.recordId = '006XXXXXXXXXXXX';
        document.body.appendChild(element);

        // Simule un utilisateur admin
        element.isAdmin = true;

        await Promise.resolve();

        const columns = element.columns;

        expect(columns.some(col => col.typeAttributes?.name === 'delete')).toBe(true);
        expect(columns.some(col => col.typeAttributes?.name === 'view_product')).toBe(true);
    });
});


