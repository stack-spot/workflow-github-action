# StackSpot Workflow Action

This action execute StackSpot Workflow

## Example usage

```yaml
  - name: Stack Spot Workflow
    uses: ./
    with:
      execution-id: "${{ github.event.inputs.execution-id }}"
      client-id: "${{ secrets.CLIENT_ID }}"
      client-secret: "${{ secrets.CLIENT_SECRET }}"
      realm: "${{ vars.REALM }}"
      debug: "${{ github.event.inputs.debug }}"
      repository-url: "${{ github.event.inputs.repository-url }}"
      origin-branch: develop
      feature-branch: my-custom-feature-branch-${{ env.TIMESTAMP }}
      extra-inputs: '{"teste": "teste"}'
```
