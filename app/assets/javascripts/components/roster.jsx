import SortHelpers from '../helpers/sort_helpers.jsx';

window.shared || (window.shared = {});

export default React.createClass({
  displayName: 'Roster',

  propTypes: {
    rows: React.PropTypes.arrayOf(React.PropTypes.object).isRequired,
    columns: React.PropTypes.arrayOf(React.PropTypes.object).isRequired,
    initialSort: React.PropTypes.string
  },

  getInitialState () {
    return {
      sortBy: this.props.initialSort,
      sortDesc: true
    };
  },

  orderedRows () {
    const sortedRows = this.sortedRows();

    if (!this.state.sortDesc) return sortedRows.reverse();

    return sortedRows;
  },

  sortedRows () {
    const rows = this.props.rows;
    const sortBy = this.state.sortBy;
    
    return rows.sort((a, b) => SortHelpers.sortByString(a, b, sortBy));
  },
    
  onClickHeader(sortBy) {
    if (sortBy === this.state.sortBy) {
      this.setState({ sortDesc: !this.state.sortDesc });
    } else {
      this.setState({ sortBy: sortBy});
    }
  },

  headerClassName (sortBy) {
    // Using tablesort classes here for the cute CSS carets,
    // not for the acutal table sorting JS (that logic is handled by this class).

    if (sortBy !== this.state.sortBy) return 'sort-header';

    if (this.state.sortDesc) return 'sort-header sort-down';

    return 'sort-header sort-up';
  },
  
  render () {
    return (
      <div className='Roster'>
        <table className='roster-table' style={{ width: '100%' }}>
          <thead>
            {this.renderSuperHeaders()}
            {this.renderHeaders()}
          </thead>
          {this.renderBody()}
        </table>
      </div>
    );
  },

  renderSuperHeaders() {
    var currentCount = 0;
    const columns = this.props.columns;


    var superHeaders = [];

    for (var i=0; i<columns.length; i++) {
      currentCount++;
      
      // if this is the last column 
      // or this column group differs from the next colum group,
      // push the super header with a length of currentCount
      // and reset currentCount for a new column group

      if(i+1 == columns.length || columns[i].group != columns[i+1].group) {
        superHeaders.push({label: columns[i].group, span: currentCount});
        currentCount = 0;
      }
    }

    return (
      <tr className='column-groups'>
        {superHeaders.map((superHeader, index) => {
          return (
            <th key={index} colSpan={superHeader.span}>
              {superHeader.label}
            </th>
          );
        },this)}
      </tr>
    );
  },

  renderHeaders() {
    return (
      <tr id='roster-header'>
        {this.props.columns.map(column => {
          return (
            <th key={column.key} onClick={this.onClickHeader.bind(null, column.key)}
                className={this.headerClassName(column.key)}>
              {column.label}
            </th>
        );
      }, this)}
      </tr>
    );
  },

  renderBodyValue(item, column) {
    if ('cell' in column) {
      return column.cell(item,column);
    } 
    else {
      return item[column.key]
    }
  },

  renderBody() {
    return (
      <tbody id='roster-data'>
        {this.orderedRows().map(row => {
          return (
            <tr  key={row.id}>
              {this.props.columns.map(column => {
                return (
                  <td key={row.id + column.key}>
                    {this.renderBodyValue(row, column)}
                  </td>
                );
              }, this)}
            </tr>
          );
        }, this)}
      </tbody>
    );
  }
});
