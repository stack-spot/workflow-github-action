# StackSpot Workflow Action

This action execute StackSpot Workflow

## Example usage

```yaml
- name: Stack Spot Workflow
  uses: stack-spot/workflow-github-action
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

### Customizing main and feature branch names

- To customize the name of main branch you can use `origin-branch` optional parameter.
- To customize the name of feature branch created to open PR you can use `feature-branch` optional parameter.

Example:

```yaml
- name: Stack Spot Workflow
  uses: stack-spot/workflow-github-action
  with:
    execution-id: "${{ github.event.inputs.execution-id }}"
    client-id: "${{ secrets.CLIENT_ID }}"
    client-secret: "${{ secrets.CLIENT_SECRET }}"
    realm: "${{ secrets.REALM }}"
    debug: "${{ github.event.inputs.debug }}"
    repository-url: "${{ github.event.inputs.repository-url }}"
    origin-branch: "develop"
    feature-branch: "my-custom-feature-branch"
- name: Logs CLI
  if: failure()
  run: sudo cat /home/runner/work/_temp/_github_home/.stk/logs/logs.log
- name: Debug Http
  if: "${{ inputs.debug == 'true' && always() }}"
  run: sudo cat /home/runner/work/_temp/_github_home/.stk/debug/http.txt
```
