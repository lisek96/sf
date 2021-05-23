public with sharing class FieldsContainer {
    public FieldWrapper[] fields {get; set;}
    public FieldsContainer (List<FieldWrapper> fields){
        this.fields=fields;
    }
}