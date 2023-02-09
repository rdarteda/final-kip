global class FinanceDataSourceConnection extends DataSource.Connection {
  /** Constructor for FinanceDataSourceConnection **/
  global FinanceDataSourceConnection (DataSource.ConnectionParams connectionParams) { }
  
  override global List<DataSource.Table> sync() {
    List<DataSource.Table> tables = new List<DataSource.Table>();        
    // Reward Fields
    List<DataSource.Column> rewardColumns = new List<DataSource.Column>() ;
    // rewardColumns.add(DataSource.Column.externalLookup('RealtorID', 'Realtor__x'));
    rewardColumns.add(DataSource.Column.text('ExternalId', 255)); // required
    rewardColumns.add(DataSource.Column.url('DisplayUrl')); // required
    rewardColumns.add(DataSource.Column.text('rewardProgram', 255));
    rewardColumns.add(DataSource.Column.number('total', 7, 0));
    // Add and Create Reward Table
    tables.add(DataSource.Table.get('Reward', 'Reward', rewardColumns));
    return tables;
  }
    
  override global DataSource.TableResult query(DataSource.QueryContext context) {
    return DataSource.TableResult.get(context, DataSource.QueryUtils.process(context, getRows()));
  }

  override global List<DataSource.TableResult> search(DataSource.SearchContext context) {        
    List<DataSource.TableResult> results = new List<DataSource.TableResult>();
    for (DataSource.TableSelection tableSelection : context.tableSelections) {
      results.add(DataSource.TableResult.get(tableSelection, getRows()));
    }
    System.debug('returned results '+results);
    return results;
  }
    
  private List<Map<String, Object>> getRows () {
    // Get row field values from the external system via a callout.
    HttpResponse response = makeGetCallout();
    Map<String, Object> datalist = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());

    Map<String, Object> error = (Map<String, Object>)datalist.get('error');
    if (error != null) {
      throwException(string.valueOf(error.get('message')));
    }
    List<Map<String,Object>> rows = new List<Map<String,Object>>();
    List<Object> jsonRows = (List<Object>)datalist.get('list');

    if (jsonRows == null) {
      rows.add(foundRow(datalist));
    } else {
      for (Object jsonRow : jsonRows) {
        Map<String,Object> row = (Map<String,Object>)jsonRow;
        rows.add(foundRow(row));
      }
    }
    return rows;
  }
  
  // Helper methods
  
  // Populate a row based on values from the external system.
  private Map<String,Object> foundRow(Map<String,Object> newRow) {
    Map<String,Object> row = new Map<String,Object>();
    System.debug('stringNewRow ' + string.valueOf(newRow.get('Id')));
    String id = string.valueOf(newRow.get('Id'));
    row.put('ExternalId', id);
    row.put('DisplayUrl', string.valueOf(newRow.get('DisplayUrl')));
    row.put('rewardProgram', string.valueOf(newRow.get('rewardProgram')));   
    row.put('total', string.valueOf(newRow.get('total')));   
    return row;
  }
      
  // Make a GET callout
  private static HttpResponse makeGetCallout() {
    // create HTTP request
    HttpRequest req = new HttpRequest();
    req.setEndpoint('callout:authTest_for_apex/rewards/');
    req.setMethod('GET');
    // Send the request and get the HTTP response.
    HttpResponse res = new Http().send(req);
    return res;
  }
}
