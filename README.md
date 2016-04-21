# syn-grids
Data grid components.

## Components

### syn-grid
Shows a grid base on inline json config.

**Example of use:**

```html
<syn-grid>
{
  head: {
    name: { label: 'Name', sort: true },
    surname: { label: 'Last Name' }
  },
  pagination: false,
  data: [
    { name: 'David', surname: 'Smith', age: 46 }
    { name: 'Susan', surname: 'Collins', age: 34 }
    { name: 'Joe', surname: 'Johnson', age: 34, email: 'joe@gmail.com' }
  ]
}
</syn-grid>
```
Output:

| Name  | Last Name |
|-------|:---------:|
| David | Smith     |
| Susan | Collins   |
| Joe   | Johnson   |

#### options

| Name | Type | Description |
|------|------|-------------|
| head | {Object} | Config of grid's head |
| head.foo | {Object} | Config options of the column |
| head.foo.label | {String} | Name of the column |
| head.foo.sort | {Boolean} | Wether column is sortable or not ( default: false ) |
| [pagination] | {Object} | Pagination config. Set to false to hide pagination |
| [pagination].buttons | {Number} | Number of page buttons to display ( default: 10 ) |
| [pagination].rowsPerPage | {Number} | Rows to display per page. ( default: 20 ) |
| [pagination].startPage | {Number} | First page to display ( default: 0 ) |
| [data] | {Object[]} | Data rows to display |

>To see a demo of components, execute gulp serve command and open this url in >a browser: http://localhost:3000/doc/demo/
