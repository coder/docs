# Comparison

Coder offers both enterprise and open-source (code-server) solutions to meet the
remote development needs of organizations and individual developers. Both
solutions enable cloud-based software development delivered through the browser.
The key differences pertain to governance, development environment management,
availability of enterprise integrations (e.g., Git OAuth, SSO), and multi-IDE
support.

<table>
    <tr>
        <td></td>
        <th>Coder</th>
        <th><a href="https://github.com/coder/code-server">code-server</a></th>
    </tr>
    <tr>
        <th>Used by</th>
        <td>Organizations & teams</td>
        <td>Individuals</td>
    </tr>
    <tr>
        <th>Self-hosted on</th>
        <td>Kubernetes or Docker</td>
        <td>Any machine</td>
    </tr>
    <tr>
        <th>Cloud management</th>
        <td>Resources automatically scale; each organization
        defines quotas and limits</td>
        <td>None</td>
    </tr>
    <tr>
        <th>Environment management</th>
        <td>Project code, configuration, dependencies, and tooling as a container</td>
        <td>Code-only</td>
    </tr>
    <tr>
        <th>IDE support</th>
        <td>VS Code, JetBrains (e.g., IntelliJ, PyCharm), Jupyter, RStudio</td>
        <td>VS Code</td>
    </tr>
    <tr>
        <th>Administration & security</th>
        <td>Role-based permission system, audit logs, single sign-on</td>
        <td>Self-administered</td>
    </tr>
    <tr>
        <th>Enterprise integrations</th>
        <td>Git (SSH key, OAuth), SSO via OIDC, public cloud identity</td>
        <td>Self-administered</td>
    </tr>
    <tr>
        <th>Delivery</th>
        <td>Browser, progressive web app, local IDE with SSH</td>
        <td>Browser, progressive web app</td>
    </tr>
    <tr>
        <th>Maximum number of users</th>
        <td>Variable</td>
        <td>N/A - one connection allowed</td>
    </tr>
    <tr>
        <th>Usage term length</th>
        <td>Variable (<a target="_blank" href="https://coder.com/pricing">see Pricing</a>)</td>
        <td>See <a href="https://github.com/coder/code-server/blob/v3.5.0/LICENSE.txt">license</a></td>
    </tr>
    <tr>
        <th>Air-gapped deployment</th>
        <td>Optional</td>
        <td>Optional</td>
    </tr>
</table>

> To get a free trial of Coder, please visit
> [https://coder.com/trial](https://coder.com/trial). To evaluate Coder in an
> air-gapped network during the free trial period, please <a target="_blank"
> href="https://coder.com/contact">contact Sales</a>.
