global class PublicationConnection extends DataSource.Connection {
    override global List<DataSource.TableResult> search(DataSource.SearchContext searchContext) {
        return DataSource.SearchUtils.searchByName(searchContext, this);
    }
    
    override global List<DataSource.Table> sync() {
        List<DataSource.Column> columns = new List<DataSource.Column>();
        columns.add(DataSource.Column.text('ExternalId', 255));
        columns.add(DataSource.Column.url('DisplayUrl'));
        columns.add(DataSource.Column.text('Name', 128));
        columns.add(DataSource.Column.text('Description', 500));
        List<DataSource.Table> tables = new List<DataSource.Table>();
        tables.add(DataSource.Table.get('Publications', 'Name', columns));
        return tables;
    }
    
    override global DataSource.TableResult query(DataSource.QueryContext queryContext) {
        List<Map<String, Object>> publications = DataSource.QueryUtils.process(queryContext, getPublications());
        DataSource.TableResult tableResult = DataSource.TableResult.get(queryContext, publications);
        return tableResult;
    }
    public List<Map<String, Object>> getPublications() {
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        String url = 'https://conference-lwc-app.herokuapp.com/api/sessions/';
        request.setEndPoint(url);
        request.setMethod('GET');
        HttpResponse response = httpProtocol.send(request);
        List<Map<String, Object>> publications = new List<Map<String, Object>>();
        Map<String, Object> res = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        for (Object item : (List<Object>)res.get('data')) {
            Map<String, Object> publication = (Map<String, Object>)item;
            publication.put('ExternalId', publication.get('id'));
            publication.put('DisplayUrl', 'https://conference-lwc-app.herokuapp.com/');
            publication.put('Name', publication.get('name'));
            publication.put('Description', publication.get('description'));
            publications.add(publication);
        }
        return publications;
    }
    
}
