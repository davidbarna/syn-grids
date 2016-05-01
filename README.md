# syn-grids
Data grid components.

## Components

### syn-grid
Shows a grid base on inline json config.

#### options

| Name | Type | Description |
|------|------|-------------|
| cells | {Object} | Options of grid's cells |
| cells.foo | {Object} | Options options of the cells of `foo` property |
| cells.foo.filter | {Function} | A filter for the view. The function will be called and its result will be placed in the cell, instead of original value
| cells.foo.classes | {Array} | List of css classes to add to each cell of `foo` property |
| cells.foo.buttons | {Object} | List of buttons to add inside each cell of `foo` property |
| cells.foo.buttons[bar] | {Object} | Config for a button |
| cells.foo.buttons[bar].* | {Object} | Any of the mentioned options of `cells.foo` |
| cells.foo.on | {Object} | List of callbacks for events |
| cells.foo.on[eventName] | {Array, Function} | Call to call on event's triggering |
| head.foo | {Object} | Options options of the column |
| head.foo.label | {String} | Name of the column |
| head.foo.sort | {Boolean} | Wether column is sortable or not ( default: false ) |
| head.foo.* | {*} | Any option available in `cells`  |
| [pagination] | {Object} | Pagination config. Set to false to hide pagination |
| [pagination].buttons | {Number} | Number of page buttons to display ( default: 10 ) |
| [pagination].rowsPerPage | {Number} | Rows to display per page. ( default: 20 ) |
| [pagination].startPage | {Number} | First page to display ( default: 0 ) |
| [data] | {Object[]} | Data rows to display |

**Example of use:**

```html
<script>
$scope.gridConfig = {
  head: {
    name: { label: 'Name', sort: true },
    surname: { label: 'Last Name' }
  },
  cells: {
    name:
      filter: function(key, value, item) {
        return value + " (" + item.age + ")"
      }
  },
  pagination: false,
  data: [
    { name: 'David', surname: 'Smith', age: 46 }
    { name: 'Susan', surname: 'Collins', age: 34 }
    { name: 'Joe', surname: 'Johnson', age: 34, email: 'joe@gmail.com' }
  ]
}
</script>
<syn-grid options="gridConfig">
```
Output:

| Name  | Last Name |
|-------|:---------:|
| David (46) | Smith     |
| Susan (34) | Collins   |
| Joe (34)   | Johnson   |

>To see a demo of components, execute gulp serve command and open this url in >a browser: http://localhost:3000/docs/
