# Demo repository to demonstrate GitHub Copilot's app modernization capabilities + deployment to Azure Kubernetes Service (AKS)

# Step 1: Show how GitHub Copilot agent can help to modernize the node JS application
- explain github copilot agent mode (explain agents)
- explain tools/mcp
- kick-off modernization using github copilot agent

```
have a look at #file:js-app  and update it to the latest node js version. after you are done upgrading, run the app and test it.
```

- wait until ghcp is finished

# Step 2: Show how spec-kit can help to modernize the Python application
- explain and show spec-kit usage
- show generated spec-kit elements
- show clarify

````
update #file:python-app to the latest python version. after the upgrade, run the app and test it
````

- kick-off modernization using spec-kit
- wait until ghcp is finished

# Step 3: Show how the GitHub Copilot app modernization - upragde for Java can help to modernize the Java application
- explain and show GitHub Copilot app modernization - upgrade for Java usage
- kick-off modernization using GitHub Copilot app modernization - upgrade for Java
- wait until ghcp is finished

# Step 4: Show how to containerize the modernized applications
- use GHCP to containerize the Python application
- show Dockerfile for Node JS application
- show Dockerfile for Java application

# Step 5: Show how to use the Azure, Azure Developer CLI and Bicep MCP servers to deploy the modernized applications to AKS
- explain Azure MCP, BICEP, Azure Developer CLI
- show already created Bicep files
- use azd to deploy the Node JS application to AKS
- use azd to deploy the Python application to AKS
- use azd to deploy the Java application to AKS