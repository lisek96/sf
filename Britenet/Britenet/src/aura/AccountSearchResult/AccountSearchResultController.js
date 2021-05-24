({
    doInit: function (component, event, helper) {
        var cols = [
            {
                'label': 'Name',
                'fieldName': 'Name',
                'type': 'text'
            },
            {
                'label': 'City',
                'fieldName': 'City',
                'type': 'text'
            },
            {
                'label': 'Country',
                'fieldName': 'Country',
                'type': 'text'
            },
            {
                'label': 'Website',
                'fieldName': 'Website',
                'type': 'url'
            },
            {
                'label': 'Action',
                'type': 'button',
                'typeAttributes': {
                    'label': 'View details',
                    'name': 'view_details'
                }
            }
        ];
        component.set('v.columns', cols);
    }
})