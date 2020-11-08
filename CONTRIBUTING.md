# Contributing

## Layouts

To reduce the amount of HTML in our markdown, Handlebars templates are used.

### Example

Renders a comparison of how to perform an action in the dashboard vs. the CLI.

```md
{{#example}}
{{#dashboard}}

Dashboard content here.

{{/dashboard}}
{{#cli}}

CLI content here.

{{/cli}}
{{/example}}
```

## Variables

| Name              | Description                     |
| ----------------- | ------------------------------- |
| {{@product_name}} | Name of the product referenced. |
