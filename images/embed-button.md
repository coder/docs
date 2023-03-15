# Embeddable button

You can embed an **Open in Coder** button into a repository's README file to
provide developers with a one-click way to start contributing code. It
eliminates much of the effort required to set up a development environment,
allowing users to begin contributing faster.

When a user clicks on the **Open in Coder** button, they will be directed to the
specified Coder deployment and prompted to login if they don't already have an
active session. Coder then builds a workspace based on the image specified.
Coder will also clone the repository into the workspace's `/home/coder` folder.
At this point, the user can open the IDE and begin working.

![The Embed Button](../assets/images/embed-1.png)

## Requirements

- You must have Git and SSH installed on your image
- Coder must be [integrated with a supported Git provider](../admin/git.md)
- You must
  [link your Coder account](../workspaces/preferences.md#linked-accounts) to the
  service of your choice. This step is required for anyone who wants to use the
  button to launch a project using the provided image and repo.

## Create the embedded button's code

Coder can automatically generate the code you need to embed the Open in Coder
button.

1. In the Coder UI, go to **Images**. Find the image you want to use and click
   to open.
1. Underneath the name of the image, click **Embed**.
1. Choose the **Image Tag** and **Git Service** you want to use, and provide
   your **Git Repository URI**.
1. Once you fill in the required fields, Coder generates the code you need in
   Markdown or HTML (you can change the button's display text by modifying the
   Markdown or HTML snippets). Copy the code and paste it into your repository's
   README.md file.

![Create embed button](../assets/images/embed-2.png)
