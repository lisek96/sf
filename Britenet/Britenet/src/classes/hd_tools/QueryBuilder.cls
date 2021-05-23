public with sharing class QueryBuilder {
    private String query;

    public QueryBuilder(String initial){
        query=initial + ' ';
    }

    public List<SObject> executeQuery(){
        return Database.query(query);
    }
    public QueryBuilder withWhere(){
        query+='WHERE ';
        return this;
    }

    public QueryBuilder withAnd(){
        query+='AND ';
        return this;
    }
    public QueryBuilder withOr(){
        query+='OR ';
        return this;
    }

    public QueryBuilder withLikeStartsWith(String field, String value){
        query+=field+' LIKE ' + '\'' +String.escapeSingleQuotes(value) + '%\'' + ' ';
        return this;
    }

    public QueryBuilder withEquals(String field, String value){
        query+=field+' = ' + '\'' + String.escapeSingleQuotes(value) + '\'' + ' ';
        return this;
    }

    public QueryBuilder withLike(String field, string value){
        query+=field+' LIKE ' + '\'%' + String.escapeSingleQuotes(value) + '%\'' + ' ';
        return this;
    }

    public QueryBuilder withLeftParentheses(){
        query+=' ( ';
        return this;
    }

    public QueryBuilder withRightParentheses(){
        query+= ' ) ';
        return this;
    }
}