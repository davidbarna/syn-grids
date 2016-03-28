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
    name: { label: 'Name' },
    surname: { label: 'Last Name' },
  },
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

>To see a demo of components, execute gulp serve command and open this url in >a browser: http://localhost:3000/doc/demo/
