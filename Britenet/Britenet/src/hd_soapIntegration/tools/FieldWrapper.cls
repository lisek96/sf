global class FieldWrapper {
    public String name {get; set;}
    public Object value {get; set;}

    public FieldWrapper(String name){
        this.name=name;
    }

    public FieldWrapper(String name, Object value) {
        this.name = name;
        this.value = value;
    }
}