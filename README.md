# StackSpot Workflow Action

This action execute StackSpot Workflow

## Example usage

```yaml
- name: Stack Spot Workflow
  uses: stack-spot/workflow-github-actionle-flow
  with:
    execution-id: "${{ github.event.inputs.execution-id }}"
    client-id: "${{ secrets.CLIENT_ID }}"
    client-secret: "${{ secrets.CLIENT_SECRET }}"
    realm: "${{ secrets.REALM }}"
    debug: "${{ github.event.inputs.debug }}"
    repository-url: "${{ github.event.inputs.repository-url }}"
- name: Logs CLI
  if: failure()
  run: sudo cat /home/runner/work/_temp/_github_home/.stk/logs/logs.log
- name: Debug Http
  if: "${{ inputs.debug == 'true' && always() }}"
  run: sudo cat /home/runner/work/_temp/_github_home/.stk/debug/http.txt
```